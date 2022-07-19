Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F832579E1D
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbiGSM6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242165AbiGSM5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2925D0C9;
        Tue, 19 Jul 2022 05:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 662D2B81B21;
        Tue, 19 Jul 2022 12:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A09C341CA;
        Tue, 19 Jul 2022 12:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233385;
        bh=EfOYFyw83csPAeTB3cOrj1p3bu3mp5DP6XDuWqNdGtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6cfv2n8gZ729uJoy46PB7fHnBOPVyN6cEGp4NNNZxae6fnbDuLmvJAuJOBqsdzTL
         dVAOe7ui8zj4BBsnCMqo4QC/hLGu93RQ6UMe1LRfU9DbGUxnTgi97Fs2ur9jkawfl1
         xzE22toJYVPClpX1/A3gsAHEkWDI6F8SJ98eqUPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 105/231] bnxt_en: reclaim max resources if sriov enable fails
Date:   Tue, 19 Jul 2022 13:53:10 +0200
Message-Id: <20220719114723.475307137@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit c5b744d38c36a407a41e918602eec4d89730787b ]

If bnxt_sriov_enable() fails after some resources have been reserved
for the VFs, the current code is not unwinding properly and the
reserved resources become unavailable afterwards.  Fix it by
properly unwinding with a call to bnxt_hwrm_func_qcaps() to
reset all maximum resources.

Also, add the missing bnxt_ulp_sriov_cfg() call to let the RDMA
driver know to abort.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 7 ++++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d5149478a351..ee6686a111bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7641,7 +7641,7 @@ static void bnxt_hwrm_dbg_qcaps(struct bnxt *bp)
 
 static int bnxt_hwrm_queue_qportcfg(struct bnxt *bp);
 
-static int bnxt_hwrm_func_qcaps(struct bnxt *bp)
+int bnxt_hwrm_func_qcaps(struct bnxt *bp)
 {
 	int rc;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 98453a78cbd0..4c6ce2b2b3b7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2310,6 +2310,7 @@ int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset);
 int bnxt_hwrm_alloc_wol_fltr(struct bnxt *bp);
 int bnxt_hwrm_free_wol_fltr(struct bnxt *bp);
 int bnxt_hwrm_func_resc_qcaps(struct bnxt *bp, bool all);
+int bnxt_hwrm_func_qcaps(struct bnxt *bp);
 int bnxt_hwrm_fw_set_time(struct bnxt *);
 int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index ddf2f3963abe..a1a2c7a64fd5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -823,8 +823,10 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 		goto err_out2;
 
 	rc = pci_enable_sriov(bp->pdev, *num_vfs);
-	if (rc)
+	if (rc) {
+		bnxt_ulp_sriov_cfg(bp, 0);
 		goto err_out2;
+	}
 
 	return 0;
 
@@ -832,6 +834,9 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 	/* Free the resources reserved for various VF's */
 	bnxt_hwrm_func_vf_resource_free(bp, *num_vfs);
 
+	/* Restore the max resources */
+	bnxt_hwrm_func_qcaps(bp);
+
 err_out1:
 	bnxt_free_vf_resources(bp);
 
-- 
2.35.1



