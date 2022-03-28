Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EECD4EA066
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343986AbiC1Tu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344144AbiC1TsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5F86A03C;
        Mon, 28 Mar 2022 12:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE6A4B81203;
        Mon, 28 Mar 2022 19:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32C0C340F0;
        Mon, 28 Mar 2022 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496621;
        bh=X9+QBqSy1pQQYXeuH+D28z07BYNcRuMRUFmFK7j86Wc=;
        h=From:To:Cc:Subject:Date:From;
        b=ERhL8vmwfl0/3Z4RqvPYGdBnIT85Yh3+UJzs3eacToG1TdG92jHZiKkE6FPPAOH5I
         qwytEHr2d0gATMcckw3fTjqU3GRtli/Un0TxFZ8ghjCU7NnVWQwcxhit4zZhytGGXr
         fedX+syt8ApmrU8btyhL8JLAbUGeRdZSR17q0GlCIqH4fDNzZzDtiCtRwjqY551xdq
         xTTfP83rBHCkHf5bv4A3C20nd5pkkQv2qx6Y83r4i+PjHRBZn9Tdj6sSGvOeX77hDE
         IgH1ToJJ5r5HG0iSf8MGNrLgjInVgIWe9NPK0JLw0wcJlfgYw6X0KH9nLxLXWdApmE
         hY3L7YvBTkZ3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>,
        syzbot+d59332e2db681cf18f0318a06e994ebbb529a8db@syzkaller.appspotmail.com,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/2] ext4: don't BUG if someone dirty pages without asking ext4 first
Date:   Mon, 28 Mar 2022 15:43:37 -0400
Message-Id: <20220328194338.1586587-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7959aae4857e..96cf0f57ca95 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2148,6 +2148,15 @@ static int ext4_writepage(struct page *page,
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
@@ -2697,6 +2706,22 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
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

