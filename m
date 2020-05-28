Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530C61E5966
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 09:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgE1HpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 03:45:13 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:13720 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE1HpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 03:45:12 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04S7iV2b014033;
        Thu, 28 May 2020 00:44:32 -0700
Date:   Thu, 28 May 2020 13:14:31 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     hch@lst.de, sagi@grimberg.me, stable@vger.kernel.org,
        nirranjan@chelsio.com, bharat@chelsio.com
Subject: Re: nvme blk_update_request IO error is seen on stable kernel 5.4.41.
Message-ID: <20200528074426.GA20353@chelsio.com>
References: <20200521140642.GA4724@chelsio.com>
 <20200526102542.GA2772976@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526102542.GA2772976@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tuesday, May 05/26/20, 2020 at 12:25:42 +0200, Greg KH wrote:
> On Thu, May 21, 2020 at 07:36:43PM +0530, Dakshaja Uppalapati wrote:
> > Hi all,
> > 
> > Issue which is reported in https://lore.kernel.org/linux-nvme/CH2PR12MB40050ACF
> > 2C0DC7439355ED3FDD270@CH2PR12MB4005.namprd12.prod.outlook.com/T/#r8cfc80b26f0cd
> > 1cde41879a68fd6a71186e9594c is also seen on stable kernel 5.4.41. 
> 
> What issue is that?  Your url is wrapped and can not work here :(

Sorry for that, when I tried to format the disk discovered from target machine
the below error is seen in dmesg.

dmesg:
	[ 1844.868480] blk_update_request: I/O error, dev nvme0c0n1, sector 0 
	op 0x3:(DISCARD) flags 0x4000800 phys_seg 1 prio class 0

The above issue is seen from kernel-5.5-rc1 onwards.

> 
> > In upstream issue is fixed with commit b716e6889c95f64b.
> 
> Is this a regression or support for something new that has never worked
> before?
> 

This is a regression, bisects points to the commit 530436c4 and fixed with
commit b716e688 in upstream.

Now same issue is seen with stable kernel-5.4.41, 530436c4 is part of it.

> > For stable 5.4 kernel it doesn’t apply clean and needs pulling in the following
> > commits. 
> > 
> > commit 2cb6963a16e9e114486decf591af7cb2d69cb154
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Wed Oct 23 10:35:41 2019 -0600
> > 
> > commit 6f86f2c9d94d55c4d3a6f1ffbc2e1115b5cb38a8
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Wed Oct 23 10:35:42 2019 -0600
> > 
> > commit 59ef0eaa7741c3543f98220cc132c61bf0230bce
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Wed Oct 23 10:35:43 2019 -0600
> > 
> > commit e9061c397839eea34207668bfedce0a6c18c5015
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Wed Oct 23 10:35:44 2019 -0600
> > 
> > commit b716e6889c95f64ba32af492461f6cc9341f3f05
> > Author: Sagi Grimberg <sagi@grimberg.me>
> > Date:   Sun Jan 26 23:23:28 2020 -0800
> > 
> > I tried a patch by including only necessary parts of the commits e9061c397839, 
> > 59ef0eaa7741 and b716e6889c95. PFA.
> > 
> > With the attached patch, issue is not seen.
> > 
> > Please let me know on how to fix it in stable, can all above 5 changes be 
> > cleanly pushed  or if  attached shorter version can be pushed?
> 
> Do all of the above patches apply cleanly?  Do they need to be
> backported?  Have you tested that?  Do you have such a series of patches
> so we can compare them?
> 

Yes I have tested, all the patches applied cleanly and attached all the patches
for your reference. They all can be pulled into 5.4 stable without any issues.

530436c4 -- culprit commit
2cb6963a -- dependent commit
6f86f2c9 -- dependent commit
59ef0eaa -- dependent commit
e9061c39 -- dependent commit
be3f3114 -- dependent commit
b716e688 -- fix commit

> The patch below is not in any format that I can take it in.  ALso, 95%
> of the times we take a patch that is different from what is upstream
> will have bugs and problems over time because of that.  So I always want
> to take the original upstream patches instead if at all possible.
> 
> So I need a lot more information here in order to try to determine this,
> sorry.
> 

Thanks
Dakshaja

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2cb6963a.patch"

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 831a062d27cb..3665b45d6515 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -282,6 +282,33 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	nvmet_req_complete(req, status);
 }
 
