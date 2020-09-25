Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF4F278818
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIYMwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728836AbgIYMv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B304B2075E;
        Fri, 25 Sep 2020 12:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038316;
        bh=nnCPX2M8Ud3Q3sWqnacbZ0IgDstKLV16QadBYR/b5so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TT9L/NlpH8mqM7fYdE1TSFbn642I58ljaFNvwZGY0QYuMmEidKdyV/SMWcOAxNgWD
         mn3dLWdWiyHJGZ1UuZdr0J3eyyat4NDHucrgTcvPhqzaF6+wWWpxICAUbUK2CNimWN
         RqYVLm4/E1yMTVWX/PrrbPw252sd2xIukyWCGG30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 07/43] bnxt_en: Avoid sending firmware messages when AER error is detected.
Date:   Fri, 25 Sep 2020 14:48:19 +0200
Message-Id: <20200925124724.645013837@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit b340dc680ed48dcc05b56e1ebe1b9535813c3ee0 ]

When the driver goes through PCIe AER reset in error state, all
firmware messages will timeout because the PCIe bus is no longer
accessible.  This can lead to AER reset taking many minutes to
complete as each firmware command takes time to timeout.

Define a new macro BNXT_NO_FW_ACCESS() to skip these firmware messages
when either firmware is in fatal error state or when
pci_channel_offline() is true.  It now takes a more reasonable 20 to
30 seconds to complete AER recovery.

Fixes: b4fff2079d10 ("bnxt_en: Do not send firmware messages if firmware is in error state.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4204,7 +4204,7 @@ static int bnxt_hwrm_do_send_msg(struct
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (BNXT_NO_FW_ACCESS(bp))
 		return -EBUSY;
 
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
@@ -5539,7 +5539,7 @@ static int hwrm_ring_free_send_msg(struc
 	struct hwrm_ring_free_output *resp = bp->hwrm_cmd_resp_addr;
 	u16 error_code;
 
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (BNXT_NO_FW_ACCESS(bp))
 		return 0;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_RING_FREE, cmpl_ring_id, -1);
@@ -7454,7 +7454,7 @@ static int bnxt_set_tpa(struct bnxt *bp,
 
 	if (set_tpa)
 		tpa_flags = bp->flags & BNXT_FLAG_TPA;
-	else if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	else if (BNXT_NO_FW_ACCESS(bp))
 		return 0;
 	for (i = 0; i < bp->nr_vnics; i++) {
 		rc = bnxt_hwrm_vnic_set_tpa(bp, i, tpa_flags);
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1628,6 +1628,10 @@ struct bnxt {
 #define BNXT_STATE_ABORT_ERR	5
 #define BNXT_STATE_FW_FATAL_COND	6
 
+#define BNXT_NO_FW_ACCESS(bp)					\
+	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
+	 pci_channel_offline((bp)->pdev))
+
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
 	u8			mac_addr[ETH_ALEN];


