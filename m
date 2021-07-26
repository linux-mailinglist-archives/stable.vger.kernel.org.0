Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F57C3D5F1F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhGZPQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236687AbhGZPMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:12:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39B2560F90;
        Mon, 26 Jul 2021 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314753;
        bh=CQmi24Cuju+ajpeWGtZiUrfTndbCa2q0sd6aVrkM8RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmCixpqXbCPdsYAMp3bMmZ8iNu0UR/NQcL4Bv9cqknqo5BfecSAuk9pCFuAnKYmkZ
         jYO/XAMV2B+K1/Z4+XoVFxbQ43BvLScwQvKwhBwKMwdzxX69QJb33nsc6kzcTo/lOR
         SLg0HnXZZzKrMj40kft4+BB/P75kW4+W1Cwg/6MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/120] scsi: target: Fix protect handling in WRITE SAME(32)
Date:   Mon, 26 Jul 2021 17:38:52 +0200
Message-Id: <20210726153834.955957798@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
index ebac2b49b9c6..af9b038da3ba 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -38,7 +38,7 @@
 #include "target_core_alua.h"
 
 static sense_reason_t
-sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char *, u32, bool);
+sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char, u32, bool);
 static sense_reason_t sbc_execute_unmap(struct se_cmd *cmd);
 
 static sense_reason_t
@@ -292,14 +292,14 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
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
@@ -321,7 +321,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	}
 
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
-	if (flags[0] & 0x10) {
+	if (flags & 0x10) {
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -329,7 +329,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
 	 */
-	if (flags[0] & 0x08) {
+	if (flags & 0x08) {
 		if (!ops->execute_unmap)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
@@ -344,7 +344,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	if (!ops->execute_write_same)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
-	ret = sbc_check_prot(dev, cmd, &cmd->t_task_cdb[0], sectors, true);
+	ret = sbc_check_prot(dev, cmd, flags >> 5, sectors, true);
 	if (ret)
 		return ret;
 
@@ -702,10 +702,9 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
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
@@ -753,7 +752,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 		/* Fallthrough */
 	default:
 		pr_err("Unable to determine pi_prot_type for CDB: 0x%02x "
-		       "PROTECT: 0x%02x\n", cdb[0], protect);
+		       "PROTECT: 0x%02x\n", cmd->t_task_cdb[0], protect);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -828,7 +827,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -842,7 +841,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -856,7 +855,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -877,7 +876,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -891,7 +890,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -906,7 +905,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -965,7 +964,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
-			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
+			ret = sbc_setup_write_same(cmd, cdb[10], ops);
 			if (ret)
 				return ret;
 			break;
@@ -1064,7 +1063,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb[1], ops);
 		if (ret)
 			return ret;
 		break;
@@ -1082,7 +1081,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
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



