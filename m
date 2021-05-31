Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBDC396247
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhEaOxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhEaOvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B891161CA5;
        Mon, 31 May 2021 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469490;
        bh=FfLlHbhceFQpqIb6A/9hOSiqrfjkSpTDA/qbL078WLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQaaF2gfsyq/kOt7pxz0ayw3nL3ckI9chrVJpY54gkKtGasLvTQC8du4HW+87IW3p
         uaa8GC79Aepngp+fN9uJsHQk2OVIfPosnTxRo7Wg0sfORwRLjihOjfbDwybfN6+rUv
         9Tpe+mpMpYZzI9F52KlYlcDMbFHqNWdwqA+pndzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gulam Mohamed <gulam.mohamed@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 218/296] block: fix a race between del_gendisk and BLKRRPART
Date:   Mon, 31 May 2021 15:14:33 +0200
Message-Id: <20210531130711.168211296@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
index a5a6a7930e5e..389609bc5aa3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1244,6 +1244,9 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
 	lockdep_assert_held(&bdev->bd_mutex);
 
+	if (!(disk->flags & GENHD_FL_UP))
+		return -ENXIO;
+
 rescan:
 	ret = blk_drop_partitions(bdev);
 	if (ret)
-- 
2.30.2



