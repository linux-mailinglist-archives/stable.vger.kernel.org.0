Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7404FB380
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 08:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiDKGPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 02:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiDKGP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 02:15:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2927D38DBC;
        Sun, 10 Apr 2022 23:13:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D8663210EC;
        Mon, 11 Apr 2022 06:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649657594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ebQBHorBIYKzROYUR6QOYwNo+6S2wzo9cGhxjpRe03I=;
        b=TYQuQvZT0jxLI8Y24SDgaW5f23oq1q1BVz5DWYDpUWKQ3GdrXJKYHyNlRySez79LZwQmrW
        VF6nGGtenMbaIdjm8LYu9/EDrjotS8gfFW7AFtF1uSnPna1+nAZ5JDKHMzXb13PeRJqXQ8
        jTIYM5n02JtU23fhQ/7c7z2nwpgM5ls=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0563613AB5;
        Mon, 11 Apr 2022 06:13:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IKFeMPnGU2LEfwAAMHmgww
        (envelope-from <wqu@suse.com>); Mon, 11 Apr 2022 06:13:13 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 3/4] btrfs: return correct error number for __extent_writepage_io()
Date:   Mon, 11 Apr 2022 14:12:51 +0800
Message-Id: <1a271440a02c40b58d37391bd90ee92d72cfb1da.1649657016.git.wqu@suse.com>
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
If we hit an error from submit_extent_page() inside
__extent_writepage_io(), we could still return 0 to the caller, and
even trigger the warning in btrfs_page_assert_not_dirty().

[CAUSE]
In __extent_writepage_io(), if we hit an error from
submit_extent_page(), we will just clean up the range and continue.

This is completely fine for regular PAGE_SIZE == sectorsize, as we can
only hit one sector in one page, thus after the error we're ensured to
exit and @ret will be saved.

But for subpage case, we may have other dirty subpage range in the page,
and in the next loop, we may succeeded submitting the next range.

In that case, @ret will be overwritten, and we return 0 to the caller,
while we have hit some error.

[FIX]
Introduce @has_error and @saved_ret to record the first error we hit, so
we will never forget what error we hit.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8de25ce05606..b40bb544d301 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3916,10 +3916,12 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 	u64 extent_offset;
 	u64 block_start;
 	struct extent_map *em;
+	int saved_ret = 0;
 	int ret = 0;
 	int nr = 0;
 	u32 opf = REQ_OP_WRITE;
 	const unsigned int write_flags = wbc_to_write_flags(wbc);
+	bool has_error = false;
 	bool compressed;
 
 	ret = btrfs_writepage_cow_fixup(page);
@@ -3969,6 +3971,9 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 		if (IS_ERR(em)) {
 			btrfs_page_set_error(fs_info, page, cur, end - cur + 1);
 			ret = PTR_ERR_OR_ZERO(em);
+			has_error = true;
+			if (!saved_ret)
+				saved_ret = ret;
 			break;
 		}
 
@@ -4032,6 +4037,10 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 					 end_bio_extent_writepage,
 					 0, 0, false);
 		if (ret) {
+			has_error = true;
+			if (!saved_ret)
+				saved_ret = ret;
+
 			btrfs_page_set_error(fs_info, page, cur, iosize);
 			if (PageWriteback(page))
 				btrfs_page_clear_writeback(fs_info, page, cur,
@@ -4045,8 +4054,10 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 	 * If we finish without problem, we should not only clear page dirty,
 	 * but also empty subpage dirty bits
 	 */
-	if (!ret)
+	if (!has_error)
 		btrfs_page_assert_not_dirty(fs_info, page);
+	else
+		ret = saved_ret;
 	*nr_ret = nr;
 	return ret;
 }
-- 
2.35.1

