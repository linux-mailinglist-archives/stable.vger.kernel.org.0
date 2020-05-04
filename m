Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4F11C447F
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbgEDSHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732192AbgEDSHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C3A20721;
        Mon,  4 May 2020 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615668;
        bh=5Hg05jQx9fKm4esxgnrhIs8kDmBvvcdpoQ+ZqfQAQVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSmmExwGUz9Dm8TBiDGJBKr0K5uTRc8axRDLqAYmYhUe1GHKJeEBfg2MTTrd7J+nx
         x3iP1eBCumZlT5hTGiappfxrVyFfYlTov3zPdlbDfAnXB3SR+9X4aVt4vAE064Dym9
         QAM2SpBzRVVOn993nBH4XqW3I9DqQ6bDUi32r4qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 40/73] block: remove the bd_openers checks in blk_drop_partitions
Date:   Mon,  4 May 2020 19:57:43 +0200
Message-Id: <20200504165508.013010361@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 10c70d95c0f2f9a6f52d0e33243d2877370cef51 upstream.

When replacing the bd_super check with a bd_openers I followed a logical
conclusion, which turns out to be utterly wrong.  When a block device has
bd_super sets it has a mount file system on it (although not every
mounted file system sets bd_super), but that also implies it doesn't even
have partitions to start with.

So instead of trying to come up with a logical check for all openers,
just remove the check entirely.

Fixes: d3ef5536274f ("block: fix busy device checking in blk_drop_partitions")
Fixes: cb6b771b05c3 ("block: fix busy device checking in blk_drop_partitions again")
Reported-by: Michal Koutný <mkoutny@suse.com>
Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/partition-generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -468,7 +468,7 @@ int blk_drop_partitions(struct gendisk *
 
 	if (!disk_part_scan_enabled(disk))
 		return 0;
-	if (bdev->bd_part_count || bdev->bd_openers > 1)
+	if (bdev->bd_part_count)
 		return -EBUSY;
 	res = invalidate_partition(disk, 0);
 	if (res)


