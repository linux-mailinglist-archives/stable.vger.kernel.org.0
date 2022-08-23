Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CCD59D9E9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351916AbiHWKDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352401AbiHWKBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F3182FB9;
        Tue, 23 Aug 2022 01:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0158EB81BF8;
        Tue, 23 Aug 2022 08:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CD2C433C1;
        Tue, 23 Aug 2022 08:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244568;
        bh=CVSo7CjZGkrDLL6BVK+W8HD7/XYyGy3iyIB5aosrHrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKrSMzYZWVRAnqLrREASiOHOz5WqPMCaJf0KOL+Kpl065iLSYM69/nNzr9/SP33ls
         J08uc4TnC8zmmcjW5Rc0wHnYQ831+9YljU6eFGqtykUMpmftYTlV35I9yQWsaqtln7
         AQ4AZcZlvI44nsd0bNccMzZhiZddJo97KxkZrUJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 156/229] ext4: fix extent status tree race in writeback error recovery path
Date:   Tue, 23 Aug 2022 10:25:17 +0200
Message-Id: <20220823080059.248175868@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

commit 7f0d8e1d607c1a4fa9a27362a108921d82230874 upstream.

A race can occur in the unlikely event ext4 is unable to allocate a
physical cluster for a delayed allocation in a bigalloc file system
during writeback.  Failure to allocate a cluster forces error recovery
that includes a call to mpage_release_unused_pages().  That function
removes any corresponding delayed allocated blocks from the extent
status tree.  If a new delayed write is in progress on the same cluster
simultaneously, resulting in the addition of an new extent containing
one or more blocks in that cluster to the extent status tree, delayed
block accounting can be thrown off if that delayed write then encounters
a similar cluster allocation failure during future writeback.

Write lock the i_data_sem in mpage_release_unused_pages() to fix this
problem.  Ext4's block/cluster accounting code for bigalloc relies on
i_data_sem for mutual exclusion, as is found in the delayed write path,
and the locking in mpage_release_unused_pages() is missing.

Cc: stable@kernel.org
Reported-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20220615160530.1928801-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1754,7 +1754,14 @@ static void mpage_release_unused_pages(s
 		ext4_lblk_t start, last;
 		start = index << (PAGE_SHIFT - inode->i_blkbits);
 		last = end << (PAGE_SHIFT - inode->i_blkbits);
+
+		/*
+		 * avoid racing with extent status tree scans made by
+		 * ext4_insert_delayed_block()
+		 */
+		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_es_remove_extent(inode, start, last - start + 1);
+		up_write(&EXT4_I(inode)->i_data_sem);
 	}
 
 	pagevec_init(&pvec, 0);


