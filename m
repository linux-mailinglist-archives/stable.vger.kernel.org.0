Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5CB6EEC7D
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 04:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbjDZCqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 22:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239047AbjDZCqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 22:46:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A382189;
        Tue, 25 Apr 2023 19:46:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E81311FDC8;
        Wed, 26 Apr 2023 02:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1682477177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZDb8c1ysWVrh/rsgfacpRahhO5NYcumCJV3pM9PQ1BA=;
        b=tjWUeeZ61QsZL78GLSqsr8SJiO8aeIv9AiyZXRbSDMOYho1kugfKbv8mFu9LqIDlnwezzA
        WG6jCLWs5pbbm3vzd7Si94wrB8cQLIYJaIVCo2pvVwZjcCb4u1P3Tc2szpNapsicXMfd/J
        7PYkyvomvvLOrkND0+5EXhA1fNkGVC8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 10D99138F0;
        Wed, 26 Apr 2023 02:46:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yzb/MniQSGRZfQAAMHmgww
        (envelope-from <wqu@suse.com>); Wed, 26 Apr 2023 02:46:16 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: scrub: avoid crash if scrub is trying to do recovery for a removed block group
Date:   Wed, 26 Apr 2023 10:45:59 +0800
Message-Id: <45841a7e90525bf1efa2324ab9d80aeb9e20457c.1682477110.git.wqu@suse.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[BUG]
Syzbot reported an ASSERT() got triggered during a scrub repair along
with balance:

 BTRFS info (device loop5): balance: start -d -m
 BTRFS info (device loop5): relocating block group 6881280 flags data|metadata
 BTRFS info (device loop5): found 3 extents, stage: move data extents
 BTRFS info (device loop5): scrub: started on devid 1
 BTRFS info (device loop5): relocating block group 5242880 flags data|metadata
 BTRFS info (device loop5): found 6 extents, stage: move data extents
 BTRFS info (device loop5): found 1 extents, stage: update data pointers
 BTRFS warning (device loop5): tree block 5500928 mirror 1 has bad bytenr, has 0 want 5500928
 BTRFS info (device loop5): balance: ended with status: 0
 BTRFS warning (device loop5): tree block 5435392 mirror 1 has bad bytenr, has 0 want 5435392
 BTRFS warning (device loop5): tree block 5423104 mirror 1 has bad bytenr, has 0 want 5423104
 assertion failed: 0, in fs/btrfs/scrub.c:614
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/messages.c:259!
 invalid opcode: 0000 [#2] PREEMPT SMP KASAN
 Call Trace:
   <TASK>
   lock_full_stripe fs/btrfs/scrub.c:614 [inline]
   scrub_handle_errored_block+0x1ee1/0x4730 fs/btrfs/scrub.c:1067
   scrub_bio_end_io_worker+0x9bb/0x1370 fs/btrfs/scrub.c:2559
   process_one_work+0x8a0/0x10e0 kernel/workqueue.c:2390
   worker_thread+0xa63/0x1210 kernel/workqueue.c:2537
   kthread+0x270/0x300 kernel/kthread.c:376
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
   </TASK>

[CAUSE]
Btrfs can delete empty block groups either through auto-cleanup or
relcation.

Scrub normally is able to handle this situation well by doing extra
checking, and holding the block group cache pointer during the whole
scrub lifespan.

But unfortunately for lock_full_stripe() and unlock_full_stripe()
functions, due to the context restriction, they have to do an extra
search on the block group cache.
(While the main scrub threads holds a proper btrfs_block_group, but we
have no way to directly use that in repair context).

Thus it can happen that the target block group is already deleted by
relocation.

In that case, we trigger the above ASSERT().

[FIX]
Instead of triggering the ASSERT(), let's just return 0 and continue,
this would leave @locked_ret to be false, and we won't try to unlock
later.

CC: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
There would be no upstream commit, as upstream has completely rewritten
the scrub code in v6.4 merge window, and gets rid of the
lock_full_stripe()/unlock_full_stripe() functions.

I hope we don't have more scrub fixes which would only apply to older
kernels.
---
 fs/btrfs/scrub.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 69c93ae333f6..43d0613c0dd3 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -610,10 +610,9 @@ static int lock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr,
 
 	*locked_ret = false;
 	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
-	if (!bg_cache) {
-		ASSERT(0);
-		return -ENOENT;
-	}
+	/* The block group is removed, no need to do any lock. */
+	if (!bg_cache)
+		return 0;
 
 	/* Profiles not based on parity don't need full stripe lock */
 	if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_RAID56_MASK))
-- 
2.39.2

