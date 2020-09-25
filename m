Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947F12787A3
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgIYMtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728823AbgIYMtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A466421741;
        Fri, 25 Sep 2020 12:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038151;
        bh=CMBMmW+y9Y3yGwpFrdn3y4YOGdINExVjR6fBnqU7h3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmmVEOvHLcuvqijDFr8RS9XJ4qFTlMnqYD9AITCORivDImK2gYMycEizf8i3dDXBq
         UVdyZF5Pnw5XXTXtM3Q+CSsm24I5sS1Une7p7IMG9BXvob6kMRwMOQAu0r/agtOb6z
         Gbyl8J4aNAwJFz1P/YEi6LaVqVP5PTCWLQBETSI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 04/56] bnxt_en: Avoid sending firmware messages when AER error is detected.
Date:   Fri, 25 Sep 2020 14:47:54 +0200
Message-Id: <20200925124728.495338813@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
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
@@ -4198,7 +4198,7 @@ static int bnxt_hwrm_do_send_msg(struct
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (BNXT_NO_FW_ACCESS(bp))
 		return -EBUSY;
 
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
@@ -5530,7 +5530,7 @@ static int hwrm_ring_free_send_msg(struc
 	struct hwrm_ring_free_output *resp = bp->hwrm_cmd_resp_addr;
 	u16 error_code;
 
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (BNXT_NO_FW_ACCESS(bp))
 		return 0;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_RING_FREE, cmpl_ring_id, -1);
@@ -7502,7 +7502,7 @@ static int bnxt_set_tpa(struct bnxt *bp,
 
 	if (set_tpa)
 		tpa_flags = bp->flags & BNXT_FLAG_TPA;
-	else if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	else if (BNXT_NO_FW_ACCESS(bp))
 		return 0;
 	for (i = 0; i < bp->nr_vnics; i++) {
 		rc = bnxt_hwrm_vnic_set_tpa(bp, i, tpa_flags);
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1673,6 +1673,10 @@ struct bnxt {
 #define BNXT_STATE_FW_FATAL_COND	6
 #define BNXT_STATE_DRV_REGISTERED	7
 
+#define BNXT_NO_FW_ACCESS(bp)					\
+	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
+	 pci_channel_offline((bp)->pdev))
+
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
 	u8			mac_addr[ETH_ALEN];


