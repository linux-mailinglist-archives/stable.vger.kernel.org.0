Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9768C1DCEEC
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgEUOHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:07:12 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:14830 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgEUOHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:07:12 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04LE6i8l018384;
        Thu, 21 May 2020 07:06:48 -0700
Date:   Thu, 21 May 2020 19:36:43 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     hch@lst.de, sagi@grimberg.me, stable@vger.kernel.org
Cc:     bharat@chelsio.com, nirranjan@chelsio.com
Subject: nvme blk_update_request IO error is seen on stable kernel 5.4.41.
Message-ID: <20200521140642.GA4724@chelsio.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi all,

Issue which is reported in https://lore.kernel.org/linux-nvme/CH2PR12MB40050ACF
2C0DC7439355ED3FDD270@CH2PR12MB4005.namprd12.prod.outlook.com/T/#r8cfc80b26f0cd
1cde41879a68fd6a71186e9594c is also seen on stable kernel 5.4.41. 
In upstream issue is fixed with commit b716e6889c95f64b.
For stable 5.4 kernel it doesn’t apply clean and needs pulling in the following
commits. 

commit 2cb6963a16e9e114486decf591af7cb2d69cb154
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Oct 23 10:35:41 2019 -0600

commit 6f86f2c9d94d55c4d3a6f1ffbc2e1115b5cb38a8
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Oct 23 10:35:42 2019 -0600

commit 59ef0eaa7741c3543f98220cc132c61bf0230bce
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Oct 23 10:35:43 2019 -0600

commit e9061c397839eea34207668bfedce0a6c18c5015
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Oct 23 10:35:44 2019 -0600

commit b716e6889c95f64ba32af492461f6cc9341f3f05
Author: Sagi Grimberg <sagi@grimberg.me>
Date:   Sun Jan 26 23:23:28 2020 -0800

I tried a patch by including only necessary parts of the commits e9061c397839, 
59ef0eaa7741 and b716e6889c95. PFA.

With the attached patch, issue is not seen.

Please let me know on how to fix it in stable, can all above 5 changes be 
cleanly pushed  or if  attached shorter version can be pushed?

Thanks,
Dakshaja.


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="simple_portable_v54.patch"

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 57a4062cb..47bee01d3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -931,16 +931,35 @@ void nvmet_req_uninit(struct nvmet_req *req)
 }
 EXPORT_SYMBOL_GPL(nvmet_req_uninit);
 
-void nvmet_req_execute(struct nvmet_req *req)
+bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len)
 {
-	if (unlikely(req->data_len != req->transfer_len)) {
+	if (unlikely(data_len != req->transfer_len)) {
 		req->error_loc = offsetof(struct nvme_common_command, dptr);
 		nvmet_req_complete(req, NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR);
-	} else
-		req->execute(req);
+		return false;
+	}
+	return true;
+}
+EXPORT_SYMBOL_GPL(nvmet_check_data_len);
+
+void nvmet_req_execute(struct nvmet_req *req)
+{
+	req->execute(req);
 }
 EXPORT_SYMBOL_GPL(nvmet_req_execute);
 
