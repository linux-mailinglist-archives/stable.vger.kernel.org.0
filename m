Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BF6201506
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390913AbgFSQRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390902AbgFSPCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB2120776;
        Fri, 19 Jun 2020 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578972;
        bh=dFj03ieTKPIxULsHQ9pqrB5XgXCDpm1ISDBdSJI9s9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R722oo/Y8mAvhHm0JYEgDwk1Ai3s7PgDii9qGgGbRD2jV/JbvdMpElrxTm4QYgzBs
         4Ywakbe3q8uKxPmNyDiw9COYzopX1kw+iB9J2jCa5Sxdasp5EpwiY58jeu/4yewQdR
         blTDXe5g+SyKvAG9lExBaRcNtTdmkVmGgqHOP42c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 228/267] btrfs: fix error handling when submitting direct I/O bio
Date:   Fri, 19 Jun 2020 16:33:33 +0200
Message-Id: <20200619141659.635299828@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 6d3113a193e3385c72240096fe397618ecab6e43 ]

In btrfs_submit_direct_hook(), if a direct I/O write doesn't span a RAID
stripe or chunk, we submit orig_bio without cloning it. In this case, we
don't increment pending_bios. Then, if btrfs_submit_dio_bio() fails, we
decrement pending_bios to -1, and we never complete orig_bio. Fix it by
initializing pending_bios to 1 instead of incrementing later.

Fixing this exposes another bug: we put orig_bio prematurely and then
put it again from end_io. Fix it by not putting orig_bio.

After this change, pending_bios is really more of a reference count, but
I'll leave that cleanup separate to keep the fix small.

Fixes: e65e15355429 ("btrfs: fix panic caused by direct IO")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c69e5b255745..b4f295a058d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8399,7 +8399,6 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 
 	/* bio split */
 	ASSERT(map_length <= INT_MAX);
-	atomic_inc(&dip->pending_bios);
 	do {
 		clone_len = min_t(int, submit_len, map_length);
 
@@ -8450,7 +8449,8 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 	if (!status)
 		return 0;
 
-	bio_put(bio);
+	if (bio != orig_bio)
+		bio_put(bio);
 out_err:
 	dip->errors = 1;
 	/*
@@ -8491,7 +8491,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	bio->bi_private = dip;
 	dip->orig_bio = bio;
 	dip->dio_bio = dio_bio;
-	atomic_set(&dip->pending_bios, 0);
+	atomic_set(&dip->pending_bios, 1);
 	io_bio = btrfs_io_bio(bio);
 	io_bio->logical = file_offset;
 
-- 
2.25.1



