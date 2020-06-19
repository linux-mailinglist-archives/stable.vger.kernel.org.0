Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D232018A6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395513AbgFSQuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbgFSOib (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:38:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2899120DD4;
        Fri, 19 Jun 2020 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577510;
        bh=6UcsDGqhZhBV6wGC3oJUGPdAQNjIkMJhcD/PIC8nYb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGjvu5HUhO1xxM7POKqfs/L7Ie1aC4NpNgEn3etsYH9vqHzIVrS9Hrzuc0BUf26fh
         HkBaEQj/Y1IQB+45uEqL4eME3T6IQzoroYui253+ITwFVzcgRoJ4HBKm+/eKZ8aq0m
         CmIstJSvCqJ3gkNBnY69squw9N/ZRkh8YG20TmGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 080/101] btrfs: fix error handling when submitting direct I/O bio
Date:   Fri, 19 Jun 2020 16:33:09 +0200
Message-Id: <20200619141618.179542740@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
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
index 548e9cd1a337..972475eeb2dd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8294,7 +8294,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	bio->bi_private = dip;
 	bio->bi_end_io = btrfs_end_dio_bio;
 	btrfs_io_bio(bio)->logical = file_offset;
-	atomic_inc(&dip->pending_bios);
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
 		if (map_length < submit_len + bvec->bv_len ||
@@ -8351,7 +8350,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	if (!ret)
 		return 0;
 
-	bio_put(bio);
+	if (bio != orig_bio)
+		bio_put(bio);
 out_err:
 	dip->errors = 1;
 	/*
@@ -8398,7 +8398,7 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 	io_bio->bi_private = dip;
 	dip->orig_bio = io_bio;
 	dip->dio_bio = dio_bio;
-	atomic_set(&dip->pending_bios, 0);
+	atomic_set(&dip->pending_bios, 1);
 	btrfs_bio = btrfs_io_bio(io_bio);
 	btrfs_bio->logical = file_offset;
 
-- 
2.25.1



