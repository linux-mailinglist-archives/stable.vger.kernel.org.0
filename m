Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD60B24F8DF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgHXIrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgHXIrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE892206F0;
        Mon, 24 Aug 2020 08:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258840;
        bh=I+DwZD56sM3C9rG0X7y50N5FiUYdZB+t0XR4CbQVVzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCeDtFN/xW/h8wFBVuabo1g0RqIFLd/uWSqichYKo0q8NSVfEtkjzeoTU9BYb6PTp
         OhSCTlFQr689Bm3zvQwu55XxaqLhMhQNvqxWhhBd04gjUE1G1iXWZF82ewupNSxc6d
         vA7O3rY2ILtuPvNMbvsrQvmUO24xdKsizNrfojpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/107] ext4: fix potential negative array index in do_split()
Date:   Mon, 24 Aug 2020 10:30:29 +0200
Message-Id: <20200824082408.247538124@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 5872331b3d91820e14716632ebb56b1399b34fe1 ]

If for any reason a directory passed to do_split() does not have enough
active entries to exceed half the size of the block, we can end up
iterating over all "count" entries without finding a split point.

In this case, count == move, and split will be zero, and we will
attempt a negative index into map[].

Guard against this by detecting this case, and falling back to
split-to-half-of-count instead; in this case we will still have
plenty of space (> half blocksize) in each split block.

Fixes: ef2b02d3e617 ("ext34: ensure do_split leaves enough free space in both blocks")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/f53e246b-647c-64bb-16ec-135383c70ad7@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0218b1407abbb..36a81b57012a5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1852,7 +1852,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			     blocksize, hinfo, map);
 	map -= count;
 	dx_sort_map(map, count);
-	/* Split the existing block in the middle, size-wise */
+	/* Ensure that neither split block is over half full */
 	size = 0;
 	move = 0;
 	for (i = count-1; i >= 0; i--) {
@@ -1862,8 +1862,18 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		size += map[i].size;
 		move++;
 	}
-	/* map index at which we will split */
-	split = count - move;
+	/*
+	 * map index at which we will split
+	 *
+	 * If the sum of active entries didn't exceed half the block size, just
+	 * split it in half by count; each resulting block will have at least
+	 * half the space free.
+	 */
+	if (i > 0)
+		split = count - move;
+	else
+		split = count/2;
+
 	hash2 = map[split].hash;
 	continued = hash2 == map[split - 1].hash;
 	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
-- 
2.25.1



