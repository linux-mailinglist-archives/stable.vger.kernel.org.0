Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E50594993
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbiHOXcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353433AbiHOXbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919F214F97C;
        Mon, 15 Aug 2022 13:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CB0160B6E;
        Mon, 15 Aug 2022 20:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F19C433C1;
        Mon, 15 Aug 2022 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594093;
        bh=qbzUrqN7cH0JP7uC2Tl4OalEZ7Wbjp6GiUMN+PORSdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGJsLcPEu4VGkYlSlCo2vlCPEIdfOsRSexEd8ljeM3DkD6YNUa7zqb1Z/iYjynFR+
         98ioYc8UedVte2xhp/a3Bw2SSNhuCXS199yOqPa7S+awO54vKAahVRR9S9n0d/HYsR
         RneL7NgOFoCVJmO6r+RfbzhmYBjR5pmp3LFnrywc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1055/1095] ext4: fix extent status tree race in writeback error recovery path
Date:   Mon, 15 Aug 2022 20:07:34 +0200
Message-Id: <20220815180512.700807649@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 7f0d8e1d607c1a4fa9a27362a108921d82230874 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index beed9e32571c..826e2deb10f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1559,7 +1559,14 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
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
 
 	pagevec_init(&pvec);
-- 
2.35.1



