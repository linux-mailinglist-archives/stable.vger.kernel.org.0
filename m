Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3FD5E5E39
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiIVJPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIVJPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:15:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C3CB40F6;
        Thu, 22 Sep 2022 02:15:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AFA9C219C9;
        Thu, 22 Sep 2022 09:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663838142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0nJel4HKBq2pcIN2vnt5G5EqJOO7OGmT27bntvu5tyU=;
        b=CJH0ulDFIv8vK/NuyJes/w7roVw9H/+UgNa06LoVK7HfKdODqCZ8nJnClJEXmvTl6a0wnZ
        Q4dMkFSI0KkBaM5571DRHzB8S/3x5M0hgwOd3UiT5zI1xqQ6ve6UbrZ0LpADN4LqITcXj/
        rTCl8fGm5Zs44lNPKtCmV6jnTFowo6o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663838142;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0nJel4HKBq2pcIN2vnt5G5EqJOO7OGmT27bntvu5tyU=;
        b=S0hdF5Z8mcPMmf5P6KcwiWlAmzMCm35hcToHrAfDUDOHwnYSNeQKrP1bS6baOECOqdkoQf
        xuRf6nVcMOtCqrAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F5EF1346B;
        Thu, 22 Sep 2022 09:15:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +Iv0Ir4nLGNxeQAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 22 Sep 2022 09:15:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0C796A0684; Thu, 22 Sep 2022 11:15:42 +0200 (CEST)
Date:   Thu, 22 Sep 2022 11:15:42 +0200
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     jack@suse.cz, harshadshirwadkar@gmail.com, stable@vger.kernel.org,
        ritesh.list@gmail.com, stefan.wahren@i2se.com,
        ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org,
        regressions@leemhuis.info
Subject: Re: [PATCH 1/5] ext4: Make mballoc try target group first even with
 mb_optimize_scan
Message-ID: <20220922091542.pkhedytey7wzp5fi@quack3>
References: <20220908091301.147-1-jack@suse.cz>
 <20220908092136.11770-1-jack@suse.cz>
 <166381513758.2957616.15274082762134894004.b4-ty@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sufjmcoi5s6ibxqm"
Content-Disposition: inline
In-Reply-To: <166381513758.2957616.15274082762134894004.b4-ty@mit.edu>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sufjmcoi5s6ibxqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 21-09-22 22:52:34, Theodore Ts'o wrote:
> On Thu, 8 Sep 2022 11:21:24 +0200, Jan Kara wrote:
> > One of the side-effects of mb_optimize_scan was that the optimized
> > functions to select next group to try were called even before we tried
> > the goal group. As a result we no longer allocate files close to
> > corresponding inodes as well as we don't try to expand currently
> > allocated extent in the same group. This results in reaim regression
> > with workfile.disk workload of upto 8% with many clients on my test
> > machine:
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/5] ext4: Make mballoc try target group first even with mb_optimize_scan
>       commit: 4fca50d440cc5d4dc570ad5484cc0b70b381bc2a
> [2/5] ext4: Avoid unnecessary spreading of allocations among groups
>       commit: 1940265ede6683f6317cba0d428ce6505eaca944
> [3/5] ext4: Make directory inode spreading reflect flexbg size
>       commit: 613c5a85898d1cd44e68f28d65eccf64a8ace9cf
> [4/5] ext4: Use locality group preallocation for small closed files
>       commit: a9f2a2931d0e197ab28c6007966053fdababd53f
> [5/5] ext4: Use buckets for cr 1 block scan instead of rbtree
>       commit: 83e80a6e3543f37f74c8e48a5f305b054b65ce2a

Thanks Ted! I just have locally a small fixup to the series that was reported
by Smatch. It is attached, either fold it into the last patch or just merge
it as a separate patch. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--sufjmcoi5s6ibxqm
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ext4-Fixup-possible-uninitialized-variable-access-in.patch"

From 8885b11fb253e08ecfa90a28beffb01719af84f5 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 22 Sep 2022 11:09:29 +0200
Subject: [PATCH] ext4: Fixup possible uninitialized variable access in
 ext4_mb_choose_next_group_cr1()

Variable 'grp' may be left uninitialized if there's no group with
suitable average fragment size (or larger). Fix the problem by
initializing it earlier.

Fixes: 83e80a6e3543 ("ext4: use buckets for cr 1 block scan instead of rbtree")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 71f5b67d7f28..9dad93059945 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -910,7 +910,7 @@ static void ext4_mb_choose_next_group_cr1(struct ext4_allocation_context *ac,
 		int *new_cr, ext4_group_t *group, ext4_group_t ngroups)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	struct ext4_group_info *grp, *iter;
+	struct ext4_group_info *grp = NULL, *iter;
 	int i;
 
 	if (unlikely(ac->ac_flags & EXT4_MB_CR1_OPTIMIZED)) {
@@ -927,7 +927,6 @@ static void ext4_mb_choose_next_group_cr1(struct ext4_allocation_context *ac,
 			read_unlock(&sbi->s_mb_avg_fragment_size_locks[i]);
 			continue;
 		}
-		grp = NULL;
 		list_for_each_entry(iter, &sbi->s_mb_avg_fragment_size[i],
 				    bb_avg_fragment_size_node) {
 			if (sbi->s_mb_stats)
-- 
2.35.3


--sufjmcoi5s6ibxqm--
