Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980A94FB37C
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 08:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiDKGP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 02:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiDKGP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 02:15:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A336F38DBE;
        Sun, 10 Apr 2022 23:13:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5B073210EC;
        Mon, 11 Apr 2022 06:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649657592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVHMNwREUmgpNU3ILszNiSRyo9cYwG0tgzjgpZMwvW0=;
        b=T3RTnqxgLFAAFf2gKsez7A3MbTyN7l2SVGeB+N67Zg2IcqzXAvuskrd+5bzNLEC4tmaDJA
        ItwUr8j05GbSpLCu468nqjj09d1vVp7Vpy/eISq3mXKgFw16TF3oHIz/i0HNl+qa1XZwu+
        UxayycHU+u7MfIldinh/iQN+4Qp3nq0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 131B213AB5;
        Mon, 11 Apr 2022 06:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2F3rM/bGU2LEfwAAMHmgww
        (envelope-from <wqu@suse.com>); Mon, 11 Apr 2022 06:13:10 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/4] btrfs: avoid double clean up when submit_one_bio() failed
Date:   Mon, 11 Apr 2022 14:12:49 +0800
Message-Id: <6b8983dd0a3a28155fa7d786bae0a8bf932cdbab.1649657016.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649657016.git.wqu@suse.com>
References: <cover.1649657016.git.wqu@suse.com>
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

[BUG]
When running generic/475 with 64K page size and 4K sector size, it has a
very high chance (almost 100%) to hang, with mostly data page locked but
no one is going to unlock it.

[CAUSE]
With commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
reads"), if we failed to lookup checksum due to metadata IO error, we
will return error for btrfs_submit_data_bio().

This will cause the page to be unlocked twice in btrfs_do_readpage():

 btrfs_do_readpage()
 |- submit_extent_page()
 |  |- submit_one_bio()
 |     |- btrfs_submit_data_bio()
 |        |- if (ret) {
 |        |-     bio->bi_status = ret;
 |        |-     bio_endio(bio); }
 |               In the endio function, we will call end_page_read()
 |               and unlock_extent() to cleanup the subpage range.
 |
 |- if (ret) {
 |-        unlock_extent(); end_page_read() }
           Here we unlock the extent and cleanup the subpage range
           again.

For unlock_extent(), it's mostly double unlock safe.

But for end_page_read(), it's not, especially for subpage case,
as for subpage case we will call btrfs_subpage_end_reader() to reduce
the reader number, and use that to number to determine if we need to
unlock the full page.

If double accounted, it can underflow the number and leave the page
locked without anyone to unlock it.

[FIX]
The commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
reads") itself is completely fine, it's our existing code not properly
handling the error from bio submission hook properly.

Since one and only one of the endio function or the submit_extent_page()
caller should do the cleanup, let's just ignore the return value from
bio submission hook.

Before the hook, it's callers' responsibility to do cleanup, after the
hook (including inside the hook), it's the endio doing the cleanup.

This patch is makes submit_one_bio() always return 0, but still keep the
old int return value to make minimal change for backport.

CC: stable@vger.kernel.org # 5.18+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 53b59944013f..34073b0ed6ca 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -165,24 +165,28 @@ static int add_extent_changeset(struct extent_state *state, u32 bits,
 	return ret;
 }
 
-int __must_check submit_one_bio(struct bio *bio, int mirror_num,
-				unsigned long bio_flags)
+int submit_one_bio(struct bio *bio, int mirror_num, unsigned long bio_flags)
 {
-	blk_status_t ret = 0;
 	struct extent_io_tree *tree = bio->bi_private;
 
 	bio->bi_private = NULL;
 
 	/* Caller should ensure the bio has at least some range added */
 	ASSERT(bio->bi_iter.bi_size);
+
 	if (is_data_inode(tree->private_data))
-		ret = btrfs_submit_data_bio(tree->private_data, bio, mirror_num,
+		btrfs_submit_data_bio(tree->private_data, bio, mirror_num,
 					    bio_flags);
 	else
-		ret = btrfs_submit_metadata_bio(tree->private_data, bio,
+		btrfs_submit_metadata_bio(tree->private_data, bio,
 						mirror_num, bio_flags);
-
-	return blk_status_to_errno(ret);
+	/*
+	 * Above submission hooks will handle the error by ending the bio,
+	 * which will do the cleanup properly.
+	 * So here we should not return any error, or the caller of
+	 * submit_extent_page() will do cleanup again, causing problems.
+	 */
+	return 0;
 }
 
 /* Cleanup unsubmitted bios */
-- 
2.35.1

