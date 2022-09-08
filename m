Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4924B5B1886
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 11:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiIHJXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 05:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiIHJXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 05:23:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C0ED99D4;
        Thu,  8 Sep 2022 02:21:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C1F131FA79;
        Thu,  8 Sep 2022 09:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662628896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/T2gqCnaVMIrnu1bhWes7S5rCxq+aYcfojkZpwhcK9A=;
        b=1iD0FmZ2Hqf6ExZ1fYkyqZwh8HMtyvulzgY35X+wPBUntqmvkPIXkH6WH7UwYUwlMNOGZe
        nbL7GHSPZEqzZevFGONipjMu6jkqmCyHUy+p4KWElkqzBls3dx+axlG75IqI5LTRUCW4vi
        5HCZnIguR+PRlk4p7/PkrBqnmzPjmRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662628896;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/T2gqCnaVMIrnu1bhWes7S5rCxq+aYcfojkZpwhcK9A=;
        b=Y0dxXbRFjhvwaSKAgai3TNOVz9e/REPRoTBDQKNvjVyUHkkZrmo5Oxtlexwe6CTjsFbE3y
        vaudJVTr5VUo5tCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B0E8913B5D;
        Thu,  8 Sep 2022 09:21:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TDiYKiC0GWOsRAAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Sep 2022 09:21:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 125BAA066D; Thu,  8 Sep 2022 11:21:36 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCH 1/5] ext4: Make mballoc try target group first even with mb_optimize_scan
Date:   Thu,  8 Sep 2022 11:21:24 +0200
Message-Id: <20220908092136.11770-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220908091301.147-1-jack@suse.cz>
References: <20220908091301.147-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3349; h=from:subject; bh=Q57kHbUxIETSpSaq6MNvVeGwmpZn+1WoPPXosbRjvag=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjGbQTGiXzCo2TURk0pEcrqRNL51jM02ZiWkmK4rjf 0rsh8+iJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYxm0EwAKCRCcnaoHP2RA2bD/B/ 4laWY+bgTBXzPo3DEqJfOY61ewWFro5p8X8qt2B1GedixLoOe1hhl4y37TXJF9snAXLhYTe3fO4S1L j4/6/SSQw6QaFBGJL4K/v7SmtL0foQr8cXRKe+GzvHmQjYVbV0riwqPQ0Y1xE3YyKxG+K0uhzB39eu 0Vo5FkJJ15NeHZbVmwdcn4GarWXEgef/EhsyKt+5uQAHpyGlSUo5Wx8eOLEhmlTuhJFm6X3SSMzb57 Dm655daizo7qaIbQs5/YboH/tIWx7w0cnk+kgfLAN/VvtTM8ZzH+gKkvj1T7mpVKC78z74ypA+X4S1 K7Enghi0I6OFZwKU+A4oalGE+wCctB
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
Reported-and-tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
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

