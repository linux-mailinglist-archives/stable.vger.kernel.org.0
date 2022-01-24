Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D16499231
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350996AbiAXUSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379907AbiAXUPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:15:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FADFC09B06E;
        Mon, 24 Jan 2022 11:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2645B81215;
        Mon, 24 Jan 2022 19:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5F7C340E5;
        Mon, 24 Jan 2022 19:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053076;
        bh=nl0Je5jDJ38BoGxWoqFJB3ZeEVEu2hoWQfk3tXR6mkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoowTyG9K7GrXTyDbP529+eEAnOscgRwk9CY4oKxSRx4SoaBlrBXzgW93q8+F8uej
         P2tLBYBDIJRImWEOd/3dX/3tLr1Y74wIBMz1+cmE0QWlI3E4bgb9Kg4VhckRqgO+Yj
         fHb6MDABNYRwEo77/AILTpiIquLRtbuB5Z2EwJ/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 267/320] btrfs: respect the max size in the header when activating swap file
Date:   Mon, 24 Jan 2022 19:44:11 +0100
Message-Id: <20220124184003.059308977@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -10808,9 +10808,19 @@ static int btrfs_add_swap_extent(struct
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
@@ -10818,6 +10828,7 @@ static int btrfs_add_swap_extent(struct
 	if (first_ppage >= next_ppage)
 		return 0;
 	nr_pages = next_ppage - first_ppage;
+	nr_pages = min(nr_pages, max_pages);
 
 	first_ppage_reported = first_ppage;
 	if (bsi->start == 0)


