Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAF341217C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhITSGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357338AbhITSD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F342613CD;
        Mon, 20 Sep 2021 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158221;
        bh=YPMwdLDqofnsI0Ac1tzLqO8pj+D31tAbuuo8oHyR4Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZhRSmB/a1DgUf9JfVjeKiW5groLpkzRXESbNuwfPg7hmXYl13oopVJaMg9CJNixT
         j4x+/eKtZDeqZ+rSHPqKL7bL3D2KHok4x5fwlw60lDQq6mbM95GnLzTSVPDdgthGPU
         XgTfQxb6/BPIejAjur+ic8V76kZ2ZBi9sFexoNG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        David Disseldorp <ddiss@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/260] scsi: target: avoid per-loop XCOPY buffer allocations
Date:   Mon, 20 Sep 2021 18:41:15 +0200
Message-Id: <20210920163933.044049117@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 0ad08996da05b6b735d4963dceab7d2a4043607c ]

The main target_xcopy_do_work() loop unnecessarily allocates an I/O buffer
with each synchronous READ / WRITE pair. This commit significantly reduces
allocations by reusing the XCOPY I/O buffer when possible.

Link: https://lore.kernel.org/r/20200327141954.955-4-ddiss@suse.de
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_xcopy.c | 96 ++++++++++--------------------
 drivers/target/target_core_xcopy.h |  1 +
 2 files changed, 31 insertions(+), 66 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 596ad3edec9c..48fabece7644 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -533,7 +533,6 @@ void target_xcopy_release_pt(void)
  * @cdb:	 SCSI CDB to be copied into @xpt_cmd.
  * @remote_port: If false, use the LUN through which the XCOPY command has
  *		 been received. If true, use @se_dev->xcopy_lun.
- * @alloc_mem:	 Whether or not to allocate an SGL list.
  *
  * Set up a SCSI command (READ or WRITE) that will be used to execute an
  * XCOPY command.
@@ -543,12 +542,9 @@ static int target_xcopy_setup_pt_cmd(
 	struct xcopy_op *xop,
 	struct se_device *se_dev,
 	unsigned char *cdb,
-	bool remote_port,
-	bool alloc_mem)
+	bool remote_port)
 {
 	struct se_cmd *cmd = &xpt_cmd->se_cmd;
-	sense_reason_t sense_rc;
-	int ret = 0, rc;
 
 	/*
 	 * Setup LUN+port to honor reservations based upon xop->op_origin for
@@ -564,46 +560,17 @@ static int target_xcopy_setup_pt_cmd(
 	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
 	cmd->tag = 0;
-	sense_rc = target_setup_cmd_from_cdb(cmd, cdb);
-	if (sense_rc) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (target_setup_cmd_from_cdb(cmd, cdb))
+		return -EINVAL;
 
-	if (alloc_mem) {
-		rc = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
-				      cmd->data_length, false, false);
-		if (rc < 0) {
-			ret = rc;
-			goto out;
-		}
-		/*
-		 * Set this bit so that transport_free_pages() allows the
-		 * caller to release SGLs + physical memory allocated by
-		 * transport_generic_get_mem()..
-		 */
-		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
-	} else {
-		/*
-		 * Here the previously allocated SGLs for the internal READ
-		 * are mapped zero-copy to the internal WRITE.
-		 */
-		sense_rc = transport_generic_map_mem_to_cmd(cmd,
-					xop->xop_data_sg, xop->xop_data_nents,
-					NULL, 0);
-		if (sense_rc) {
-			ret = -EINVAL;
-			goto out;
-		}
+	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
+					xop->xop_data_nents, NULL, 0))
+		return -EINVAL;
 
-		pr_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents:"
-			 " %u\n", cmd->t_data_sg, cmd->t_data_nents);
-	}
+	pr_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents:"
+		 " %u\n", cmd->t_data_sg, cmd->t_data_nents);
 
 	return 0;
-
-out:
-	return ret;
 }
 
 static int target_xcopy_issue_pt_cmd(struct xcopy_pt_cmd *xpt_cmd)
@@ -660,15 +627,13 @@ static int target_xcopy_read_source(
 	xop->src_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
-				remote_port, true);
+				remote_port);
 	if (rc < 0) {
 		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
 	}
 
