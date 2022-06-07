Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20D25410FD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351290AbiFGTcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355158AbiFGT3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F90A1A4093;
        Tue,  7 Jun 2022 11:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E0361903;
        Tue,  7 Jun 2022 18:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAD5C385A2;
        Tue,  7 Jun 2022 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625505;
        bh=QYPPoscQqoIcHK0tg64TmPO1PWMhQP1qVM9aBWs4vtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgN8THwVZli45bA4eDcCYiKITT3TAEgKZzfUJbLQUhnzzZgV6BeNSAEjgBuNXDPYT
         Rs3I/yI5Or4qk2H5Vj8VYgqOBt3DDHhNMq4qqat/Wz3KLrGCCHNbLHltez0sd0x0Nq
         puaA9oJXmGszsxvyXCHDsoNChp0vgzhW5Zs00AGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 043/772] btrfs: return correct error number for __extent_writepage_io()
Date:   Tue,  7 Jun 2022 18:53:55 +0200
Message-Id: <20220607164950.297303459@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 44e5801fada6925d2bba1987c7b59cbcc9d0d592 upstream.

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
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3898,10 +3898,12 @@ static noinline_for_stack int __extent_w
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
@@ -3951,6 +3953,9 @@ static noinline_for_stack int __extent_w
 		if (IS_ERR_OR_NULL(em)) {
 			btrfs_page_set_error(fs_info, page, cur, end - cur + 1);
 			ret = PTR_ERR_OR_ZERO(em);
+			has_error = true;
+			if (!saved_ret)
+				saved_ret = ret;
 			break;
 		}
 
@@ -4014,6 +4019,10 @@ static noinline_for_stack int __extent_w
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
@@ -4027,8 +4036,10 @@ static noinline_for_stack int __extent_w
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