+static void nvmet_execute_get_log_page(struct nvmet_req *req)
+{
+	switch (req->cmd->get_log_page.lid) {
+	case NVME_LOG_ERROR:
+		return nvmet_execute_get_log_page_error(req);
+	case NVME_LOG_SMART:
+		return nvmet_execute_get_log_page_smart(req);
+	case NVME_LOG_FW_SLOT:
+		/*
+		 * We only support a single firmware slot which always is
+		 * active, so we can zero out the whole firmware slot log and
+		 * still claim to fully implement this mandatory log page.
+		 */
+		return nvmet_execute_get_log_page_noop(req);
+	case NVME_LOG_CHANGED_NS:
+		return nvmet_execute_get_log_changed_ns(req);
+	case NVME_LOG_CMD_EFFECTS:
+		return nvmet_execute_get_log_cmd_effects_ns(req);
+	case NVME_LOG_ANA:
+		return nvmet_execute_get_log_page_ana(req);
+	}
+	pr_err("unhandled lid %d on qid %d\n",
+	       req->cmd->get_log_page.lid, req->sq->qid);
+	req->error_loc = offsetof(struct nvme_get_log_page_command, lid);
+	nvmet_req_complete(req, NVME_SC_INVALID_FIELD | NVME_SC_DNR);
+}
+
 static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
@@ -565,6 +592,25 @@ static void nvmet_execute_identify_desclist(struct nvmet_req *req)
 	nvmet_req_complete(req, status);
 }
 
+static void nvmet_execute_identify(struct nvmet_req *req)
+{
+	switch (req->cmd->identify.cns) {
+	case NVME_ID_CNS_NS:
+		return nvmet_execute_identify_ns(req);
+	case NVME_ID_CNS_CTRL:
+		return nvmet_execute_identify_ctrl(req);
+	case NVME_ID_CNS_NS_ACTIVE_LIST:
+		return nvmet_execute_identify_nslist(req);
+	case NVME_ID_CNS_NS_DESC_LIST:
+		return nvmet_execute_identify_desclist(req);
+	}
+
+	pr_err("unhandled identify cns %d on qid %d\n",
+	       req->cmd->identify.cns, req->sq->qid);
+	req->error_loc = offsetof(struct nvme_identify, cns);
+	nvmet_req_complete(req, NVME_SC_INVALID_FIELD | NVME_SC_DNR);
+}
+
 /*
  * A "minimum viable" abort implementation: the command is mandatory in the
  * spec, but we are not required to do any useful work.  We couldn't really
@@ -819,52 +865,13 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
 
 	switch (cmd->common.opcode) {
 	case nvme_admin_get_log_page:
+		req->execute = nvmet_execute_get_log_page;
 		req->data_len = nvmet_get_log_page_len(cmd);
-
-		switch (cmd->get_log_page.lid) {
-		case NVME_LOG_ERROR:
-			req->execute = nvmet_execute_get_log_page_error;
-			return 0;
-		case NVME_LOG_SMART:
-			req->execute = nvmet_execute_get_log_page_smart;
-			return 0;
-		case NVME_LOG_FW_SLOT:
-			/*
-			 * We only support a single firmware slot which always
-			 * is active, so we can zero out the whole firmware slot
-			 * log and still claim to fully implement this mandatory
-			 * log page.
-			 */
-			req->execute = nvmet_execute_get_log_page_noop;
-			return 0;
-		case NVME_LOG_CHANGED_NS:
-			req->execute = nvmet_execute_get_log_changed_ns;
-			return 0;
-		case NVME_LOG_CMD_EFFECTS:
-			req->execute = nvmet_execute_get_log_cmd_effects_ns;
-			return 0;
-		case NVME_LOG_ANA:
-			req->execute = nvmet_execute_get_log_page_ana;
-			return 0;
-		}
-		break;
+		return 0;
 	case nvme_admin_identify:
+		req->execute = nvmet_execute_identify;
 		req->data_len = NVME_IDENTIFY_DATA_SIZE;
-		switch (cmd->identify.cns) {
-		case NVME_ID_CNS_NS:
-			req->execute = nvmet_execute_identify_ns;
-			return 0;
-		case NVME_ID_CNS_CTRL:
-			req->execute = nvmet_execute_identify_ctrl;
-			return 0;
-		case NVME_ID_CNS_NS_ACTIVE_LIST:
-			req->execute = nvmet_execute_identify_nslist;
-			return 0;
-		case NVME_ID_CNS_NS_DESC_LIST:
-			req->execute = nvmet_execute_identify_desclist;
-			return 0;
-		}
-		break;
+		return 0;
 	case nvme_admin_abort_cmd:
 		req->execute = nvmet_execute_abort;
 		req->data_len = 0;

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="530436c4.patch"

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4be64703aa47..9696404a6182 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -574,8 +574,14 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	struct nvme_dsm_range *range;
 	struct bio *bio;
 
