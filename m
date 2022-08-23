Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3278859ED5D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 22:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiHWUfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 16:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiHWUfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 16:35:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5120441D2E;
        Tue, 23 Aug 2022 13:15:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9FC103372D;
        Tue, 23 Aug 2022 20:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661285758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMp2Hick6qOc8KeMg4OjzQqTj+axLzATYCnUdtiwa7A=;
        b=ZBsZNdZsKC5qecnMp+3LpiRY1AUGCe+IHX0yhlQp7RqUSUPbWEafpMg8iefxB0otwP/xhw
        u5Vb28/ZgIYGnCM3NoUCaQzqeFdiqzoFEm2rrjfA8RLj3JiTQMNm8QlFnkgLBZHuYLCMmQ
        iWYnd+a0EIuO9k4rXCyGAZv7oHHhZhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661285758;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMp2Hick6qOc8KeMg4OjzQqTj+axLzATYCnUdtiwa7A=;
        b=Ydai4+vV0v4J3jpMWKc0D5VpzBeApWke4bkHPMCVzl6dG4zuu+IIvmzwu+c5uTU5i6AW38
        6bB4rzZ8Kq+6IHDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8165C13A89;
        Tue, 23 Aug 2022 20:15:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EDjOHn41BWPLAQAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 23 Aug 2022 20:15:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E4D9BA067E; Tue, 23 Aug 2022 22:15:57 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/2] ext4: Make mballoc try target group first even with mb_optimize_scan
Date:   Tue, 23 Aug 2022 22:15:53 +0200
Message-Id: <20220823201557.28818-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220823134508.27854-1-jack@suse.cz>
References: <20220823134508.27854-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3229; h=from:subject; bh=K6xdj54Qpb8Tt5BBOUsH35H7W3BKo6m5J++7zK88L3w=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjBTV45xDGfWfuB7942hkkjA4TzXmtO0MD+XfQKYBM 9hZceKCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYwU1eAAKCRCcnaoHP2RA2SlNB/ 0T+p6RdaJ07F8PDE++UatCsJA9tiUF0TxG+gsBxqJka3KqTFk8JzJ9vmyCEo+9XKtvRHskEsKSFI2L z79ldTi2hp//b8ABohFIgf0aBdyPFs6OBEMLPR5dF6Jr8PBZgX1CBAIvAwrlR2Iak+b1lMvTnzR3Hy MoXtll9qG7ReLbt8ZprUXw7GZTqbN4t/8f5r/OIGCtRUUsQXp1GVBnmkUI0OOj8PXq7VZ2H/z7LFLa bfez0uBgT2dKMAkdFfjSlPGjFHNKUNmHtElHndfKdMJVbYeNY0a6i0WXepgOkuJl1XIGlfgFdHBauE 770BaSr803SH610k/1YE2kOwe17GBZ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One of the side-effects of mb_optimize_scan was that the optimized
functions to select next group to try were called even before we tried
the goal group. As a result we no longer allocate files close to
corresponding inodes as well as we don't try to expand currently
allocated extent in the same group. This results in reaim regression
with workfile.disk workload of upto 8% with many clients on my test
machine:

                     baseline               mb_optimize_scan
Hmean     disk-1       2114.16 (   0.00%)     2099.37 (  -0.70%)
Hmean     disk-41     87794.43 (   0.00%)    83787.47 *  -4.56%*
Hmean     disk-81    148170.73 (   0.00%)   135527.05 *  -8.53%*
Hmean     disk-121   177506.11 (   0.00%)   166284.93 *  -6.32%*
Hmean     disk-161   220951.51 (   0.00%)   207563.39 *  -6.06%*
Hmean     disk-201   208722.74 (   0.00%)   203235.59 (  -2.63%)
Hmean     disk-241   222051.60 (   0.00%)   217705.51 (  -1.96%)
Hmean     disk-281   252244.17 (   0.00%)   241132.72 *  -4.41%*
Hmean     disk-321   255844.84 (   0.00%)   245412.84 *  -4.08%*

Also this is causing huge regression (time increased by a factor of 5 or
so) when untarring archive with lots of small files on some eMMC storage
cards.

Fix the problem by making sure we try goal group first.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@vger.kernel.org
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/all/20220727105123.ckwrhbilzrxqpt24@quack3/
Link: https://lore.kernel.org/all/0d81a7c2-46b7-6010-62a4-3e6cfc1628d6@i2se.com/
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bd8f8b5c3d30..41e1cfecac3b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1049,8 +1049,10 @@ static void ext4_mb_choose_next_group(struct ext4_allocation_context *ac,
 {
 	*new_cr = ac->ac_criteria;
 
-	if (!should_optimize_scan(ac) || ac->ac_groups_linear_remaining)
+	if (!should_optimize_scan(ac) || ac->ac_groups_linear_remaining) {
+		*group = next_linear_group(ac, *group, ngroups);
 		return;
+	}
 
 	if (*new_cr == 0) {
 		ext4_mb_choose_next_group_cr0(ac, new_cr, group, ngroups);
@@ -2636,7 +2638,7 @@ static noinline_for_stack int
 ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
 	ext4_group_t prefetch_grp = 0, ngroups, group, i;
-	int cr = -1;
+	int cr = -1, new_cr;
 	int err = 0, first_err = 0;
 	unsigned int nr = 0, prefetch_ios = 0;
 	struct ext4_sb_info *sbi;
@@ -2711,13 +2713,11 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		ac->ac_groups_linear_remaining = sbi->s_mb_max_linear_groups;
 		prefetch_grp = group;
 
-		for (i = 0; i < ngroups; group = next_linear_group(ac, group, ngroups),
-			     i++) {
-			int ret = 0, new_cr;
+		for (i = 0, new_cr = cr; i < ngroups; i++,
+		     ext4_mb_choose_next_group(ac, &new_cr, &group, ngroups)) {
+			int ret = 0;
 
 			cond_resched();
-
-			ext4_mb_choose_next_group(ac, &new_cr, &group, ngroups);
 			if (new_cr != cr) {
 				cr = new_cr;
 				goto repeat;
-- 
2.35.3

