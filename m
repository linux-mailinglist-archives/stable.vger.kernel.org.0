Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0564395F02
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhEaOGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233309AbhEaOEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:04:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50DBD61450;
        Mon, 31 May 2021 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468291;
        bh=IDRMAJny6+HkyjOT/E48tl0bKg98knhfTnaG8j+C9r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUWeB/oa/bfpD5yBrtF+gVwpjhXdHdGvkOhTaFB1aV//4Zr6HbuALNNIzm/DGumxo
         BoeAHh5i0w6cbpCr8/knRbMnoZxXrgBeq8mSUE0brgw0phNeIi8jqZh/UXnWAxNFc+
         TVy9SIwXlirXoXQj1WpBEMR/RNHORZsvJRZQ33RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gulam Mohamed <gulam.mohamed@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/252] block: fix a race between del_gendisk and BLKRRPART
Date:   Mon, 31 May 2021 15:14:12 +0200
Message-Id: <20210531130704.362107639@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gulam Mohamed <gulam.mohamed@oracle.com>

[ Upstream commit bc6a385132601c29a6da1dbf8148c0d3c9ad36dc ]

When BLKRRPART is called concurrently with del_gendisk, the partitions
rescan can create a stale partition that will never be be cleaned up.

Fix this by checking the the disk is up before rescanning partitions
while under bd_mutex.

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210514131842.1600568-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/block_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index cacea6bafc22..29f020c4b2d0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1408,6 +1408,9 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
 	lockdep_assert_held(&bdev->bd_mutex);
 
+	if (!(disk->flags & GENHD_FL_UP))
+		return -ENXIO;
+
 rescan:
 	ret = blk_drop_partitions(bdev);
 	if (ret)
-- 
2.30.2



