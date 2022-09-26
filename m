Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA6F5E9D05
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 11:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbiIZJLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 05:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiIZJLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 05:11:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD623AB06;
        Mon, 26 Sep 2022 02:11:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 76F911FDC8;
        Mon, 26 Sep 2022 09:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664183487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LcP56da7RqXZbKYV8BewVILlH+GA7DBV3dG3NVNj/i4=;
        b=VNzg1/K1ZC1GkC6kpVfBmz9yyTb0tTudCBKhXKzHpJm+PN59jOcwndwaZEzjxvrBWnAFaI
        XPMtwpxiIjOwinSxJjUgYUU1g/8FsuV8X4Ou54gXSAfi82A5DZrDqSBDPb8boue89iLwSg
        HyiXkSlajCirSILj/KEYPZyHjBRCkmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664183487;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LcP56da7RqXZbKYV8BewVILlH+GA7DBV3dG3NVNj/i4=;
        b=p+pMXq1lBtVVUk93aRdh1LlJPzNkSoTSpPnsvv1CUUH7hZ7S/cCjch8RhmBr6LqF3L2xRe
        PyKnske0umm1W3Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66DD613486;
        Mon, 26 Sep 2022 09:11:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gmMTGb9sMWMIbQAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 26 Sep 2022 09:11:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id F0EBCA0685; Mon, 26 Sep 2022 11:11:26 +0200 (CEST)
Date:   Mon, 26 Sep 2022 11:11:26 +0200
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     jack@suse.cz, harshadshirwadkar@gmail.com, stable@vger.kernel.org,
        ritesh.list@gmail.com, stefan.wahren@i2se.com,
        ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org,
        regressions@leemhuis.info
Subject: Re: [PATCH 1/5] ext4: Make mballoc try target group first even with
 mb_optimize_scan
Message-ID: <20220926091126.yx25wgeibxabmcaj@quack3>
References: <20220908091301.147-1-jack@suse.cz>
 <20220908092136.11770-1-jack@suse.cz>
 <166381513758.2957616.15274082762134894004.b4-ty@mit.edu>
 <20220922091542.pkhedytey7wzp5fi@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922091542.pkhedytey7wzp5fi@quack3>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 22-09-22 11:15:42, Jan Kara wrote:
> On Wed 21-09-22 22:52:34, Theodore Ts'o wrote:
> > On Thu, 8 Sep 2022 11:21:24 +0200, Jan Kara wrote:
> > > One of the side-effects of mb_optimize_scan was that the optimized
> > > functions to select next group to try were called even before we tried
> > > the goal group. As a result we no longer allocate files close to
> > > corresponding inodes as well as we don't try to expand currently
> > > allocated extent in the same group. This results in reaim regression
> > > with workfile.disk workload of upto 8% with many clients on my test
> > > machine:
> > > 
> > > [...]
> > 
> > Applied, thanks!
> > 
> > [1/5] ext4: Make mballoc try target group first even with mb_optimize_scan
> >       commit: 4fca50d440cc5d4dc570ad5484cc0b70b381bc2a
> > [2/5] ext4: Avoid unnecessary spreading of allocations among groups
> >       commit: 1940265ede6683f6317cba0d428ce6505eaca944
> > [3/5] ext4: Make directory inode spreading reflect flexbg size
> >       commit: 613c5a85898d1cd44e68f28d65eccf64a8ace9cf
> > [4/5] ext4: Use locality group preallocation for small closed files
> >       commit: a9f2a2931d0e197ab28c6007966053fdababd53f
> > [5/5] ext4: Use buckets for cr 1 block scan instead of rbtree
> >       commit: 83e80a6e3543f37f74c8e48a5f305b054b65ce2a
> 
> Thanks Ted! I just have locally a small fixup to the series that was reported
> by Smatch. It is attached, either fold it into the last patch or just merge
> it as a separate patch. Thanks!

Ted, I've noticed you've merged my mballoc fixes (and pushed them to Linus)
without this fixup. Can you please merge it? The use of uninitialized
variable seems rare but possible...

								Honza

> From 8885b11fb253e08ecfa90a28beffb01719af84f5 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 22 Sep 2022 11:09:29 +0200
> Subject: [PATCH] ext4: Fixup possible uninitialized variable access in
>  ext4_mb_choose_next_group_cr1()
> 
> Variable 'grp' may be left uninitialized if there's no group with
> suitable average fragment size (or larger). Fix the problem by
> initializing it earlier.
> 
> Fixes: 83e80a6e3543 ("ext4: use buckets for cr 1 block scan instead of rbtree")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/mballoc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 71f5b67d7f28..9dad93059945 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -910,7 +910,7 @@ static void ext4_mb_choose_next_group_cr1(struct ext4_allocation_context *ac,
>  		int *new_cr, ext4_group_t *group, ext4_group_t ngroups)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
> -	struct ext4_group_info *grp, *iter;
> +	struct ext4_group_info *grp = NULL, *iter;
>  	int i;
>  
>  	if (unlikely(ac->ac_flags & EXT4_MB_CR1_OPTIMIZED)) {
> @@ -927,7 +927,6 @@ static void ext4_mb_choose_next_group_cr1(struct ext4_allocation_context *ac,
>  			read_unlock(&sbi->s_mb_avg_fragment_size_locks[i]);
>  			continue;
>  		}
> -		grp = NULL;
>  		list_for_each_entry(iter, &sbi->s_mb_avg_fragment_size[i],
>  				    bb_avg_fragment_size_node) {
>  			if (sbi->s_mb_stats)
> -- 
> 2.35.3
> 

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
