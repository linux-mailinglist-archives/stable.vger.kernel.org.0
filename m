Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803174F40AF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382582AbiDEMP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243511AbiDEKgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C7054FA2;
        Tue,  5 Apr 2022 03:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F193B81C8A;
        Tue,  5 Apr 2022 10:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7B3C385A0;
        Tue,  5 Apr 2022 10:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154143;
        bh=ZZJ2Y9OuUBQ1gJaIssElG4wArHFWqk1f3tUsMF6/rtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8Gq4ORv7hrlP26ltwKNdqjyxFjsuu98KcLWSumj8GoHO6tnMPspWZ8ZC9BL1IF2R
         zCHsKbgGW0RAOXEXidj7gQF8hQObp0fE1m/ScvQBlOdGaCGe2TjSyYumszr5v0csbW
         Ef0L9Ey8Xe1327cmGNiKOOd5U3DcB/diFkxpzn4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d59332e2db681cf18f0318a06e994ebbb529a8db@syzkaller.appspotmail.com,
        Lee Jones <lee.jones@linaro.org>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 473/599] ext4: dont BUG if someone dirty pages without asking ext4 first
Date:   Tue,  5 Apr 2022 09:32:47 +0200
Message-Id: <20220405070312.900870293@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit cc5095747edfb054ca2068d01af20be3fcc3634f ]

[un]pin_user_pages_remote is dirtying pages without properly warning
the file system in advance.  A related race was noted by Jan Kara in
2018[1]; however, more recently instead of it being a very hard-to-hit
race, it could be reliably triggered by process_vm_writev(2) which was
discovered by Syzbot[2].

This is technically a bug in mm/gup.c, but arguably ext4 is fragile in
that if some other kernel subsystem dirty pages without properly
notifying the file system using page_mkwrite(), ext4 will BUG, while
other file systems will not BUG (although data will still be lost).

So instead of crashing with a BUG, issue a warning (since there may be
potential data loss) and just mark the page as clean to avoid
unprivileged denial of service attacks until the problem can be
properly fixed.  More discussion and background can be found in the
thread starting at [2].

[1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
[2] https://lore.kernel.org/r/Yg0m6IjcNmfaSokM@google.com

Reported-by: syzbot+d59332e2db681cf18f0318a06e994ebbb529a8db@syzkaller.appspotmail.com
Reported-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/YiDS9wVfq4mM2jGK@mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d59474a54189..96546df39bcf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2023,6 +2023,15 @@ static int ext4_writepage(struct page *page,
 	else
 		len = PAGE_SIZE;
 
+	/* Should never happen but for bugs in other kernel subsystems */
+	if (!page_has_buffers(page)) {
+		ext4_warning_inode(inode,
+		   "page %lu does not have buffers attached", page->index);
+		ClearPageDirty(page);
+		unlock_page(page);
+		return 0;
+	}
+
 	page_bufs = page_buffers(page);
 	/*
 	 * We cannot do block allocation or other extent handling in this
@@ -2626,6 +2635,22 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			wait_on_page_writeback(page);
 			BUG_ON(PageWriteback(page));
 
+			/*
+			 * Should never happen but for buggy code in
+			 * other subsystems that call
+			 * set_page_dirty() without properly warning
+			 * the file system first.  See [1] for more
+			 * information.
+			 *
+			 * [1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
+			 */
+			if (!page_has_buffers(page)) {
+				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", page->index);
+				ClearPageDirty(page);
+				unlock_page(page);
+				continue;
+			}
+
 			if (mpd->map.m_len == 0)
 				mpd->first_page = page->index;
 			mpd->next_page = page->index + 1;
-- 
2.34.1