-	range = kmalloc_array(segments, sizeof(*range),
-				GFP_ATOMIC | __GFP_NOWARN);
+	/*
+	 * Some devices do not consider the DSM 'Number of Ranges' field when
+	 * determining how much data to DMA. Always allocate memory for maximum
+	 * number of segments to prevent device reading beyond end of buffer.
+	 */
+	static const size_t alloc_size = sizeof(*range) * NVME_DSM_MAX_RANGES;
+
+	range = kzalloc(alloc_size, GFP_ATOMIC | __GFP_NOWARN);
 	if (!range) {
 		/*
 		 * If we fail allocation our range, fallback to the controller
@@ -615,7 +621,7 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 
 	req->special_vec.bv_page = virt_to_page(range);
 	req->special_vec.bv_offset = offset_in_page(range);
-	req->special_vec.bv_len = sizeof(*range) * segments;
+	req->special_vec.bv_len = alloc_size;
 	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	return BLK_STS_OK;

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="59ef0eaa.patch"

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 05453f5d1448..7481556da6e6 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -379,8 +379,7 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
 		return 0;
 	case nvme_cmd_dsm:
 		req->execute = nvmet_file_execute_dsm;
-		req->data_len = (le32_to_cpu(cmd->dsm.nr) + 1) *
-			sizeof(struct nvme_dsm_range);
+		req->data_len = nvmet_dsm_len(req);
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_file_execute_write_zeroes;
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index c51f8dd01dc4..6ccf2d098d9f 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -495,6 +495,12 @@ static inline u32 nvmet_rw_len(struct nvmet_req *req)
 			req->ns->blksize_shift;
 }
 
+static inline u32 nvmet_dsm_len(struct nvmet_req *req)
+{
+	return (le32_to_cpu(req->cmd->dsm.nr) + 1) *
+		sizeof(struct nvme_dsm_range);
+}
+
 u16 errno_to_nvme_status(struct nvmet_req *req, int errno);
 
 /* Convert a 32-bit number to a 16-bit 0's based number */

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="6f86f2c9.patch"

diff --git a/drivers/nvme/target/discovery.c b/drivers/nvme/target/discovery.c
index 3764a8900850..825e61e61b0c 100644
--- a/drivers/nvme/target/discovery.c
+++ b/drivers/nvme/target/discovery.c
@@ -157,7 +157,7 @@ static size_t discovery_log_entries(struct nvmet_req *req)
 	return entries;
 }
 
