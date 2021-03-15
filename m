Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC03433B785
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhCOOAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhCON7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B39C364D9E;
        Mon, 15 Mar 2021 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816727;
        bh=feoRGB0m9/7cM9bYnm40eLvBOV4SCiIQkTpYaUfRd20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=io3nJsMbCy2oZSjJwStUtEdsgh4LNxZmODi/U6IMpuELeIfq5CPKo+Z2JFg0UuGDv
         nRoPPV5f9GUHyYTOCc+ihQ88pusjhLtLwz5+loZhBnJuQw7TJ567xBfN/HsUUsF8Ej
         gs6g5d3dzVDh0Izagfncv0T+2JBm5mLZkQvEQkW0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 078/290] bnxt_en: reliably allocate IRQ table on reset to avoid crash
Date:   Mon, 15 Mar 2021 14:52:51 +0100
Message-Id: <20210315135544.551794867@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Edwin Peer <edwin.peer@broadcom.com>

commit 20d7d1c5c9b11e9f538ed4a2289be106de970d3e upstream.

The following trace excerpt corresponds with a NULL pointer dereference
of 'bp->irq_tbl' in bnxt_setup_inta() on an Aarch64 system after many
device resets:

    Unable to handle kernel NULL pointer dereference at ... 000000d
    ...
    pc : string+0x3c/0x80
    lr : vsnprintf+0x294/0x7e0
    sp : ffff00000f61ba70 pstate : 20000145
    x29: ffff00000f61ba70 x28: 000000000000000d
    x27: ffff0000009c8b5a x26: ffff00000f61bb80
    x25: ffff0000009c8b5a x24: 0000000000000012
    x23: 00000000ffffffe0 x22: ffff000008990428
    x21: ffff00000f61bb80 x20: 000000000000000d
    x19: 000000000000001f x18: 0000000000000000
    x17: 0000000000000000 x16: ffff800b6d0fb400
    x15: 0000000000000000 x14: ffff800b7fe31ae8
    x13: 00001ed16472c920 x12: ffff000008c6b1c9
    x11: ffff000008cf0580 x10: ffff00000f61bb80
    x9 : 00000000ffffffd8 x8 : 000000000000000c
    x7 : ffff800b684b8000 x6 : 0000000000000000
    x5 : 0000000000000065 x4 : 0000000000000001
    x3 : ffff0a00ffffff04 x2 : 000000000000001f
    x1 : 0000000000000000 x0 : 000000000000000d
    Call trace:
    string+0x3c/0x80
    vsnprintf+0x294/0x7e0
    snprintf+0x44/0x50
    __bnxt_open_nic+0x34c/0x928 [bnxt_en]
    bnxt_open+0xe8/0x238 [bnxt_en]
    __dev_open+0xbc/0x130
    __dev_change_flags+0x12c/0x168
    dev_change_flags+0x20/0x60
    ...

Ordinarily, a call to bnxt_setup_inta() (not in trace due to inlining)
would not be expected on a system supporting MSIX at all. However, if
bnxt_init_int_mode() does not end up being called after the call to
bnxt_clear_int_mode() in bnxt_fw_reset_close(), then the driver will
think that only INTA is supported and bp->irq_tbl will be NULL,
causing the above crash.

In the error recovery scenario, we call bnxt_clear_int_mode() in
bnxt_fw_reset_close() early in the sequence. Ordinarily, we will
call bnxt_init_int_mode() in bnxt_hwrm_if_change() after we
reestablish communication with the firmware after reset.  However,
if the sequence has to abort before we call bnxt_init_int_mode() and
if the user later attempts to re-open the device, then it will cause
the crash above.

We fix it in 2 ways:

1. Check for bp->irq_tbl in bnxt_setup_int_mode(). If it is NULL, call
bnxt_init_init_mode().

2. If we need to abort in bnxt_hwrm_if_change() and cannot complete
the error recovery sequence, set the BNXT_STATE_ABORT_ERR flag.  This
will cause more drastic recovery at the next attempt to re-open the
device, including a call to bnxt_init_int_mode().

Fixes: 3bc7d4a352ef ("bnxt_en: Add BNXT_STATE_IN_FW_RESET state.")
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8430,10 +8430,18 @@ static void bnxt_setup_inta(struct bnxt
 	bp->irq_tbl[0].handler = bnxt_inta;
 }
 
+static int bnxt_init_int_mode(struct bnxt *bp);
+
 static int bnxt_setup_int_mode(struct bnxt *bp)
 {
 	int rc;
 
+	if (!bp->irq_tbl) {
+		rc = bnxt_init_int_mode(bp);
+		if (rc || !bp->irq_tbl)
+			return rc ?: -ENODEV;
+	}
+
 	if (bp->flags & BNXT_FLAG_USING_MSIX)
 		bnxt_setup_msix(bp);
 	else
@@ -8618,7 +8626,7 @@ static int bnxt_init_inta(struct bnxt *b
 
 static int bnxt_init_int_mode(struct bnxt *bp)
 {
-	int rc = 0;
+	int rc = -ENODEV;
 
 	if (bp->flags & BNXT_FLAG_MSIX_CAP)
 		rc = bnxt_init_msix(bp);
@@ -9339,7 +9347,8 @@ static int bnxt_hwrm_if_change(struct bn
 {
 	struct hwrm_func_drv_if_change_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_func_drv_if_change_input req = {0};
-	bool resc_reinit = false, fw_reset = false;
+	bool fw_reset = !bp->irq_tbl;
+	bool resc_reinit = false;
 	u32 flags = 0;
 	int rc;
 
@@ -9367,6 +9376,7 @@ static int bnxt_hwrm_if_change(struct bn
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) && !fw_reset) {
 		netdev_err(bp->dev, "RESET_DONE not set during FW reset.\n");
+		set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
 		return -ENODEV;
 	}
 	if (resc_reinit || fw_reset) {