-	xop->xop_data_sg = se_cmd->t_data_sg;
-	xop->xop_data_nents = se_cmd->t_data_nents;
 	pr_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
 		" memory\n", xop->xop_data_sg, xop->xop_data_nents);
 
@@ -678,12 +643,6 @@ static int target_xcopy_read_source(
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
 	}
-	/*
-	 * Clear off the allocated t_data_sg, that has been saved for
-	 * zero-copy WRITE submission reuse in struct xcopy_op..
-	 */
-	se_cmd->t_data_sg = NULL;
-	se_cmd->t_data_nents = 0;
 
 	return 0;
 }
@@ -722,19 +681,9 @@ static int target_xcopy_write_destination(
 	xop->dst_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, dst_dev, &cdb[0],
-				remote_port, false);
+				remote_port);
 	if (rc < 0) {
-		struct se_cmd *src_cmd = &xop->src_pt_cmd->se_cmd;
 		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		/*
-		 * If the failure happened before the t_mem_list hand-off in
-		 * target_xcopy_setup_pt_cmd(), Reset memory + clear flag so that
-		 * core releases this memory on error during X-COPY WRITE I/O.
-		 */
-		src_cmd->se_cmd_flags &= ~SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
-		src_cmd->t_data_sg = xop->xop_data_sg;
-		src_cmd->t_data_nents = xop->xop_data_nents;
-
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
 	}
@@ -742,7 +691,6 @@ static int target_xcopy_write_destination(
 	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
 	if (rc < 0) {
 		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		se_cmd->se_cmd_flags &= ~SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
 	}
@@ -758,7 +706,7 @@ static void target_xcopy_do_work(struct work_struct *work)
 	sector_t src_lba, dst_lba, end_lba;
 	unsigned int max_sectors;
 	int rc = 0;
-	unsigned short nolb, cur_nolb, max_nolb, copied_nolb = 0;
+	unsigned short nolb, max_nolb, copied_nolb = 0;
 
 	if (target_parse_xcopy_cmd(xop) != TCM_NO_SENSE)
 		goto err_free;
@@ -788,7 +736,23 @@ static void target_xcopy_do_work(struct work_struct *work)
 			(unsigned long long)src_lba, (unsigned long long)dst_lba);
 
 	while (src_lba < end_lba) {
-		cur_nolb = min(nolb, max_nolb);
+		unsigned short cur_nolb = min(nolb, max_nolb);
+		u32 cur_bytes = cur_nolb * src_dev->dev_attrib.block_size;
+
+		if (cur_bytes != xop->xop_data_bytes) {
+			/*
+			 * (Re)allocate a buffer large enough to hold the XCOPY
+			 * I/O size, which can be reused each read / write loop.
+			 */
+			target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
+			rc = target_alloc_sgl(&xop->xop_data_sg,
+					      &xop->xop_data_nents,
+					      cur_bytes,
+					      false, false);
+			if (rc < 0)
+				goto out;
+			xop->xop_data_bytes = cur_bytes;
+		}
 
 		pr_debug("target_xcopy_do_work: Calling read src_dev: %p src_lba: %llu,"
 			" cur_nolb: %hu\n", src_dev, (unsigned long long)src_lba, cur_nolb);
@@ -819,12 +783,11 @@ static void target_xcopy_do_work(struct work_struct *work)
 		nolb -= cur_nolb;
 
 		transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
-		xop->dst_pt_cmd->se_cmd.se_cmd_flags &= ~SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
-
 		transport_generic_free_cmd(&xop->dst_pt_cmd->se_cmd, 0);
 	}
 
 	xcopy_pt_undepend_remotedev(xop);
+	target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
 	kfree(xop);
 
 	pr_debug("target_xcopy_do_work: Final src_lba: %llu, dst_lba: %llu\n",
@@ -838,6 +801,7 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 out:
 	xcopy_pt_undepend_remotedev(xop);
+	target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
 
 err_free:
 	kfree(xop);
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index 974bc1e19ff2..a1805a14eea0 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -41,6 +41,7 @@ struct xcopy_op {
 	struct xcopy_pt_cmd *src_pt_cmd;
 	struct xcopy_pt_cmd *dst_pt_cmd;
 
+	u32 xop_data_bytes;
 	u32 xop_data_nents;
 	struct scatterlist *xop_data_sg;
 	struct work_struct xop_work;
-- 
2.30.2



