Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62407103F30
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbfKTPls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:41:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53006 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731839AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5X-0004dA-MC; Wed, 20 Nov 2019 15:40:15 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004PF-PI; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Hans van Kranenburg" <hans.van.kranenburg@mendix.com>
Date:   Wed, 20 Nov 2019 15:38:33 +0000
Message-ID: <lsq.1574264230.97743088@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 83/83] btrfs: alloc_chunk: fix more DUP stripe size
 handling
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

commit baf92114c7e6dd6124aa3d506e4bc4b694da3bc3 upstream.

Commit 92e222df7b "btrfs: alloc_chunk: fix DUP stripe size handling"
fixed calculating the stripe_size for a new DUP chunk.

However, the same calculation reappears a bit later, and that one was
not changed yet. The resulting bug that is exposed is that the newly
allocated device extents ('stripes') can have a few MiB overlap with the
next thing stored after them, which is another device extent or the end
of the disk.

The scenario in which this can happen is:
* The block device for the filesystem is less than 10GiB in size.
* The amount of contiguous free unallocated disk space chosen to use for
  chunk allocation is 20% of the total device size, or a few MiB more or
  less.

An example:
- The filesystem device is 7880MiB (max_chunk_size gets set to 788MiB)
- There's 1578MiB unallocated raw disk space left in one contiguous
  piece.

In this case stripe_size is first calculated as 789MiB, (half of
1578MiB).

Since 789MiB (stripe_size * data_stripes) > 788MiB (max_chunk_size), we
enter the if block. Now stripe_size value is immediately overwritten
while calculating an adjusted value based on max_chunk_size, which ends
up as 788MiB.

Next, the value is rounded up to a 16MiB boundary, 800MiB, which is
actually more than the value we had before. However, the last comparison
fails to detect this, because it's comparing the value with the total
amount of free space, which is about twice the size of stripe_size.

In the example above, this means that the resulting raw disk space being
allocated is 1600MiB, while only a gap of 1578MiB has been found. The
second device extent object for this DUP chunk will overlap for 22MiB
with whatever comes next.

The underlying problem here is that the stripe_size is reused all the
time for different things. So, when entering the code in the if block,
stripe_size is immediately overwritten with something else. If later we
decide we want to have the previous value back, then the logic to
compute it was copy pasted in again.

With this change, the value in stripe_size is not unnecessarily
destroyed, so the duplicated calculation is not needed any more.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4271,19 +4271,17 @@ static int __btrfs_alloc_chunk(struct bt
 	/*
 	 * Use the number of data stripes to figure out how big this chunk
 	 * is really going to be in terms of logical address space,
-	 * and compare that answer with the max chunk size
+	 * and compare that answer with the max chunk size. If it's higher,
+	 * we try to reduce stripe_size.
 	 */
 	if (stripe_size * data_stripes > max_chunk_size) {
-		stripe_size = div_u64(max_chunk_size, data_stripes);
-
-		/* bump the answer up to a 16MB boundary */
-		stripe_size = round_up(stripe_size, SZ_16M);
-
 		/*
-		 * But don't go higher than the limits we found while searching
-		 * for free extents
+		 * Reduce stripe_size, round it up to a 16MB boundary again and
+		 * then use it, unless it ends up being even bigger than the
+		 * previous value we had already.
 		 */
-		stripe_size = min(devices_info[ndevs - 1].max_avail,
+		stripe_size = min(round_up(div_u64(max_chunk_size,
+						   data_stripes), SZ_16M),
 				  stripe_size);
 	}
 

