Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F9F49A592
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371025AbiAYAGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360363AbiAXXgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:36:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E69EC05A180;
        Mon, 24 Jan 2022 13:37:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28636150D;
        Mon, 24 Jan 2022 21:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DFAC340E4;
        Mon, 24 Jan 2022 21:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060253;
        bh=cLHPf/JCXUTYGxqtShabK2y0tmu9p4jwP5/5jvaPxHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvajUePxWQrNOWB2mN6TaXXNGtyYKCltkRYk3ATrVnHziaCKU/JtJfU5DsPJ1zyEY
         P89fh2LmuOcs7YNHxycVtlJW5+AQ1aUm5tNKZzQTwW75AyuVlHWgPoiE3+kKJOjHfp
         GXUhYPjLWv9FXKoiStpukBIzzr6+uQA53Kd+eEDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 0888/1039] btrfs: respect the max size in the header when activating swap file
Date:   Mon, 24 Jan 2022 19:44:37 +0100
Message-Id: <20220124184155.141168606@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit c2f822635df873c510bda6fb7fd1b10b7c31be2d upstream.

If we extended the size of a swapfile after its header was created (by the
mkswap utility) and then try to activate it, we will map the entire file
when activating the swap file, instead of limiting to the max size defined
in the swap file's header.

Currently test case generic/643 from fstests fails because we do not
respect that size limit defined in the swap file's header.

So fix this by not mapping file ranges beyond the max size defined in the
swap header.

This is the same type of bug that iomap used to have, and was fixed in
commit 36ca7943ac18ae ("mm/swap: consider max pages in
iomap_swapfile_add_extent").

Fixes: ed46ff3d423780 ("Btrfs: support swap files")
CC: stable@vger.kernel.org # 5.4+
Reviewed-and-tested-by: Josef Bacik <josef@toxicpanda.com
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10595,9 +10595,19 @@ static int btrfs_add_swap_extent(struct
 				 struct btrfs_swap_info *bsi)
 {
 	unsigned long nr_pages;
+	unsigned long max_pages;
 	u64 first_ppage, first_ppage_reported, next_ppage;
 	int ret;
 
+	/*
+	 * Our swapfile may have had its size extended after the swap header was
+	 * written. In that case activating the swapfile should not go beyond
+	 * the max size set in the swap header.
+	 */
+	if (bsi->nr_pages >= sis->max)
+		return 0;
+
+	max_pages = sis->max - bsi->nr_pages;
 	first_ppage = ALIGN(bsi->block_start, PAGE_SIZE) >> PAGE_SHIFT;
 	next_ppage = ALIGN_DOWN(bsi->block_start + bsi->block_len,
 				PAGE_SIZE) >> PAGE_SHIFT;
@@ -10605,6 +10615,7 @@ static int btrfs_add_swap_extent(struct
 	if (first_ppage >= next_ppage)
 		return 0;
 	nr_pages = next_ppage - first_ppage;
+	nr_pages = min(nr_pages, max_pages);
 
 	first_ppage_reported = first_ppage;
 	if (bsi->start == 0)