+bool nvmet_check_data_len_lte(struct nvmet_req *req, size_t data_len)
+{
+       if (unlikely(data_len > req->transfer_len)) {
+               req->error_loc = offsetof(struct nvme_common_command, dptr);
+               nvmet_req_complete(req, NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR);
+               return false;
+       }
+
+       return true;
+}
+
+
 int nvmet_req_alloc_sgl(struct nvmet_req *req)
 {
 	struct pci_dev *p2p_dev = NULL;
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 32008d851..498efb062 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -150,6 +150,10 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 	sector_t sector;
 	int op, op_flags = 0, i;
 
+	if (!nvmet_check_data_len(req, nvmet_rw_len(req)))
+        	return;
+
+
 	if (!req->sg_cnt) {
 		nvmet_req_complete(req, 0);
 		return;
@@ -207,6 +211,8 @@ static void nvmet_bdev_execute_flush(struct nvmet_req *req)
 {
 	struct bio *bio = &req->b.inline_bio;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
 	bio_init(bio, req->inline_bvec, ARRAY_SIZE(req->inline_bvec));
 	bio_set_dev(bio, req->ns->bdev);
 	bio->bi_private = req;
@@ -274,6 +280,9 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 
 static void nvmet_bdev_execute_dsm(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
+                return;
+
 	switch (le32_to_cpu(req->cmd->dsm.attributes)) {
 	case NVME_DSMGMT_AD:
 		nvmet_bdev_execute_discard(req);
@@ -295,6 +304,8 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	sector_t nr_sector;
 	int ret;
 
+	if (!nvmet_check_data_len(req, 0))
+        	return;
 	sector = le64_to_cpu(write_zeroes->slba) <<
 		(req->ns->blksize_shift - 9);
 	nr_sector = (((sector_t)le16_to_cpu(write_zeroes->length) + 1) <<
@@ -319,20 +330,15 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_read:
 	case nvme_cmd_write:
 		req->execute = nvmet_bdev_execute_rw;
-		req->data_len = nvmet_rw_len(req);
 		return 0;
 	case nvme_cmd_flush:
 		req->execute = nvmet_bdev_execute_flush;
-		req->data_len = 0;
 		return 0;
 	case nvme_cmd_dsm:
 		req->execute = nvmet_bdev_execute_dsm;
-		req->data_len = (le32_to_cpu(cmd->dsm.nr) + 1) *
-			sizeof(struct nvme_dsm_range);
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_bdev_execute_write_zeroes;
-		req->data_len = 0;
 		return 0;
 	default:
 		pr_err("unhandled cmd %d on qid %d\n", cmd->common.opcode,
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 05453f5d1..34fc0c04d 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -232,6 +232,9 @@ static void nvmet_file_execute_rw(struct nvmet_req *req)
 {
 	ssize_t nr_bvec = req->sg_cnt;
 
+	if (!nvmet_check_data_len(req, nvmet_rw_len(req)))
+		return;
+
 	if (!req->sg_cnt || !nr_bvec) {
 		nvmet_req_complete(req, 0);
 		return;
@@ -273,6 +276,8 @@ static void nvmet_file_flush_work(struct work_struct *w)
 
 static void nvmet_file_execute_flush(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, 0))
+		return;
 	INIT_WORK(&req->f.work, nvmet_file_flush_work);
 	schedule_work(&req->f.work);
 }
@@ -331,6 +336,9 @@ static void nvmet_file_dsm_work(struct work_struct *w)
 
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
+                return;
+
 	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
 	schedule_work(&req->f.work);
 }
@@ -359,6 +367,8 @@ static void nvmet_file_write_zeroes_work(struct work_struct *w)
 
 static void nvmet_file_execute_write_zeroes(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, 0))
+	        return;
 	INIT_WORK(&req->f.work, nvmet_file_write_zeroes_work);
 	schedule_work(&req->f.work);
 }
@@ -371,20 +381,15 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_read:
 	case nvme_cmd_write:
 		req->execute = nvmet_file_execute_rw;
-		req->data_len = nvmet_rw_len(req);
 		return 0;
 	case nvme_cmd_flush:
 		req->execute = nvmet_file_execute_flush;
-		req->data_len = 0;
 		return 0;
 	case nvme_cmd_dsm:
 		req->execute = nvmet_file_execute_dsm;
-		req->data_len = (le32_to_cpu(cmd->dsm.nr) + 1) *
-			sizeof(struct nvme_dsm_range);
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_file_execute_write_zeroes;
-		req->data_len = 0;
 		return 0;
 	default:
 		pr_err("unhandled cmd for file ns %d on qid %d\n",
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index c51f8dd01..a8a7744d8 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -375,7 +375,9 @@ u16 nvmet_parse_fabrics_cmd(struct nvmet_req *req);
 bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 		struct nvmet_sq *sq, const struct nvmet_fabrics_ops *ops);
 void nvmet_req_uninit(struct nvmet_req *req);
+bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len);
 void nvmet_req_execute(struct nvmet_req *req);
+bool nvmet_check_data_len_lte(struct nvmet_req *req, size_t data_len);
 void nvmet_req_complete(struct nvmet_req *req, u16 status);
 int nvmet_req_alloc_sgl(struct nvmet_req *req);
 void nvmet_req_free_sgl(struct nvmet_req *req);
@@ -495,6 +497,12 @@ static inline u32 nvmet_rw_len(struct nvmet_req *req)
 			req->ns->blksize_shift;
 }
 
+static inline u32 nvmet_dsm_len(struct nvmet_req *req)
+{
+        return (le32_to_cpu(req->cmd->dsm.nr) + 1) *
+                sizeof(struct nvme_dsm_range);
+}
+
 u16 errno_to_nvme_status(struct nvmet_req *req, int errno);
 
 /* Convert a 32-bit number to a 16-bit 0's based number */

--jRHKVT23PllUwdXP--
