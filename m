Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A2A5051F9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiDRMkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239492AbiDRMhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0F7222B4;
        Mon, 18 Apr 2022 05:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C94160F09;
        Mon, 18 Apr 2022 12:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480C3C385A7;
        Mon, 18 Apr 2022 12:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284877;
        bh=vlaw6vwwaPe+wJ4yYOqIhyCmsIl8eTc+i2THFYJ9aBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azkIr0Wbx6xxEGG7kpYfj0gvDNsWFb0UM1LbIzmhBLK7RXn6rkPow7BX3qebFuFfF
         2WgyLb5DfTjXYUL6Zr+NkHQ3EEwy/Yh0Nz1etslvh/N4inLOENotOXCwZzf4/TfjE3
         WKaKdk0/srIFoNvjpZvrQ85pjVWTIy20xxRdS3Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 009/189] btrfs: remove unused parameter nr_pages in add_ra_bio_pages()
Date:   Mon, 18 Apr 2022 14:10:29 +0200
Message-Id: <20220418121200.727778911@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit cd9255be6980012ad54f2d4fd3941bc2586e43e5 upstream.

Variable @nr_pages only gets increased but never used.  Remove it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -550,7 +550,6 @@ static noinline int add_ra_bio_pages(str
 	u64 isize = i_size_read(inode);
 	int ret;
 	struct page *page;
-	unsigned long nr_pages = 0;
 	struct extent_map *em;
 	struct address_space *mapping = inode->i_mapping;
 	struct extent_map_tree *em_tree;
@@ -646,7 +645,6 @@ static noinline int add_ra_bio_pages(str
 				   PAGE_SIZE, 0);
 
 		if (ret == PAGE_SIZE) {
-			nr_pages++;
 			put_page(page);
 		} else {
 			unlock_extent(tree, last_offset, end);


