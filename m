Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBC4616B0
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfGGTlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57666 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727620AbfGGTiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:13 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0006je-Lp; Sun, 07 Jul 2019 20:38:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005dd-Pr; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>,
        "Filipe Manana" <fdmanana@suse.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.18137553@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 091/129] Btrfs: fix corruption reading shared and
 compressed extents after hole punching
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 8e928218780e2f1cf2f5891c7575e8f0b284fcce upstream.

In the past we had data corruption when reading compressed extents that
are shared within the same file and they are consecutive, this got fixed
by commit 005efedf2c7d0 ("Btrfs: fix read corruption of compressed and
shared extents") and by commit 808f80b46790f ("Btrfs: update fix for read
corruption of compressed and shared extents"). However there was a case
that was missing in those fixes, which is when the shared and compressed
extents are referenced with a non-zero offset. The following shell script
creates a reproducer for this issue:

  #!/bin/bash

  mkfs.btrfs -f /dev/sdc &> /dev/null
  mount -o compress /dev/sdc /mnt/sdc

  # Create a file with 3 consecutive compressed extents, each has an
  # uncompressed size of 128Kb and a compressed size of 4Kb.
  for ((i = 1; i <= 3; i++)); do
      head -c 4096 /dev/zero
      for ((j = 1; j <= 31; j++)); do
          head -c 4096 /dev/zero | tr '\0' "\377"
      done
  done > /mnt/sdc/foobar
  sync

  echo "Digest after file creation:   $(md5sum /mnt/sdc/foobar)"

  # Clone the first extent into offsets 128K and 256K.
  xfs_io -c "reflink /mnt/sdc/foobar 0 128K 128K" /mnt/sdc/foobar
  xfs_io -c "reflink /mnt/sdc/foobar 0 256K 128K" /mnt/sdc/foobar
  sync

  echo "Digest after cloning:         $(md5sum /mnt/sdc/foobar)"

  # Punch holes into the regions that are already full of zeroes.
  xfs_io -c "fpunch 0 4K" /mnt/sdc/foobar
  xfs_io -c "fpunch 128K 4K" /mnt/sdc/foobar
  xfs_io -c "fpunch 256K 4K" /mnt/sdc/foobar
  sync

  echo "Digest after hole punching:   $(md5sum /mnt/sdc/foobar)"

  echo "Dropping page cache..."
  sysctl -q vm.drop_caches=1
  echo "Digest after hole punching:   $(md5sum /mnt/sdc/foobar)"

  umount /dev/sdc

When running the script we get the following output:

  Digest after file creation:   5a0888d80d7ab1fd31c229f83a3bbcc8  /mnt/sdc/foobar
  linked 131072/131072 bytes at offset 131072
  128 KiB, 1 ops; 0.0033 sec (36.960 MiB/sec and 295.6830 ops/sec)
  linked 131072/131072 bytes at offset 262144
  128 KiB, 1 ops; 0.0015 sec (78.567 MiB/sec and 628.5355 ops/sec)
  Digest after cloning:         5a0888d80d7ab1fd31c229f83a3bbcc8  /mnt/sdc/foobar
  Digest after hole punching:   5a0888d80d7ab1fd31c229f83a3bbcc8  /mnt/sdc/foobar
  Dropping page cache...
  Digest after hole punching:   fba694ae8664ed0c2e9ff8937e7f1484  /mnt/sdc/foobar

This happens because after reading all the pages of the extent in the
range from 128K to 256K for example, we read the hole at offset 256K
and then when reading the page at offset 260K we don't submit the
existing bio, which is responsible for filling all the page in the
range 128K to 256K only, therefore adding the pages from range 260K
to 384K to the existing bio and submitting it after iterating over the
entire range. Once the bio completes, the uncompressed data fills only
the pages in the range 128K to 256K because there's no more data read
from disk, leaving the pages in the range 260K to 384K unfilled. It is
just a slightly different variant of what was solved by commit
005efedf2c7d0 ("Btrfs: fix read corruption of compressed and shared
extents").

Fix this by forcing a bio submit, during readpages(), whenever we find a
compressed extent map for a page that is different from the extent map
for the previous page or has a different starting offset (in case it's
the same compressed extent), instead of the extent map's original start
offset.

A test case for fstests follows soon.

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Fixes: 808f80b46790f ("Btrfs: update fix for read corruption of compressed and shared extents")
Fixes: 005efedf2c7d0 ("Btrfs: fix read corruption of compressed and shared extents")
Tested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2936,11 +2936,11 @@ static int __do_readpage(struct extent_i
 		 */
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
 		    prev_em_start && *prev_em_start != (u64)-1 &&
-		    *prev_em_start != em->orig_start)
+		    *prev_em_start != em->start)
 			force_bio_submit = true;
 
 		if (prev_em_start)
-			*prev_em_start = em->orig_start;
+			*prev_em_start = em->start;
 
 		free_extent_map(em);
 		em = NULL;

