Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8297D53182B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbiEWRaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242419AbiEWR1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4285A7CB63;
        Mon, 23 May 2022 10:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1883B811FF;
        Mon, 23 May 2022 17:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C62C385A9;
        Mon, 23 May 2022 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326590;
        bh=Pq5/8Kq/7EMNq8IsfVTN43pOObgrPxSMbuD5x98pawk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbxKrC3FJa38f8KxI7Z286psM3GuHCRGG26mUtYCVFjZsDms+oLsXH+bU1Bs0NCeS
         ijYyyVnGCT7Rp8yYhwG2XnHVRcaIJqIqLS+3daNDds4cP+jeeUea3dHrHobC0oopfT
         viws+sKuOqiWfTkrBlndmY5zWU9AHDOhkwUjBmuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/132] scsi: ufs: core: Fix referencing invalid rsp field
Date:   Mon, 23 May 2022 19:05:15 +0200
Message-Id: <20220523165841.056634318@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit d5d92b64408443e113b9742f8f1c35278910dd4d ]

Fix referencing sense data when it is invalid. When the length of the data
segment is 0, there is no valid information in the rsp field, so
ufshpb_rsp_upiu() is returned without additional operation.

Link: https://lore.kernel.org/r/252651381.41652940482659.JavaMail.epsvc@epcpadp4
Fixes: 4b5f49079c52 ("scsi: ufs: ufshpb: L2P map management for HPB read")
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshpb.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index f7eaf64293a4..14300896c57f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1257,6 +1257,13 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	struct utp_hpb_rsp *rsp_field = &lrbp->ucd_rsp_ptr->hr;
 	int data_seg_len;
 
+	data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
+		& MASK_RSP_UPIU_DATA_SEG_LEN;
+
+	/* If data segment length is zero, rsp_field is not valid */
+	if (!data_seg_len)
+		return;
+
 	if (unlikely(lrbp->lun != rsp_field->lun)) {
 		struct scsi_device *sdev;
 		bool found = false;
@@ -1291,18 +1298,6 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		return;
 	}
 
-	data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
-		& MASK_RSP_UPIU_DATA_SEG_LEN;
-
-	/* To flush remained rsp_list, we queue the map_work task */
-	if (!data_seg_len) {
-		if (!ufshpb_is_general_lun(hpb->lun))
-			return;
-
-		ufshpb_kick_map_work(hpb);
-		return;
-	}
-
 	BUILD_BUG_ON(sizeof(struct utp_hpb_rsp) != UTP_HPB_RSP_SIZE);
 
 	if (!ufshpb_is_hpb_rsp_valid(hba, lrbp, rsp_field))
-- 
2.35.1



