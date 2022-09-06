Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDD55AEFD8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiIFQGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiIFQFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:05:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED4432E;
        Tue,  6 Sep 2022 08:29:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4283033843;
        Tue,  6 Sep 2022 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662478161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMp2Hick6qOc8KeMg4OjzQqTj+axLzATYCnUdtiwa7A=;
        b=TIp0HnuEHgojS7W82GLHZZc1Cvn3kTdD5mfuotwL2QOjciaIlvUdMdAvpYS+dgCrA3YW7+
        BjaYzzqUfCHp/sBPcehfRjBiDHKPGll5093+PGCU2DlJU7QAj9bvt4PX8j2l5FM3PRcn+d
        YI4ecnUQXWSnW8/K9s7HEprcGViu5Y0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662478161;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMp2Hick6qOc8KeMg4OjzQqTj+axLzATYCnUdtiwa7A=;
        b=aBZNfzBPn3m3lZLFgPr8tg5BHFGGovmmpxuRm5ZHsNO+UEmEmI1bx0C40orY5iL9Eic83i
        Pp75cHZrHeSjyNDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3474013B2B;
        Tue,  6 Sep 2022 15:29:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eZAaDFFnF2NSHAAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 06 Sep 2022 15:29:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7A014A0681; Tue,  6 Sep 2022 17:29:20 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/5] ext4: Make mballoc try target group first even with mb_optimize_scan
Date:   Tue,  6 Sep 2022 17:29:07 +0200
Message-Id: <20220906152920.25584-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220906150803.375-1-jack@suse.cz>
References: <20220906150803.375-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3229; h=from:subject; bh=K6xdj54Qpb8Tt5BBOUsH35H7W3BKo6m5J++7zK88L3w=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjF2dC5xDGfWfuB7942hkkjA4TzXmtO0MD+XfQKYBM 9hZceKCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYxdnQgAKCRCcnaoHP2RA2ctrCA DY8HzJf/2fU07iV+Qth+MvHoUChGKLP8nv5pj7gAuiO2p6Kh13Os/d8kiZCcQw1Bb+bUm1S+ClVJzT okUIOmcM76Nk/xFiPUz32+/zvgc4zwv3naIZw1UXrfMgXPUh9GqQW5b4XuWEMenBrzOAc8jkpd02qp std5qKjBxO/4/1zeoOetdy5zO1RhXKsnbS+yDk05aMWqpe6CwEGrVwQiqdkGEFvOKdpoK2odqiM5jj kacoGog8A1M7Do5YPThFEv6RdCicN081w6j6rF62D+Bcj2BSHdjhSaqdCv+M7KcPe0VXZYBiWTqRgO xn3m37bQIJfmDh70ekSL6ky6kZzP/s
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

