Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2480268F27
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 17:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgINNF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 09:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgINNEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:04:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E58A021D41;
        Mon, 14 Sep 2020 13:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088649;
        bh=+hTCQXSoThcQFiyF2kREjmsvdzzXC//BrwpSRW/S5Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWTP7vzVof5O6qmfZZyDPs6gWjgDTi4Lq3ryo7InHfmyKGwHOgKkjUdFOVj69atv2
         ZNHXl1Aqn0U4iQCVNXsNePop0GpCKgkKUFoyD9Wb10GY2oaaRZTN5Dr2R3xzFdy4Hv
         Y7FIpAmadmb0RSERda4LURy6hZYm4PjeWdH28drE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 09/29] scsi: lpfc: Extend the RDF FPIN Registration descriptor for additional events
Date:   Mon, 14 Sep 2020 09:03:38 -0400
Message-Id: <20200914130358.1804194-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

[ Upstream commit 441f6b5b097d74a8aa72ec0d8992ef820e2b3773 ]

Currently the driver registers for Link Integrity events only.

This patch adds registration for the following FPIN types:

 - Delivery Notifications
 - Congestion Notification
 - Peer Congestion Notification

Link: https://lore.kernel.org/r/20200828175332.130300-4-james.smart@broadcom.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +++
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7b6a210825677..519c7be404e75 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3512,6 +3512,9 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 				FC_TLV_DESC_LENGTH_FROM_SZ(prdf->reg_d1));
 	prdf->reg_d1.reg_desc.count = cpu_to_be32(ELS_RDF_REG_TAG_CNT);
 	prdf->reg_d1.desc_tags[0] = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
+	prdf->reg_d1.desc_tags[1] = cpu_to_be32(ELS_DTAG_DELIVERY);
+	prdf->reg_d1.desc_tags[2] = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
+	prdf->reg_d1.desc_tags[3] = cpu_to_be32(ELS_DTAG_CONGESTION);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue RDF:       did:x%x",
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 6dfff03765471..c7085769170d7 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4797,7 +4797,7 @@ struct send_frame_wqe {
 	uint32_t fc_hdr_wd5;           /* word 15 */
 };
 
-#define ELS_RDF_REG_TAG_CNT		1
+#define ELS_RDF_REG_TAG_CNT		4
 struct lpfc_els_rdf_reg_desc {
 	struct fc_df_desc_fpin_reg	reg_desc;	/* descriptor header */
 	__be32				desc_tags[ELS_RDF_REG_TAG_CNT];
-- 
2.25.1

