Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167D24FC2C2
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 18:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245745AbiDKQzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 12:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbiDKQzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 12:55:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8865335264;
        Mon, 11 Apr 2022 09:53:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CF7F61F38D;
        Mon, 11 Apr 2022 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649696012;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mx2MNXzBPvqRmySauuxaY9S1RzVPKVLNe1AYpqQ8uSU=;
        b=yiv8JRM1Mf4utmtOopUv1sB2Y/Z/a6O+R/ACrYUHoD20N49808AaOywlk+hdJFWWkg44fo
        KT+IEtPlbLOraSFWUH1Iew2QWbrrJP1Ku1WrZ6NNv08m1rRHDFb9rxYpJys4C6jm/xVz8g
        VoWucXGJ83BaKTPXkr2JLzEqQVNOgVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649696012;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mx2MNXzBPvqRmySauuxaY9S1RzVPKVLNe1AYpqQ8uSU=;
        b=EUMZH8PKI2U1eB1D+B3BzP7pg6noZSg+Go2steQvH6iMmQYa/HIuNorpm0ytAbw/6C9jk9
        2cvMTmKd/iR821Dw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id C381DA3B82;
        Mon, 11 Apr 2022 16:53:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 349D1DA7F7; Mon, 11 Apr 2022 18:49:28 +0200 (CEST)
Date:   Mon, 11 Apr 2022 18:49:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: force v2 space cache usage for subpage mount
Message-ID: <20220411164927.GR15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Matt Corallo <blnxfsl@bluematt.me>, stable@vger.kernel.org
References: <1f622305ee7ecb3b6ec09f878c26ad0446e18311.1648798164.git.wqu@suse.com>
 <20220401163954.GM15609@twin.jikos.cz>
 <b9b41fbd-e60d-6698-53f6-545a320acf1a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9b41fbd-e60d-6698-53f6-545a320acf1a@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 06:57:58AM +0800, Qu Wenruo wrote:
> >> index d456f426924c..34eb6d4b904a 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -3675,6 +3675,17 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
> >>   	if (sectorsize < PAGE_SIZE) {
> >>   		struct btrfs_subpage_info *subpage_info;
> >>
> >> +		/*
> >> +		 * V1 space cache has some hardcoded PAGE_SIZE usage, and is
> >> +		 * going to be deprecated.
> >> +		 *
> >> +		 * Force to use v2 cache for subpage case.
> >> +		 */
> >> +		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
> >> +		btrfs_set_and_info(fs_info, FREE_SPACE_TREE,
> >> +			"forcing free space tree for sector size %u with page size %lu",
> >> +			sectorsize, PAGE_SIZE);
> >
> > I'm not sure this is implemented the right way. Why is it unconditional?
> 
> Isn't the same thing we do when parsing the mount options for switch
> v1->v2 cache?

The mount code checks if the v1 is active ie. has some existing
structures and then clears v1.
> 
> > Does any subsequent mount have to clear and set the bits after it has
> > been already? Or what if the free space tree is set at mkfs time, which
> > is now the default.
> 
> The function btrfs_set_and_info() will only inform the end users if the
> bit is not set.
> 
> >
> > Next, remounting v1->v2 does more things, like removing the v1 tree if
> > it exists. And due to some bugs there are more bits for free space tree
> > to be set like FREE_SPACE_TREE_VALID.  So I don't thing this patch
> > covers all cases for the v2.
> 
> You're right on remounting, but in the opposite way.
> There is nothing prevent the users from re-enabling v1 cache.
> 
> I should also prevent user from setting v1 cache.

Good point, for the subpage case yes, but otherwise not though it's
a valid operation it does not make much sense.

> Another concern is, I didn't see code cleaning up v1 cache when we do
> the v1->v2 switch.
> The only code doing such cleanup is cleanup_free_space_cache_v1() in
> free-space-cache.c, but it only gets called in
> btrfs_set_free_space_cache_v1_active().
> 
> Or did I miss something?

No, that's the code I had in mind, and clearing the v1 code once v2 is
activated has been added because it was not there before.
