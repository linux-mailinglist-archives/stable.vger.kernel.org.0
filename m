Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F596D4900
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjDCOdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbjDCOds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38E51765C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6B6B81C77
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10932C4339B;
        Mon,  3 Apr 2023 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532411;
        bh=SmcftsvKCxIdYP4tVoqBlQNnERCk8DK4sxTkUc/xlvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1uTalXuinv0m/iebr0Ev5SctiEikiRsRH090GlaP5iD4genBom+vdJvvkDNQh8u7
         3KYEYUnzL8x6NHfbblGduiCsLXD4ZIZWdWTwjE926Qkkr6nflp+YrHxVSqDOIlbrw6
         JigcY/nQc38o3QgzwctP+2Rzl6EUwqDxZh9xDArQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Holmberg <Hans.Holmberg@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 5.15 72/99] zonefs: Always invalidate last cached page on append write
Date:   Mon,  3 Apr 2023 16:09:35 +0200
Message-Id: <20230403140406.192229761@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit c1976bd8f23016d8706973908f2bb0ac0d852a8f upstream.

When a direct append write is executed, the append offset may correspond
to the last page of a sequential file inode which might have been cached
already by buffered reads, page faults with mmap-read or non-direct
readahead. To ensure that the on-disk and cached data is consistant for
such last cached page, make sure to always invalidate it in
zonefs_file_dio_append(). If the invalidation fails, return -EBUSY to
userspace to differentiate from IO errors.

This invalidation will always be a no-op when the FS block size (device
zone write granularity) is equal to the page size (e.g. 4K).

Reported-by: Hans Holmberg <Hans.Holmberg@wdc.com>
Fixes: 02ef12a663c7 ("zonefs: use REQ_OP_ZONE_APPEND for sync DIO")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -736,6 +736,7 @@ static ssize_t zonefs_file_dio_append(st
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct block_device *bdev = inode->i_sb->s_bdev;
 	unsigned int max = bdev_max_zone_append_sectors(bdev);
+	pgoff_t start, end;
 	struct bio *bio;
 	ssize_t size;
 	int nr_pages;
@@ -744,6 +745,19 @@ static ssize_t zonefs_file_dio_append(st
 	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
 	iov_iter_truncate(from, max);
 
+	/*
+	 * If the inode block size (zone write granularity) is smaller than the
+	 * page size, we may be appending data belonging to the last page of the
+	 * inode straddling inode->i_size, with that page already cached due to
+	 * a buffered read or readahead. So make sure to invalidate that page.
+	 * This will always be a no-op for the case where the block size is
+	 * equal to the page size.
+	 */
+	start = iocb->ki_pos >> PAGE_SHIFT;
+	end = (iocb->ki_pos + iov_iter_count(from) - 1) >> PAGE_SHIFT;
+	if (invalidate_inode_pages2_range(inode->i_mapping, start, end))
+		return -EBUSY;
+
 	nr_pages = iov_iter_npages(from, BIO_MAX_VECS);
 	if (!nr_pages)
 		return 0;


