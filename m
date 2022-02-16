Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010F34B8118
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiBPHLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:11:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiBPHLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:11:50 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ADE237ED;
        Tue, 15 Feb 2022 23:11:24 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D873A21634;
        Wed, 16 Feb 2022 07:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644995369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTF9B+oeWv/VkAEsIm+86HkK8abmiUsAQIAm6KFDlAY=;
        b=oxNlVvXjvZ6Q47s1mALU6beQjKskfXHS0MOb7AZUg4AXye1pEN9mXgcO8337aUG2b5FYVo
        b2v2avKkRaplWtdO3+2t9iU3+H/CdZMvRbxA6oXGkhwMFXO80fhhpqrc+Bw83XOAErDOOm
        wa9j+h9AKqo+J+yrHyR2/KhoRNFb5vQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 05FF813A3A;
        Wed, 16 Feb 2022 07:09:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WE6NMCijDGJ1LgAAMHmgww
        (envelope-from <wqu@suse.com>); Wed, 16 Feb 2022 07:09:28 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH for v5.15 2/2] btrfs: defrag: use the same cluster size for defrag ioctl and autodefrag
Date:   Wed, 16 Feb 2022 15:09:08 +0800
Message-Id: <d2ce0079f3d2144876f019575858b392263089c4.1644994950.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1644994950.git.wqu@suse.com>
References: <cover.1644994950.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No upstream commit.
Since the bug only exists between v5.11 and v5.15. In v5.16 btrfs
reworked defrag and no longer has this bug.

[BUG]
Since commit 7f458a3873ae ("btrfs: fix race when defragmenting leads to
unnecessary IO") autodefrag no longer works with the following script:

 mkfs.btrfs -f $dev
 mount $dev $mnt -o datacow,autodefrag

 # Create a layout where we have fragmented extents at [0, 64k) (sync write in
 # reserve order), then a hole at [64k, 128k)
 xfs_io -f -s -c "pwrite 48k 16k" -c "pwrite 32k 16k" \
                -c "pwrite 16k 16k" -c "pwrite 0 16k" \
                $mnt/foobar
 truncate -s 128k $mnt/foobar

 echo "=== File extent layout before autodefrag ==="
 xfs_io -c "fiemap -v" "$mnt/foobar"

 # Now trigger autodefrag, autodefrag is triggered in the cleaner thread,
 # which will be woken up by commit thread
 mount -o remount,commit=1 $mnt
 sleep 3
 sync

 echo "=== File extent layout after autodefrag ==="
 xfs_io -c "fiemap -v" "$mnt/foobar"

The file "foobar" will not be autodefraged even it should.

[CAUSE]
Commit 7f458a3873ae ("btrfs: fix race when defragmenting leads to
unnecessary IO") fixes the race by rejecting the cluster if there is any
hole in the cluster.

But unlike regular defrag ioctl, autodefrag ignores the @defrag_end
parameter, and always uses a fixed cluster size 256K.
While defrag ioctl uses @defrag_end to skip existing holes.

This hidden autodefrag only behavior prevents autodefrag from working in
above script.

[FIX]
Remove the special cluster size, and unify the behavior for both
autodefrag and defrag ioctl.

This fix is only needed for v5.15 (and maybe v5.10) stable branch, as in
v5.16 the whole defrag get reworked in btrfs, which at least solves this
particular bug. (although introduced quite some other regressions)

CC: stable@vger.kernel.org # 5.15
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 38a1b68c7851..61f6e77698a2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1521,13 +1521,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			continue;
 		}
 
-		if (!newer_than) {
-			cluster = (PAGE_ALIGN(defrag_end) >>
-				   PAGE_SHIFT) - i;
-			cluster = min(cluster, max_cluster);
-		} else {
-			cluster = max_cluster;
-		}
+		cluster = (PAGE_ALIGN(defrag_end) >> PAGE_SHIFT) - i;
+		cluster = min(cluster, max_cluster);
 
 		if (i + cluster > ra_index) {
 			ra_index = max(i, ra_index);
-- 
2.35.1

