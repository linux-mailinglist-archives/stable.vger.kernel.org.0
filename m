Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E342334413A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhCVMbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230404AbhCVMbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20170619A2;
        Mon, 22 Mar 2021 12:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416263;
        bh=dXOsMTVrzLOh5bEkvsUAk+4jEbrLp6jABFMQDckHo60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXCc6GmdNY0xufcjLMTF1odZ+/YMltVcVySCwmRzdiUuNjdPXAhK3v0H2Gw9QtPuM
         vKnwxtJmd98tB4ozROaGCmD20UeX5LZx4mxeqZqREx6M69cJQiLIf4UPXC5Ltf1DU6
         NYbfWDXmTVxF1V4MihqFAjcdbZDR6Dz6JDcLGB14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <k.jensen@samsung.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 5.11 041/120] nvme: fix Write Zeroes limitations
Date:   Mon, 22 Mar 2021 13:27:04 +0100
Message-Id: <20210322121931.027925709@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b94e8cd2e6a94fc7563529ddc82726a7e77e04de upstream.

We voluntarily limit the Write Zeroes sizes to the MDTS value provided by
the hardware, but currently get the units wrong, so fix that.

Fixes: 6e02318eaea5 ("nvme: add support for the Write Zeroes command")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Tested-by: Klaus Jensen <k.jensen@samsung.com>
Reviewed-by: Klaus Jensen <k.jensen@samsung.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1948,30 +1948,18 @@ static void nvme_config_discard(struct g
 		blk_queue_max_write_zeroes_sectors(queue, UINT_MAX);
 }
 
-static void nvme_config_write_zeroes(struct gendisk *disk, struct nvme_ns *ns)
-{
-	u64 max_blocks;
-
-	if (!(ns->ctrl->oncs & NVME_CTRL_ONCS_WRITE_ZEROES) ||
-	    (ns->ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
-		return;
-	/*
-	 * Even though NVMe spec explicitly states that MDTS is not
-	 * applicable to the write-zeroes:- "The restriction does not apply to
-	 * commands that do not transfer data between the host and the
-	 * controller (e.g., Write Uncorrectable ro Write Zeroes command).".
-	 * In order to be more cautious use controller's max_hw_sectors value
-	 * to configure the maximum sectors for the write-zeroes which is
-	 * configured based on the controller's MDTS field in the
-	 * nvme_init_identify() if available.
-	 */
-	if (ns->ctrl->max_hw_sectors == UINT_MAX)
-		max_blocks = (u64)USHRT_MAX + 1;
-	else
-		max_blocks = ns->ctrl->max_hw_sectors + 1;
-
-	blk_queue_max_write_zeroes_sectors(disk->queue,
-					   nvme_lba_to_sect(ns, max_blocks));
+/*
+ * Even though NVMe spec explicitly states that MDTS is not applicable to the
+ * write-zeroes, we are cautious and limit the size to the controllers
+ * max_hw_sectors value, which is based on the MDTS field and possibly other
+ * limiting factors.
+ */
+static void nvme_config_write_zeroes(struct request_queue *q,
+		struct nvme_ctrl *ctrl)
+{
+	if ((ctrl->oncs & NVME_CTRL_ONCS_WRITE_ZEROES) &&
+	    !(ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
+		blk_queue_max_write_zeroes_sectors(q, ctrl->max_hw_sectors);
 }
 
 static bool nvme_ns_ids_valid(struct nvme_ns_ids *ids)
@@ -2143,7 +2131,7 @@ static void nvme_update_disk_info(struct
 	set_capacity_and_notify(disk, capacity);
 
 	nvme_config_discard(disk, ns);
-	nvme_config_write_zeroes(disk, ns);
+	nvme_config_write_zeroes(disk->queue, ns->ctrl);
 
 	if ((id->nsattr & NVME_NS_ATTR_RO) ||
 	    test_bit(NVME_NS_FORCE_RO, &ns->flags))


