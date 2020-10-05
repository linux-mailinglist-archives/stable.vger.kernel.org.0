Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406E6283AF3
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgJEPiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgJEPax (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F532074F;
        Mon,  5 Oct 2020 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911852;
        bh=hFZ2Cj1jPM+ORT1KbOJS5DWU4Mhjq3+d26+Fw7EeSEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wsu2sFRxVpZN2RfFPmSa4NgpcWT4YLHYBbGtWxebEdNz15Cwr3Qfl7MDzpDZge3Pt
         FNFa+wjwrAepxh+/pnWWj5sKKMBs/I8Uuulaa2DMDGpIuhMRhNUZS4w9l9FLb1b0DG
         AFLzkb5TjDlAkQYNRqHSy91tOIISLypeMYp0UEhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Revanth Rajashekar <revanth.rajashekar@intel.com>
Subject: [PATCH 5.4 50/57] nvme: Cleanup and rename nvme_block_nr()
Date:   Mon,  5 Oct 2020 17:27:02 +0200
Message-Id: <20201005142112.202881686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 314d48dd224897e35ddcaf5a1d7d133b5adddeb7 upstream.

Rename nvme_block_nr() to nvme_sect_to_lba() and use SECTOR_SHIFT
instead of its hard coded value 9. Also add a comment to decribe this
helper.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |    6 +++---
 drivers/nvme/host/nvme.h |    7 +++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -630,7 +630,7 @@ static blk_status_t nvme_setup_discard(s
 	}
 
 	__rq_for_each_bio(bio, req) {
-		u64 slba = nvme_block_nr(ns, bio->bi_iter.bi_sector);
+		u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
 		u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
 
 		if (n < segments) {
@@ -671,7 +671,7 @@ static inline blk_status_t nvme_setup_wr
 	cmnd->write_zeroes.opcode = nvme_cmd_write_zeroes;
 	cmnd->write_zeroes.nsid = cpu_to_le32(ns->head->ns_id);
 	cmnd->write_zeroes.slba =
-		cpu_to_le64(nvme_block_nr(ns, blk_rq_pos(req)));
+		cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
 	cmnd->write_zeroes.length =
 		cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
 	cmnd->write_zeroes.control = 0;
@@ -695,7 +695,7 @@ static inline blk_status_t nvme_setup_rw
 
 	cmnd->rw.opcode = (rq_data_dir(req) ? nvme_cmd_write : nvme_cmd_read);
 	cmnd->rw.nsid = cpu_to_le32(ns->head->ns_id);
-	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, blk_rq_pos(req)));
+	cmnd->rw.slba = cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
 	cmnd->rw.length = cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
 
 	if (req_op(req) == REQ_OP_WRITE && ctrl->nr_streams)
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -429,9 +429,12 @@ static inline int nvme_reset_subsystem(s
 	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
 }
 
-static inline u64 nvme_block_nr(struct nvme_ns *ns, sector_t sector)
+/*
+ * Convert a 512B sector number to a device logical block number.
+ */
+static inline u64 nvme_sect_to_lba(struct nvme_ns *ns, sector_t sector)
 {
-	return (sector >> (ns->lba_shift - 9));
+	return sector >> (ns->lba_shift - SECTOR_SHIFT);
 }
 
 static inline void nvme_end_request(struct request *req, __le16 status,