-static void nvmet_execute_get_disc_log_page(struct nvmet_req *req)
+static void nvmet_execute_disc_get_log_page(struct nvmet_req *req)
 {
 	const int entry_size = sizeof(struct nvmf_disc_rsp_page_entry);
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
@@ -171,6 +171,13 @@ static void nvmet_execute_get_disc_log_page(struct nvmet_req *req)
 	u16 status = 0;
 	void *buffer;
 
+	if (req->cmd->get_log_page.lid != NVME_LOG_DISC) {
+		req->error_loc =
+			offsetof(struct nvme_get_log_page_command, lid);
+		status = NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
+		goto out;
+	}
+
 	/* Spec requires dword aligned offsets */
 	if (offset & 0x3) {
 		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
@@ -227,12 +234,18 @@ static void nvmet_execute_get_disc_log_page(struct nvmet_req *req)
 	nvmet_req_complete(req, status);
 }
 
-static void nvmet_execute_identify_disc_ctrl(struct nvmet_req *req)
+static void nvmet_execute_disc_identify(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	struct nvme_id_ctrl *id;
 	u16 status = 0;
 
+	if (req->cmd->identify.cns != NVME_ID_CNS_CTRL) {
+		req->error_loc = offsetof(struct nvme_identify, cns);
+		status = NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
+		goto out;
+	}
+
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
 	if (!id) {
 		status = NVME_SC_INTERNAL;
@@ -344,31 +357,12 @@ u16 nvmet_parse_discovery_cmd(struct nvmet_req *req)
 		return 0;
 	case nvme_admin_get_log_page:
 		req->data_len = nvmet_get_log_page_len(cmd);
-
-		switch (cmd->get_log_page.lid) {
-		case NVME_LOG_DISC:
-			req->execute = nvmet_execute_get_disc_log_page;
-			return 0;
-		default:
-			pr_err("unsupported get_log_page lid %d\n",
-			       cmd->get_log_page.lid);
-			req->error_loc =
-				offsetof(struct nvme_get_log_page_command, lid);
-			return NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
-		}
+		req->execute = nvmet_execute_disc_get_log_page;
+		return 0;
 	case nvme_admin_identify:
 		req->data_len = NVME_IDENTIFY_DATA_SIZE;
-		switch (cmd->identify.cns) {
-		case NVME_ID_CNS_CTRL:
-			req->execute =
-				nvmet_execute_identify_disc_ctrl;
-			return 0;
-		default:
-			pr_err("unsupported identify cns %d\n",
-			       cmd->identify.cns);
-			req->error_loc = offsetof(struct nvme_identify, cns);
-			return NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
-		}
+		req->execute = nvmet_execute_disc_identify;
+		return 0;
 	default:
 		pr_err("unhandled cmd %d\n", cmd->common.opcode);
 		req->error_loc = offsetof(struct nvme_common_command, opcode);

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="b716e688.patch"

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 35810a0a8d21..461987f669c5 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -939,6 +939,17 @@ bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len)
 }
 EXPORT_SYMBOL_GPL(nvmet_check_data_len);
 
+bool nvmet_check_data_len_lte(struct nvmet_req *req, size_t data_len)
+{
+	if (unlikely(data_len > req->transfer_len)) {
+		req->error_loc = offsetof(struct nvme_common_command, dptr);
+		nvmet_req_complete(req, NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR);
+		return false;
+	}
+
+	return true;
+}
+
 int nvmet_req_alloc_sgl(struct nvmet_req *req)
 {
 	struct pci_dev *p2p_dev = NULL;
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index b6fca0e421ef..ea0e596be15d 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -280,7 +280,7 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 
 static void nvmet_bdev_execute_dsm(struct nvmet_req *req)
 {
-	if (!nvmet_check_data_len(req, nvmet_dsm_len(req)))
+	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
 
 	switch (le32_to_cpu(req->cmd->dsm.attributes)) {
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index caebfce06605..cd5670b83118 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -336,7 +336,7 @@ static void nvmet_file_dsm_work(struct work_struct *w)
 
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
-	if (!nvmet_check_data_len(req, nvmet_dsm_len(req)))
+	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
 	schedule_work(&req->f.work);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 46df45e837c9..eda28b22a2c8 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -374,6 +374,7 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 		struct nvmet_sq *sq, const struct nvmet_fabrics_ops *ops);
 void nvmet_req_uninit(struct nvmet_req *req);
 bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len);
+bool nvmet_check_data_len_lte(struct nvmet_req *req, size_t data_len);
 void nvmet_req_complete(struct nvmet_req *req, u16 status);
 int nvmet_req_alloc_sgl(struct nvmet_req *req);
 void nvmet_req_free_sgl(struct nvmet_req *req);

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="be3f3114.patch"

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 565def19d593..cde58c001b23 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -942,12 +942,6 @@ bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len)
 }
 EXPORT_SYMBOL_GPL(nvmet_check_data_len);
 
-void nvmet_req_execute(struct nvmet_req *req)
-{
-	req->execute(req);
-}
-EXPORT_SYMBOL_GPL(nvmet_req_execute);
-
 int nvmet_req_alloc_sgl(struct nvmet_req *req)
 {
 	struct pci_dev *p2p_dev = NULL;
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 61b617698d3f..a0db6371b43e 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2018,7 +2018,7 @@ enum {
 		}
 
 		/* data transfer complete, resume with nvmet layer */
-		nvmet_req_execute(&fod->req);
+		fod->req.execute(&fod->req);
 		break;
 
 	case NVMET_FCOP_READDATA:
@@ -2234,7 +2234,7 @@ enum {
 	 * can invoke the nvmet_layer now. If read data, cmd completion will
 	 * push the data
 	 */
-	nvmet_req_execute(&fod->req);
+	fod->req.execute(&fod->req);
 	return;
 
 transport_error:
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 5b7b19774bb0..856eb0652f89 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -125,7 +125,7 @@ static void nvme_loop_execute_work(struct work_struct *work)
 	struct nvme_loop_iod *iod =
 		container_of(work, struct nvme_loop_iod, work);
 
-	nvmet_req_execute(&iod->req);
+	iod->req.execute(&iod->req);
 }
 
 static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index ff55f1005b35..46df45e837c9 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -374,7 +374,6 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 		struct nvmet_sq *sq, const struct nvmet_fabrics_ops *ops);
 void nvmet_req_uninit(struct nvmet_req *req);
 bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len);
