Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DCF177F1E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgCCRsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731677AbgCCRsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D210D20CC7;
        Tue,  3 Mar 2020 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257729;
        bh=suz0D/D2dzRGQclTwBiN+1zSd0FQxwwst2MdgJCDEqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6vgX3H7cDr39XItKhflLeof5Bw8ueWont1WZcHwIScv3MoXJ8G3fPhE0QV91QWng
         KywaqOot+qpjYXu34t1eeBbAM9S60kRqZgW9V6zlU/tWpvAFHqc0QSTdo297ZvMDuL
         MvXzCy5+oMilAPWlQrSRd6nNdZE8pKNNViTOkHlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.5 081/176] scsi: sd_sbc: Fix sd_zbc_report_zones()
Date:   Tue,  3 Mar 2020 18:42:25 +0100
Message-Id: <20200303174314.030529780@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 51fdaa0490241e8cd41b40cbf43a336d1a014460 upstream.

The block layer generic blk_revalidate_disk_zones() checks the validity of
zone descriptors reported by a disk using the blk_revalidate_zone_cb()
callback function executed for each zone descriptor. If a ZBC disk reports
invalid zone descriptors, blk_revalidate_disk_zones() returns an error and
sd_zbc_read_zones() changes the disk capacity to 0, which in turn results
in the gendisk structure capacity to be set to 0. This all works well for
the first revalidate pass on a disk and the block layer detects the
capactiy change.

On the second revalidate pass, blk_revalidate_disk_zones() is called again
and sd_zbc_report_zones() executed to check the zones a second time.
However, for this second pass, the gendisk capacity is now 0, which results
in sd_zbc_report_zones() to do nothing and to report success and no
zones. blk_revalidate_disk_zones() in turn returns success and sets the
disk queue chunk_sectors limit with zero as no zones were checked, causing
a oops to trigger on the BUG_ON(!is_power_of_2(chunk_sectors)) in
blk_queue_chunk_sectors().

Fix this by using the sdkp capacity field rather than the gendisk capacity
for the report zones loop in sd_zbc_report_zones(). Also add a check to
return immediately an error if the sdkp capacity is 0.  With this fix,
invalid/buggy ZBC disk scan does not trigger a oops and are exposed with a
0 capacity. This change also preserve the chance for the disk to be
correctly revalidated on the second revalidate pass as the scsi disk
structure capacity field is always set to the disk reported value when
sd_zbc_report_zones() is called.

Link: https://lore.kernel.org/r/20200219063800.880834-1-damien.lemoal@wdc.com
Fixes: d41003513e61 ("block: rework zone reporting")
Cc: Cc: <stable@vger.kernel.org> # v5.5
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd_zbc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -161,6 +161,7 @@ int sd_zbc_report_zones(struct gendisk *
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -171,11 +172,15 @@ int sd_zbc_report_zones(struct gendisk *
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
+	if (!capacity)
+		/* Device gone or invalid */
+		return -ENODEV;
+
 	buf = sd_zbc_alloc_report_buffer(sdkp, nr_zones, &buflen);
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && sector < get_capacity(disk)) {
+	while (zone_idx < nr_zones && sector < capacity) {
 		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
 				sectors_to_logical(sdkp->device, sector), true);
 		if (ret)


