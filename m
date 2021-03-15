Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DDB33B7B9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhCOOBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhCON7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DABC964F5D;
        Mon, 15 Mar 2021 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816755;
        bh=lYVe70g8E3JiBLX0Rln+mX3b0K2j3UrL8r/mjPTCdPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNogp8mA+jNDRwArkEAH6pWX7NH4xEGlomIJFHPGRWW0O0rcmLwFoY2u3mJ67MsMK
         EHeD1TM5NLTaY8COFBk1MlS1ESChydqGR2SAhg7zWCg8ij8Qu+uwn/tF8kYiQ7fYFy
         xO+LhOyk+XNZVzOdYdRh1nCQrEIwHkq455w7Xf4w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/168] scsi: target: core: Prevent underflow for service actions
Date:   Mon, 15 Mar 2021 14:55:19 +0100
Message-Id: <20210315135553.241683807@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Aleksandr Miloserdov <a.miloserdov@yadro.com>

[ Upstream commit 14d24e2cc77411301e906a8cf41884739de192de ]

TCM buffer length doesn't necessarily equal 8 + ADDITIONAL LENGTH which
might be considered an underflow in case of Data-In size being greater than
8 + ADDITIONAL LENGTH. So truncate buffer length to prevent underflow.

Link: https://lore.kernel.org/r/20210209072202.41154-3-a.miloserdov@yadro.com
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pr.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5e931690e697..51e690ab4d29 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3731,6 +3731,7 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	spin_unlock(&dev->t10_pr.registration_lock);
 
 	put_unaligned_be32(add_len, &buf[4]);
+	target_set_cmd_data_length(cmd, 8 + add_len);
 
 	transport_kunmap_data_sg(cmd);
 
@@ -3749,7 +3750,7 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	struct t10_pr_registration *pr_reg;
 	unsigned char *buf;
 	u64 pr_res_key;
-	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
+	u32 add_len = 0;
 
 	if (cmd->data_length < 8) {
 		pr_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
@@ -3767,8 +3768,9 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	pr_reg = dev->dev_pr_res_holder;
 	if (pr_reg) {
 		/*
-		 * Set the hardcoded Additional Length
+		 * Set the Additional Length to 16 when a reservation is held
 		 */
+		add_len = 16;
 		put_unaligned_be32(add_len, &buf[4]);
 
 		if (cmd->data_length < 22)
@@ -3804,6 +3806,8 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 			  (pr_reg->pr_res_type & 0x0f);
 	}
 
+	target_set_cmd_data_length(cmd, 8 + add_len);
+
 err:
 	spin_unlock(&dev->dev_reservation_lock);
 	transport_kunmap_data_sg(cmd);
@@ -3822,7 +3826,7 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
-	u16 add_len = 8; /* Hardcoded to 8. */
+	u16 len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
 		pr_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
@@ -3834,7 +3838,7 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	put_unaligned_be16(add_len, &buf[0]);
+	put_unaligned_be16(len, &buf[0]);
 	buf[2] |= 0x10; /* CRH: Compatible Reservation Hanlding bit. */
 	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
 	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */
@@ -3863,6 +3867,8 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	buf[4] |= 0x02; /* PR_TYPE_WRITE_EXCLUSIVE */
 	buf[5] |= 0x01; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
 
+	target_set_cmd_data_length(cmd, len);
+
 	transport_kunmap_data_sg(cmd);
 
 	return 0;
@@ -4023,6 +4029,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	 * Set ADDITIONAL_LENGTH
 	 */
 	put_unaligned_be32(add_len, &buf[4]);
+	target_set_cmd_data_length(cmd, 8 + add_len);
 
 	transport_kunmap_data_sg(cmd);
 
-- 
2.30.1