-void nvmet_req_execute(struct nvmet_req *req);
 void nvmet_req_complete(struct nvmet_req *req, u16 status);
 int nvmet_req_alloc_sgl(struct nvmet_req *req);
 void nvmet_req_free_sgl(struct nvmet_req *req);
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index ccf982164136..37d262a65877 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -603,7 +603,7 @@ static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	nvmet_req_execute(&rsp->req);
+	rsp->req.execute(&rsp->req);
 }
 
 static void nvmet_rdma_use_inline_sg(struct nvmet_rdma_rsp *rsp, u32 len,
@@ -746,7 +746,7 @@ static bool nvmet_rdma_execute_command(struct nvmet_rdma_rsp *rsp)
 				queue->cm_id->port_num, &rsp->read_cqe, NULL))
 			nvmet_req_complete(&rsp->req, NVME_SC_DATA_XFER_ERROR);
 	} else {
-		nvmet_req_execute(&rsp->req);
+		rsp->req.execute(&rsp->req);
 	}
 
 	return true;
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 3378480c49f6..af674fc0bb1e 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -930,7 +930,7 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
 		goto out;
 	}
 
-	nvmet_req_execute(&queue->cmd->req);
+	queue->cmd->req.execute(&queue->cmd->req);
 out:
 	nvmet_prepare_receive_pdu(queue);
 	return ret;
@@ -1050,7 +1050,7 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
 			nvmet_tcp_prep_recv_ddgst(cmd);
 			return 0;
 		}
-		nvmet_req_execute(&cmd->req);
+		cmd->req.execute(&cmd->req);
 	}
 
 	nvmet_prepare_receive_pdu(queue);
@@ -1090,7 +1090,7 @@ static int nvmet_tcp_try_recv_ddgst(struct nvmet_tcp_queue *queue)
 
 	if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED) &&
 	    cmd->rbytes_done == cmd->req.transfer_len)
-		nvmet_req_execute(&cmd->req);
+		cmd->req.execute(&cmd->req);
 	ret = 0;
 out:
 	nvmet_prepare_receive_pdu(queue);

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e9061c39.patch"

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 3665b45d6515..cd2c3a79f3b5 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -31,7 +31,7 @@ u64 nvmet_get_log_page_offset(struct nvme_command *cmd)
 
 static void nvmet_execute_get_log_page_noop(struct nvmet_req *req)
 {
-	nvmet_req_complete(req, nvmet_zero_sgl(req, 0, req->data_len));
+	nvmet_req_complete(req, nvmet_zero_sgl(req, 0, req->transfer_len));
 }
 
 static void nvmet_execute_get_log_page_error(struct nvmet_req *req)
@@ -134,7 +134,7 @@ static void nvmet_execute_get_log_page_smart(struct nvmet_req *req)
 	u16 status = NVME_SC_INTERNAL;
 	unsigned long flags;
 
-	if (req->data_len != sizeof(*log))
+	if (req->transfer_len != sizeof(*log))
 		goto out;
 
 	log = kzalloc(sizeof(*log), GFP_KERNEL);
@@ -196,7 +196,7 @@ static void nvmet_execute_get_log_changed_ns(struct nvmet_req *req)
 	u16 status = NVME_SC_INTERNAL;
 	size_t len;
 
-	if (req->data_len != NVME_MAX_CHANGED_NAMESPACES * sizeof(__le32))
+	if (req->transfer_len != NVME_MAX_CHANGED_NAMESPACES * sizeof(__le32))
 		goto out;
 
 	mutex_lock(&ctrl->lock);
@@ -206,7 +206,7 @@ static void nvmet_execute_get_log_changed_ns(struct nvmet_req *req)
 		len = ctrl->nr_changed_ns * sizeof(__le32);
 	status = nvmet_copy_to_sgl(req, 0, ctrl->changed_ns_list, len);
 	if (!status)
