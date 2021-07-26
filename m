Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4DF3D5DCD
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhGZPDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235851AbhGZPDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:03:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D361C60F38;
        Mon, 26 Jul 2021 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314254;
        bh=ipIp75H2TpDu39wOLDo4FJymCoV9Vg/9A3KlaPi/94g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+iv8DGEHgtrIB+6q4qQd2+fYwAaSuYzop7++/m6xod2H52jdpv4wn9pxZ/nf4Y+S
         lpCr2Fnv+WQfVCE7I8maKJvt2J1kS4DrK+0SDhpxJxFS2dok4e0vGO4HAo2VwpIhkc
         CvSg/4/gNRLeSZCScNErY2k1594is4H61YO5dYNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/60] scsi: target: Fix protect handling in WRITE SAME(32)
Date:   Mon, 26 Jul 2021 17:38:54 +0200
Message-Id: <20210726153826.128220396@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 6d8e7e7c932162bccd06872362751b0e1d76f5af ]

WRITE SAME(32) command handling reads WRPROTECT at the wrong offset in 1st
byte instead of 10th byte.

Link: https://lore.kernel.org/r/20210702091655.22818-1-d.bogdanov@yadro.com
Fixes: afd73f1b60fc ("target: Perform PROTECT sanity checks for WRITE_SAME")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_sbc.c | 35 ++++++++++++++++----------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index b3b1461ec60d..6a5a089fd13e 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -37,7 +37,7 @@
 #include "target_core_alua.h"
 
 static sense_reason_t
-sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char *, u32, bool);
+sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char, u32, bool);
 static sense_reason_t sbc_execute_unmap(struct se_cmd *cmd);
 
 static sense_reason_t
@@ -319,14 +319,14 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 }
 
 static sense_reason_t
-sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
 	unsigned int sectors = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
-	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
+	if ((flags & 0x04) || (flags & 0x02)) {
 		pr_err("WRITE_SAME PBDATA and LBDATA"
 			" bits not supported for Block Discard"
 			" Emulation\n");
@@ -348,7 +348,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	}
 
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
-	if (flags[0] & 0x10) {
+	if (flags & 0x10) {
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -356,7 +356,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
 	 */
-	if (flags[0] & 0x08) {
+	if (flags & 0x08) {
 		if (!ops->execute_unmap)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
@@ -371,7 +371,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	if (!ops->execute_write_same)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
-	ret = sbc_check_prot(dev, cmd, &cmd->t_task_cdb[0], sectors, true);
+	ret = sbc_check_prot(dev, cmd, flags >> 5, sectors, true);
 	if (ret)
 		return ret;
 
@@ -729,10 +729,9 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 }
 
 static sense_reason_t
-sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
+sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	       u32 sectors, bool is_write)
 {
-	u8 protect = cdb[1] >> 5;
 	int sp_ops = cmd->se_sess->sup_prot_ops;
 	int pi_prot_type = dev->dev_attrib.pi_prot_type;
 	bool fabric_prot = false;
@@ -780,7 +779,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 		/* Fallthrough */
 	default:
 		pr_err("Unable to determine pi_prot_type for CDB: 0x%02x "
-		       "PROTECT: 0x%02x\n", cdb[0], protect);
+		       "PROTECT: 0x%02x\n", cmd->t_task_cdb[0], protect);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -855,7 +854,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -869,7 +868,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -883,7 +882,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -904,7 +903,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -918,7 +917,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -932,7 +931,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -991,7 +990,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
-			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
+			ret = sbc_setup_write_same(cmd, cdb[10], ops);
 			if (ret)
 				return ret;
 			break;
@@ -1084,7 +1083,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb[1], ops);
 		if (ret)
 			return ret;
 		break;
@@ -1102,7 +1101,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 * Follow sbcr26 with WRITE_SAME (10) and check for the existence
 		 * of byte 1 bit 3 UNMAP instead of original reserved field
 		 */
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb[1], ops);
 		if (ret)
 			return ret;
 		break;
-- 
2.30.2



