Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB631259892
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbgIAQ20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbgIAPcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:32:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7EEE21548;
        Tue,  1 Sep 2020 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974320;
        bh=igFLgAPBjGzvMF/y+IQ59KaFgYmVYOPfdPx8ZzrjThA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mD8oxMFGh/6Fv+u6hOXtR2pinuiL1bSBiDXJAT2xuGTU+VhqeZCSw6B1fg79W3Z01
         3ItUGXwiQMeJLAVks/Sil+qMP7YacimHMa+E8PsqxH/kRwmD0ycOR4oeWmjppIzoAG
         0+3hjKAA6gUy4xeQYHzYF4eVeUkPjfnSHq3Rb9aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Changpeng Liu <changpeng.liu@intel.com>,
        Daniel Verkamp <dverkamp@chromium.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/214] block: virtio_blk: fix handling single range discard request
Date:   Tue,  1 Sep 2020 17:09:40 +0200
Message-Id: <20200901150957.787929636@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit af822aa68fbdf0a480a17462ed70232998127453 ]

1f23816b8eb8 ("virtio_blk: add discard and write zeroes support") starts
to support multi-range discard for virtio-blk. However, the virtio-blk
disk may report max discard segment as 1, at least that is exactly what
qemu is doing.

So far, block layer switches to normal request merge if max discard segment
limit is 1, and multiple bios can be merged to single segment. This way may
cause memory corruption in virtblk_setup_discard_write_zeroes().

Fix the issue by handling single max discard segment in straightforward
way.

Fixes: 1f23816b8eb8 ("virtio_blk: add discard and write zeroes support")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Changpeng Liu <changpeng.liu@intel.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c1de270046bfe..2eeb2bcb488d4 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -205,16 +205,31 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
 	if (!range)
 		return -ENOMEM;
 
-	__rq_for_each_bio(bio, req) {
-		u64 sector = bio->bi_iter.bi_sector;
-		u32 num_sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
-
-		range[n].flags = cpu_to_le32(flags);
-		range[n].num_sectors = cpu_to_le32(num_sectors);
-		range[n].sector = cpu_to_le64(sector);
-		n++;
+	/*
+	 * Single max discard segment means multi-range discard isn't
+	 * supported, and block layer only runs contiguity merge like
+	 * normal RW request. So we can't reply on bio for retrieving
+	 * each range info.
+	 */
+	if (queue_max_discard_segments(req->q) == 1) {
+		range[0].flags = cpu_to_le32(flags);
+		range[0].num_sectors = cpu_to_le32(blk_rq_sectors(req));
+		range[0].sector = cpu_to_le64(blk_rq_pos(req));
+		n = 1;
+	} else {
+		__rq_for_each_bio(bio, req) {
+			u64 sector = bio->bi_iter.bi_sector;
+			u32 num_sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+
+			range[n].flags = cpu_to_le32(flags);
+			range[n].num_sectors = cpu_to_le32(num_sectors);
+			range[n].sector = cpu_to_le64(sector);
+			n++;
+		}
 	}
 
+	WARN_ON_ONCE(n != segments);
+
 	req->special_vec.bv_page = virt_to_page(range);
 	req->special_vec.bv_offset = offset_in_page(range);
 	req->special_vec.bv_len = sizeof(*range) * segments;
-- 
2.25.1