-		status = nvmet_zero_sgl(req, len, req->data_len - len);
+		status = nvmet_zero_sgl(req, len, req->transfer_len - len);
 	ctrl->nr_changed_ns = 0;
 	nvmet_clear_aen_bit(req, NVME_AEN_BIT_NS_ATTR);
 	mutex_unlock(&ctrl->lock);
@@ -284,6 +284,9 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 
 static void nvmet_execute_get_log_page(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, nvmet_get_log_page_len(req->cmd)))
+		return;
+
 	switch (req->cmd->get_log_page.lid) {
 	case NVME_LOG_ERROR:
 		return nvmet_execute_get_log_page_error(req);
@@ -594,6 +597,9 @@ static void nvmet_execute_identify_desclist(struct nvmet_req *req)
 
 static void nvmet_execute_identify(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, NVME_IDENTIFY_DATA_SIZE))
+		return;
+
 	switch (req->cmd->identify.cns) {
 	case NVME_ID_CNS_NS:
 		return nvmet_execute_identify_ns(req);
@@ -620,6 +626,8 @@ static void nvmet_execute_identify(struct nvmet_req *req)
  */
 static void nvmet_execute_abort(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, 0))
+		return;
 	nvmet_set_result(req, 1);
 	nvmet_req_complete(req, 0);
 }
