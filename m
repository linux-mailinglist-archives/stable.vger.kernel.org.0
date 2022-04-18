Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293F7505249
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiDRMka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239738AbiDRMiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA09A23BE0;
        Mon, 18 Apr 2022 05:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7736160F7C;
        Mon, 18 Apr 2022 12:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70216C385A7;
        Mon, 18 Apr 2022 12:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284912;
        bh=a619yfC6AOd8vrd72rgdfYtRdrJf7N4gH9Ed6qYTT0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z87dHj7y+LRU8BLhfhKPFkr1qwSOpqzjxcaCfKLV+Tm3MvWjRgt5DkHvqRBumvnLY
         RhcyEAqAeQc1uzIh9RFqkxW/HnR3RbBLWvFV5S7r8rToIs0bmE7noi6DbQlZrJkCbI
         rKJuMJScWWMayaGfg4hR6TZ4vg2r2HX2vJ44E/xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 010/189] btrfs: remove no longer used counter when reading data page
Date:   Mon, 18 Apr 2022 14:10:30 +0200
Message-Id: <20220418121200.768642734@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
@@ -3561,7 +3561,6 @@ int btrfs_do_readpage(struct page *page,
 	u64 cur_end;
 	struct extent_map *em;
 	int ret = 0;
-	int nr = 0;
 	size_t pg_offset = 0;
 	size_t iosize;
 	size_t blocksize = inode->i_sb->s_blocksize;
@@ -3727,9 +3726,7 @@ int btrfs_do_readpage(struct page *page,
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


