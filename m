Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF935CD7EF
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfJFRzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbfJFRy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:54:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C842077B;
        Sun,  6 Oct 2019 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383965;
        bh=BH/a5c+bXXYLg/uA0RRJfRa6LSxsadgUgOffxgQNYPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQfLimJ5aC0pLiFBUaKmxAkvQO0ShxEPSEBJIfEqOPmWypLb/uqXvAf+Jh+zA0DCW
         Oh6mGxwZRSSlV4mYEAWoxoWUCWYBQ2u9ZEPGkM8COwhhUyJA3nzDKPtmVUQY6SO4cz
         7v53pdX67adRTVueXiiWvfA00Hf8QELHZdQVeLq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.3 160/166] dm raid: fix updating of max_discard_sectors limit
Date:   Sun,  6 Oct 2019 19:22:06 +0200
Message-Id: <20191006171226.329297991@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit c8156fc77d0796ba2618936dbb3084e769e916c1 upstream.

Unit of 'chunk_size' is byte, instead of sector, so fix it by setting
the queue_limits' max_discard_sectors to rs->md.chunk_sectors.  Also,
rename chunk_size to chunk_size_bytes.

Without this fix, too big max_discard_sectors is applied on the request
queue of dm-raid, finally raid code has to split the bio again.

This re-split done by raid causes the following nested clone_endio:

1) one big bio 'A' is submitted to dm queue, and served as the original
bio

2) one new bio 'B' is cloned from the original bio 'A', and .map()
is run on this bio of 'B', and B's original bio points to 'A'

3) raid code sees that 'B' is too big, and split 'B' and re-submit
the remainded part of 'B' to dm-raid queue via generic_make_request().

4) now dm will handle 'B' as new original bio, then allocate a new
clone bio of 'C' and run .map() on 'C'. Meantime C's original bio
points to 'B'.

5) suppose now 'C' is completed by raid directly, then the following
clone_endio() is called recursively:

	clone_endio(C)
		->clone_endio(B)		#B is original bio of 'C'
			->bio_endio(A)

'A' can be big enough to make hundreds of nested clone_endio(), then
stack can be corrupted easily.

Fixes: 61697a6abd24a ("dm: eliminate 'split_discard_bios' flag from DM target interface")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-raid.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3738,18 +3738,18 @@ static int raid_iterate_devices(struct d
 static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct raid_set *rs = ti->private;
-	unsigned int chunk_size = to_bytes(rs->md.chunk_sectors);
+	unsigned int chunk_size_bytes = to_bytes(rs->md.chunk_sectors);
 
-	blk_limits_io_min(limits, chunk_size);
-	blk_limits_io_opt(limits, chunk_size * mddev_data_stripes(rs));
+	blk_limits_io_min(limits, chunk_size_bytes);
+	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 
 	/*
 	 * RAID1 and RAID10 personalities require bio splitting,
 	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
 	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
-		limits->discard_granularity = chunk_size;
-		limits->max_discard_sectors = chunk_size;
+		limits->discard_granularity = chunk_size_bytes;
+		limits->max_discard_sectors = rs->md.chunk_sectors;
 	}
 }
 


