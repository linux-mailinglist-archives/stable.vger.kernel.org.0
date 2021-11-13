Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C6744F342
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhKMNPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231555AbhKMNPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:15:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C030260F46;
        Sat, 13 Nov 2021 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636809170;
        bh=+c22rjq0hOoTG8e5JsBvf9QwlmMa6qpSwLt/OexNODY=;
        h=Subject:To:Cc:From:Date:From;
        b=TUG0i/7nkRwvgtTZJbXdM6uKnBD+892AS6GMEJI6cjxVgrMjQi3Lc4Gar+gdGQG1o
         3t3woFbKTxcXpxN2di9a0djCLu0RlLOH276qrdH0OwUa7jlgH9RjQi+9jkgoyi67P5
         nnpIQgYyiUF/BOo6sC7dw1pbUp/1wfcVSwex1ZpQ=
Subject: FAILED: patch "[PATCH] ext4: fix lazy initialization next schedule time computation" failed to apply to 4.14-stable tree
To:     shaoyi@amazon.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:12:40 +0100
Message-ID: <16368091606333@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 39fec6889d15a658c3a3ebb06fd69d3584ddffd3 Mon Sep 17 00:00:00 2001
From: Shaoying Xu <shaoyi@amazon.com>
Date: Thu, 2 Sep 2021 16:44:12 +0000
Subject: [PATCH] ext4: fix lazy initialization next schedule time computation
 in more granular unit

Ext4 file system has default lazy inode table initialization setup once
it is mounted. However, it has issue on computing the next schedule time
that makes the timeout same amount in jiffies but different real time in
secs if with various HZ values. Therefore, fix by measuring the current
time in a more granular unit nanoseconds and make the next schedule time
independent of the HZ value.

Fixes: bfff68738f1c ("ext4: add support for lazy inode table initialization")
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210902164412.9994-2-shaoyi@amazon.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 88d5d274a868..8a67e5f3f576 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3263,9 +3263,9 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	struct super_block *sb = elr->lr_super;
 	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
 	ext4_group_t group = elr->lr_next_group;
-	unsigned long timeout = 0;
 	unsigned int prefetch_ios = 0;
 	int ret = 0;
+	u64 start_time;
 
 	if (elr->lr_mode == EXT4_LI_MODE_PREFETCH_BBITMAP) {
 		elr->lr_next_group = ext4_mb_prefetch(sb, group,
@@ -3302,14 +3302,13 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		ret = 1;
 
 	if (!ret) {
-		timeout = jiffies;
+		start_time = ktime_get_real_ns();
 		ret = ext4_init_inode_table(sb, group,
 					    elr->lr_timeout ? 0 : 1);
 		trace_ext4_lazy_itable_init(sb, group);
 		if (elr->lr_timeout == 0) {
-			timeout = (jiffies - timeout) *
-				EXT4_SB(elr->lr_super)->s_li_wait_mult;
-			elr->lr_timeout = timeout;
+			elr->lr_timeout = nsecs_to_jiffies((ktime_get_real_ns() - start_time) *
+				EXT4_SB(elr->lr_super)->s_li_wait_mult);
 		}
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;