@@ -704,6 +712,9 @@ static void nvmet_execute_set_features(struct nvmet_req *req)
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u16 status = 0;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	switch (cdw10 & 0xff) {
 	case NVME_FEAT_NUM_QUEUES:
 		nvmet_set_result(req,
@@ -767,6 +778,9 @@ static void nvmet_execute_get_features(struct nvmet_req *req)
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u16 status = 0;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	switch (cdw10 & 0xff) {
 	/*
 	 * These features are mandatory in the spec, but we don't
@@ -831,6 +845,9 @@ void nvmet_execute_async_event(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	mutex_lock(&ctrl->lock);
 	if (ctrl->nr_async_event_cmds >= NVMET_ASYNC_EVENTS) {
 		mutex_unlock(&ctrl->lock);
@@ -847,6 +864,9 @@ void nvmet_execute_keep_alive(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	pr_debug("ctrl %d update keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
 
@@ -866,31 +886,24 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
 	switch (cmd->common.opcode) {
 	case nvme_admin_get_log_page:
 		req->execute = nvmet_execute_get_log_page;
-		req->data_len = nvmet_get_log_page_len(cmd);
 		return 0;
 	case nvme_admin_identify:
 		req->execute = nvmet_execute_identify;
-		req->data_len = NVME_IDENTIFY_DATA_SIZE;
 		return 0;
 	case nvme_admin_abort_cmd:
 		req->execute = nvmet_execute_abort;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_set_features:
 		req->execute = nvmet_execute_set_features;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_get_features:
 		req->execute = nvmet_execute_get_features;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_async_event:
 		req->execute = nvmet_execute_async_event;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_keep_alive:
 		req->execute = nvmet_execute_keep_alive;
-		req->data_len = 0;
 		return 0;
 	}
 
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 6b39cfc6ade1..565def19d593 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -930,13 +930,21 @@ void nvmet_req_uninit(struct nvmet_req *req)
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
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(nvmet_check_data_len);
+
+void nvmet_req_execute(struct nvmet_req *req)
+{
+	req->execute(req);
 }
 EXPORT_SYMBOL_GPL(nvmet_req_execute);
 
diff --git a/drivers/nvme/target/discovery.c b/drivers/nvme/target/discovery.c
index 825e61e61b0c..7a868c3e8e95 100644
--- a/drivers/nvme/target/discovery.c
+++ b/drivers/nvme/target/discovery.c
@@ -171,6 +171,9 @@ static void nvmet_execute_disc_get_log_page(struct nvmet_req *req)
 	u16 status = 0;
 	void *buffer;
 
+	if (!nvmet_check_data_len(req, data_len))
+		return;
+
 	if (req->cmd->get_log_page.lid != NVME_LOG_DISC) {
 		req->error_loc =
 			offsetof(struct nvme_get_log_page_command, lid);
@@ -240,6 +243,9 @@ static void nvmet_execute_disc_identify(struct nvmet_req *req)
 	struct nvme_id_ctrl *id;
 	u16 status = 0;
 
+	if (!nvmet_check_data_len(req, NVME_IDENTIFY_DATA_SIZE))
+		return;
+
 	if (req->cmd->identify.cns != NVME_ID_CNS_CTRL) {
 		req->error_loc = offsetof(struct nvme_identify, cns);
 		status = NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
@@ -286,6 +292,9 @@ static void nvmet_execute_disc_set_features(struct nvmet_req *req)
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u16 stat;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	switch (cdw10 & 0xff) {
 	case NVME_FEAT_KATO:
 		stat = nvmet_set_feat_kato(req);
@@ -309,6 +318,9 @@ static void nvmet_execute_disc_get_features(struct nvmet_req *req)
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u16 stat = 0;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	switch (cdw10 & 0xff) {
 	case NVME_FEAT_KATO:
 		nvmet_get_feat_kato(req);
@@ -341,26 +353,20 @@ u16 nvmet_parse_discovery_cmd(struct nvmet_req *req)
 	switch (cmd->common.opcode) {
 	case nvme_admin_set_features:
 		req->execute = nvmet_execute_disc_set_features;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_get_features:
 		req->execute = nvmet_execute_disc_get_features;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_async_event:
 		req->execute = nvmet_execute_async_event;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_keep_alive:
 		req->execute = nvmet_execute_keep_alive;
-		req->data_len = 0;
 		return 0;
 	case nvme_admin_get_log_page:
-		req->data_len = nvmet_get_log_page_len(cmd);
 		req->execute = nvmet_execute_disc_get_log_page;
 		return 0;
 	case nvme_admin_identify:
-		req->data_len = NVME_IDENTIFY_DATA_SIZE;
 		req->execute = nvmet_execute_disc_identify;
 		return 0;
 	default:
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index d16b55ffe79f..f7297473d9eb 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -12,6 +12,9 @@ static void nvmet_execute_prop_set(struct nvmet_req *req)
 	u64 val = le64_to_cpu(req->cmd->prop_set.value);
 	u16 status = 0;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	if (req->cmd->prop_set.attrib & 1) {
 		req->error_loc =
 			offsetof(struct nvmf_property_set_command, attrib);
@@ -38,6 +41,9 @@ static void nvmet_execute_prop_get(struct nvmet_req *req)
 	u16 status = 0;
 	u64 val = 0;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	if (req->cmd->prop_get.attrib & 1) {
 		switch (le32_to_cpu(req->cmd->prop_get.offset)) {
 		case NVME_REG_CAP:
@@ -82,11 +88,9 @@ u16 nvmet_parse_fabrics_cmd(struct nvmet_req *req)
 
 	switch (cmd->fabrics.fctype) {
 	case nvme_fabrics_type_property_set:
-		req->data_len = 0;
 		req->execute = nvmet_execute_prop_set;
 		break;
 	case nvme_fabrics_type_property_get:
-		req->data_len = 0;
 		req->execute = nvmet_execute_prop_get;
 		break;
 	default:
@@ -147,6 +151,9 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 	struct nvmet_ctrl *ctrl = NULL;
 	u16 status = 0;
 
+	if (!nvmet_check_data_len(req, sizeof(struct nvmf_connect_data)))
+		return;
+
 	d = kmalloc(sizeof(*d), GFP_KERNEL);
 	if (!d) {
 		status = NVME_SC_INTERNAL;
@@ -211,6 +218,9 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	u16 qid = le16_to_cpu(c->qid);
 	u16 status = 0;
 
+	if (!nvmet_check_data_len(req, sizeof(struct nvmf_connect_data)))
+		return;
+
 	d = kmalloc(sizeof(*d), GFP_KERNEL);
 	if (!d) {
 		status = NVME_SC_INTERNAL;
@@ -281,7 +291,6 @@ u16 nvmet_parse_connect_cmd(struct nvmet_req *req)
 		return NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
 	}
 
-	req->data_len = sizeof(struct nvmf_connect_data);
 	if (cmd->connect.qid == 0)
 		req->execute = nvmet_execute_admin_connect;
 	else
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index f2618dc2ef3a..04a9cd2a2604 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -150,6 +150,9 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 	sector_t sector;
 	int op, op_flags = 0, i;
 
+	if (!nvmet_check_data_len(req, nvmet_rw_len(req)))
+		return;
+
 	if (!req->sg_cnt) {
 		nvmet_req_complete(req, 0);
 		return;
@@ -170,7 +173,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 	sector = le64_to_cpu(req->cmd->rw.slba);
 	sector <<= (req->ns->blksize_shift - 9);
 
-	if (req->data_len <= NVMET_MAX_INLINE_DATA_LEN) {
+	if (req->transfer_len <= NVMET_MAX_INLINE_DATA_LEN) {
 		bio = &req->b.inline_bio;
 		bio_init(bio, req->inline_bvec, ARRAY_SIZE(req->inline_bvec));
 	} else {
@@ -207,6 +210,9 @@ static void nvmet_bdev_execute_flush(struct nvmet_req *req)
 {
 	struct bio *bio = &req->b.inline_bio;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	bio_init(bio, req->inline_bvec, ARRAY_SIZE(req->inline_bvec));
 	bio_set_dev(bio, req->ns->bdev);
 	bio->bi_private = req;
@@ -272,6 +278,9 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 
 static void nvmet_bdev_execute_dsm(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, nvmet_dsm_len(req)))
+		return;
+
 	switch (le32_to_cpu(req->cmd->dsm.attributes)) {
 	case NVME_DSMGMT_AD:
 		nvmet_bdev_execute_discard(req);
@@ -293,6 +302,9 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	sector_t nr_sector;
 	int ret;
 
+	if (!nvmet_check_data_len(req, 0))
+		return;
+
 	sector = le64_to_cpu(write_zeroes->slba) <<
 		(req->ns->blksize_shift - 9);
 	nr_sector = (((sector_t)le16_to_cpu(write_zeroes->length) + 1) <<
@@ -317,20 +329,15 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
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
index 7481556da6e6..caebfce06605 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -126,7 +126,7 @@ static void nvmet_file_io_done(struct kiocb *iocb, long ret, long ret2)
 			mempool_free(req->f.bvec, req->ns->bvec_pool);
 	}
 
-	if (unlikely(ret != req->data_len))
+	if (unlikely(ret != req->transfer_len))
 		status = errno_to_nvme_status(req, ret);
 	nvmet_req_complete(req, status);
 }
@@ -146,7 +146,7 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 		is_sync = true;
 
 	pos = le64_to_cpu(req->cmd->rw.slba) << req->ns->blksize_shift;
-	if (unlikely(pos + req->data_len > req->ns->size)) {
+	if (unlikely(pos + req->transfer_len > req->ns->size)) {
 		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
 		return true;
 	}
@@ -173,7 +173,7 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 		nr_bvec--;
 	}
 
-	if (WARN_ON_ONCE(total_len != req->data_len)) {
+	if (WARN_ON_ONCE(total_len != req->transfer_len)) {
 		ret = -EIO;
 		goto complete;
 	}
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
@@ -331,6 +336,8 @@ static void nvmet_file_dsm_work(struct work_struct *w)
 
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, nvmet_dsm_len(req)))
+		return;
 	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
 	schedule_work(&req->f.work);
 }
@@ -359,6 +366,8 @@ static void nvmet_file_write_zeroes_work(struct work_struct *w)
 
 static void nvmet_file_execute_write_zeroes(struct nvmet_req *req)
 {
+	if (!nvmet_check_data_len(req, 0))
+		return;
 	INIT_WORK(&req->f.work, nvmet_file_write_zeroes_work);
 	schedule_work(&req->f.work);
 }
@@ -371,19 +380,15 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
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
-		req->data_len = nvmet_dsm_len(req);
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_file_execute_write_zeroes;
-		req->data_len = 0;
 		return 0;
 	default:
 		pr_err("unhandled cmd for file ns %d on qid %d\n",
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 6ccf2d098d9f..ff55f1005b35 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -304,8 +304,6 @@ struct nvmet_req {
 		} f;
 	};
 	int			sg_cnt;
-	/* data length as parsed from the command: */
-	size_t			data_len;
 	/* data length as parsed from the SGL descriptor: */
 	size_t			transfer_len;
 
@@ -375,6 +373,7 @@ static inline bool nvmet_aen_bit_disabled(struct nvmet_ctrl *ctrl, u32 bn)
 bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 		struct nvmet_sq *sq, const struct nvmet_fabrics_ops *ops);
 void nvmet_req_uninit(struct nvmet_req *req);
+bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len);
 void nvmet_req_execute(struct nvmet_req *req);
 void nvmet_req_complete(struct nvmet_req *req, u16 status);
 int nvmet_req_alloc_sgl(struct nvmet_req *req);

--C7zPtVaVf+AK4Oqc--
