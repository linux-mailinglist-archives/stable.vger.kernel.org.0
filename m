Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8905C504FDA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiDRMSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbiDRMSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7711AD8F;
        Mon, 18 Apr 2022 05:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FEDAB80EC1;
        Mon, 18 Apr 2022 12:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFDC385A7;
        Mon, 18 Apr 2022 12:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284129;
        bh=oZO3stjKYcljS7kV1OFx+BRQu6rlTDBzubSb1E/srEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PHbT08xm8EFuzvJHWiwJ9AOnQkpdnGMsvuWQPp8bLhaPAJGqk/9SkNKp9bpOYild
         A0HNnY38EOzVT1ouuKh0A1GvUu8kRR6OYjFCletRXcpp8xvnomWNV+k1modqWG9anq
         w6ztEFynv+bd9soua5Pcao3SZXVvEZIi3RN094/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.17 008/219] btrfs: remove no longer used counter when reading data page
Date:   Mon, 18 Apr 2022 14:09:37 +0200
Message-Id: <20220418121203.710096473@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit ad3fc7946b1829213bbdbb2b9ad0d124b31ae4a7 upstream.

After commit 92082d40976ed0 ("btrfs: integrate page status update for
data read path into begin/end_page_read"), the 'nr' counter at
btrfs_do_readpage() is no longer used, we increment it but we never
read from it. So just remove it.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3562,7 +3562,6 @@ int btrfs_do_readpage(struct page *page,
 	u64 cur_end;
 	struct extent_map *em;
 	int ret = 0;
-	int nr = 0;
 	size_t pg_offset = 0;
 	size_t iosize;
 	size_t blocksize = inode->i_sb->s_blocksize;
@@ -3720,9 +3719,7 @@ int btrfs_do_readpage(struct page *page,
 					 end_bio_extent_readpage, 0,
 					 this_bio_flag,
 					 force_bio_submit);
-		if (!ret) {
-			nr++;
-		} else {
+		if (ret) {
 			unlock_extent(tree, cur, cur + iosize - 1);
 			end_page_read(page, false, cur, iosize);
 			goto out;


