Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D493D608A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbhGZPW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237044AbhGZPWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90A8860F38;
        Mon, 26 Jul 2021 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315402;
        bh=PNhRUF71Ttt7XgTFUlKX9Ti/saQcyf57gQZLQQOePw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF4NvTwFkiFIUQg9vhyDB4ENEiJV2qsaUbhJRSNah7GSe53JS5HVEhFHLZOW5Pr+Q
         dYU7iqCgCBrYrkn9rI05UXpEVzxK9ervnTM9zeGzi6WK3Cgl4ao4DwgdoJ9/tGi5L3
         W+dadc+A3fLVzqeLy1/mDveZUJ30+q+K0PftcOLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/167] bnxt_en: Check abort error state in bnxt_half_open_nic()
Date:   Mon, 26 Jul 2021 17:38:36 +0200
Message-Id: <20210726153842.195135993@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 11a39259ff79b74bc99f8b7c44075a2d6d5e7ab1 ]

bnxt_half_open_nic() is called during during ethtool self test and is
protected by rtnl_lock.  Firmware reset can be happening at the same
time.  Only critical portions of the entire firmware reset sequence
are protected by the rtnl_lock.  It is possible that bnxt_half_open_nic()
can be called when the firmware reset sequence is aborting.  In that
case, bnxt_half_open_nic() needs to check if the ABORT_ERR flag is set
and abort if it is.  The ethtool self test will fail but the NIC will be
brought to a consistent IF_DOWN state.

Without this patch, if bnxt_half_open_nic() were to continue in this
error state, it may crash like this:

  bnxt_en 0000:82:00.1 enp130s0f1np1: FW reset in progress during close, FW reset will be aborted
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  ...
  Process ethtool (pid: 333327, stack limit = 0x0000000046476577)
  Call trace:
  bnxt_alloc_mem+0x444/0xef0 [bnxt_en]
  bnxt_half_open_nic+0x24/0xb8 [bnxt_en]
  bnxt_self_test+0x2dc/0x390 [bnxt_en]
  ethtool_self_test+0xe0/0x1f8
  dev_ethtool+0x1744/0x22d0
  dev_ioctl+0x190/0x3e0
  sock_ioctl+0x238/0x480
  do_vfs_ioctl+0xc4/0x758
  ksys_ioctl+0x84/0xb8
  __arm64_sys_ioctl+0x28/0x38
  el0_svc_handler+0xb0/0x180
  el0_svc+0x8/0xc

Fixes: a1301f08c5ac ("bnxt_en: Check abort error state in bnxt_open_nic().")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e3a8c1c6d237..8f169508a90a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9841,6 +9841,12 @@ int bnxt_half_open_nic(struct bnxt *bp)
 {
 	int rc = 0;
 
+	if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state)) {
+		netdev_err(bp->dev, "A previous firmware reset has not completed, aborting half open\n");
+		rc = -ENODEV;
+		goto half_open_err;
+	}
+
 	rc = bnxt_alloc_mem(bp, false);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
-- 
2.30.2



