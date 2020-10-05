Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65A3283A16
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgJEPbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgJEPa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B153208C7;
        Mon,  5 Oct 2020 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911858;
        bh=V536KcdNvxVyDh188gN62lpom3k/ICSNV9mzVKKowMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK1k9IBpKG3VuVwbdoRtWBGBG1oX5GUM4v/oetJ2OxfsWluf8nbKn14IEcPM7VWgi
         C+shBvOk0R83HPvDq7rMRrVH+AU4+y++IPzTUsigJnndTrj7kl9JAXwhoUIOM7IBPJ
         1tdglbuZMDgic13Nt4sqFM/UhKAdkR6t2eeX7MHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Revanth Rajashekar <revanth.rajashekar@intel.com>
Subject: [PATCH 5.4 52/57] nvme: consolidate chunk_sectors settings
Date:   Mon,  5 Oct 2020 17:27:04 +0200
Message-Id: <20201005142112.302461357@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 38adf94e166e3cb4eb89683458ca578051e8218d upstream.

Move the quirked chunk_sectors setting to the same location as noiob so
one place registers this setting. And since the noiob value is only used
locally, remove the member from struct nvme_ns.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |   22 ++++++++++------------
 drivers/nvme/host/nvme.h |    1 -
 2 files changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1680,12 +1680,6 @@ static void nvme_init_integrity(struct g
 }
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-static void nvme_set_chunk_size(struct nvme_ns *ns)
-{
-	u32 chunk_size = nvme_lba_to_sect(ns, ns->noiob);
-	blk_queue_chunk_sectors(ns->queue, rounddown_pow_of_two(chunk_size));
-}
-
 static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 {
 	struct nvme_ctrl *ctrl = ns->ctrl;
@@ -1840,6 +1834,7 @@ static void nvme_update_disk_info(struct
 static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 {
 	struct nvme_ns *ns = disk->private_data;
+	u32 iob;
 
 	/*
 	 * If identify namespace failed, use default 512 byte block size so
@@ -1848,7 +1843,13 @@ static void __nvme_revalidate_disk(struc
 	ns->lba_shift = id->lbaf[id->flbas & NVME_NS_FLBAS_LBA_MASK].ds;
 	if (ns->lba_shift == 0)
 		ns->lba_shift = 9;
-	ns->noiob = le16_to_cpu(id->noiob);
+
+	if ((ns->ctrl->quirks & NVME_QUIRK_STRIPE_SIZE) &&
+	    is_power_of_2(ns->ctrl->max_hw_sectors))
+		iob = ns->ctrl->max_hw_sectors;
+	else
+		iob = nvme_lba_to_sect(ns, le16_to_cpu(id->noiob));
+
 	ns->ms = le16_to_cpu(id->lbaf[id->flbas & NVME_NS_FLBAS_LBA_MASK].ms);
 	ns->ext = ns->ms && (id->flbas & NVME_NS_FLBAS_META_EXT);
 	/* the PI implementation requires metadata equal t10 pi tuple size */
@@ -1857,8 +1858,8 @@ static void __nvme_revalidate_disk(struc
 	else
 		ns->pi_type = 0;
 
-	if (ns->noiob)
-		nvme_set_chunk_size(ns);
+	if (iob)
+		blk_queue_chunk_sectors(ns->queue, rounddown_pow_of_two(iob));
 	nvme_update_disk_info(disk, ns, id);
 #ifdef CONFIG_NVME_MULTIPATH
 	if (ns->head->disk) {
@@ -2209,9 +2210,6 @@ static void nvme_set_queue_limits(struct
 		blk_queue_max_hw_sectors(q, ctrl->max_hw_sectors);
 		blk_queue_max_segments(q, min_t(u32, max_segments, USHRT_MAX));
 	}
-	if ((ctrl->quirks & NVME_QUIRK_STRIPE_SIZE) &&
-	    is_power_of_2(ctrl->max_hw_sectors))
-		blk_queue_chunk_sectors(q, ctrl->max_hw_sectors);
 	blk_queue_virt_boundary(q, ctrl->page_size - 1);
 	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
 		vwc = true;
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -384,7 +384,6 @@ struct nvme_ns {
 #define NVME_NS_REMOVING	0
 #define NVME_NS_DEAD     	1
 #define NVME_NS_ANA_PENDING	2
-	u16 noiob;
 
 	struct nvme_fault_inject fault_inject;
 


