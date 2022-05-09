Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5937A51F913
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiEIJvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiEIJdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 05:33:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87059224689;
        Mon,  9 May 2022 02:29:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 45DA521BE5;
        Mon,  9 May 2022 09:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652088555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=4NaC4APu3jomNZ56jZVR+i41Tj+65Rc/PlF4mSlDL78=;
        b=GkolkL4jW2dm9+cnaMKFIAcNFHhc3iaJCSc+OMC9CibZu6fcnSIY7232fJJT8mOeQslLqr
        OUwo8zNm2KrikW8Q0AmoTABOuZNi+NAVQoJEZFO1kIizYCdf6mmCURNluGEIqTP6CcegOJ
        x7+NfKzVysuOdLkGb7ftVm9r7acr6lM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85DB813AA5;
        Mon,  9 May 2022 09:29:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LuSaFeneeGL2YAAAMHmgww
        (envelope-from <wqu@suse.com>); Mon, 09 May 2022 09:29:13 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH stable-5.15.y] btrfs: force v2 space cache usage for subpage mount
Date:   Mon,  9 May 2022 17:28:56 +0800
Message-Id: <edc6262ba229edce38a63b70960ffc170287ee11.1652088466.git.wqu@suse.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9f73f1aef98b2fa7252c0a89be64840271ce8ea0 upstream.

[BUG]
For a 4K sector sized btrfs with v1 cache enabled and only mounted on
systems with 4K page size, if it's mounted on subpage (64K page size)
systems, it can cause the following warning on v1 space cache:

 BTRFS error (device dm-1): csum mismatch on free space cache
 BTRFS warning (device dm-1): failed to load free space cache for block group 84082688, rebuilding it now

Although not a big deal, as kernel can rebuild it without problem, such
warning will bother end users, especially if they want to switch the
same btrfs seamlessly between different page sized systems.

[CAUSE]
V1 free space cache is still using fixed PAGE_SIZE for various bitmap,
like BITS_PER_BITMAP.

Such hard-coded PAGE_SIZE usage will cause various mismatch, from v1
cache size to checksum.

Thus kernel will always reject v1 cache with a different PAGE_SIZE with
csum mismatch.

[FIX]
Although we should fix v1 cache, it's already going to be marked
deprecated soon.

And we have v2 cache based on metadata (which is already fully subpage
compatible), and it has almost everything superior than v1 cache.

So just force subpage mount to use v2 cache on mount.

Reported-by: Matt Corallo <blnxfsl@bluematt.me>
CC: stable@vger.kernel.org # 5.15+
Link: https://lore.kernel.org/linux-btrfs/61aa27d1-30fc-c1a9-f0f4-9df544395ec3@bluematt.me/
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f1f7dbfa6ecd..8cbed2f08d1b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3415,6 +3415,17 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	}
 
 	if (sectorsize != PAGE_SIZE) {
+		/*
+		 * V1 space cache has some hardcoded PAGE_SIZE usage, and is
+		 * going to be deprecated.
+		 *
+		 * Force to use v2 cache for subpage case.
+		 */
+		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
+		btrfs_set_and_info(fs_info, FREE_SPACE_TREE,
+			"forcing free space tree for sector size %u with page size %lu",
+			sectorsize, PAGE_SIZE);
+
 		btrfs_warn(fs_info,
 		"read-write for sector size %u with page size %lu is experimental",
 			   sectorsize, PAGE_SIZE);
-- 
2.36.0

