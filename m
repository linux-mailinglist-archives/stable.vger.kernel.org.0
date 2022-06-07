Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C961C53FEDE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 14:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243795AbiFGMf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 08:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243789AbiFGMfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 08:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55452B0A49;
        Tue,  7 Jun 2022 05:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6B02B81F8A;
        Tue,  7 Jun 2022 12:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E72C385A5;
        Tue,  7 Jun 2022 12:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654605320;
        bh=1K6HQDJAL5B3t1rxshseXZLoYSEqaJiNYbN2V/6NQ68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KrZc81ZitjdRtnpjlmWUYubs2yxX3AcjSXSDrIL15aHD2/SzTTxRMohaI8PGdPRkz
         ZNCnOfu4aGgWb+4hX1Us3KenNPE5jDIzDUmibZgnIW4iIpXn/UyCP5cKAVn5hI2Xv/
         eLMTTwHQzOg4jiW62GHvoKVt/Fb/ians+LozMUxnP8DlgDAuxwUTW98t+ROfnTCcRg
         nHML95cQ53nBck8YEbqc2zjpLp5yCnBhm6HcspZq0DkmwcXtv0YahOwrbvp7w7fw3O
         bsldj+mewJMsmHeKiYbjxv+rOqwHdpYFO/2Mwa2y2aMNoYqQ9KgQyZEWEE/9OQQKWf
         arMGMl028KfOQ==
Date:   Tue, 7 Jun 2022 13:35:17 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: reject log replay if there is unsupported RO
 flag
Message-ID: <20220607123517.GB3568258@falcondesktop>
References: <a6612cd9432b8ae6429cceee561c0259232cc554.1654602414.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6612cd9432b8ae6429cceee561c0259232cc554.1654602414.git.wqu@suse.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 07:48:24PM +0800, Qu Wenruo wrote:
> [BUG]
> If we have a btrfs image with dirty log, along with an unsupported RO
> compatible flag:
> 
> log_root		30474240
> ...
> compat_flags		0x0
> compat_ro_flags		0x40000003
> 			( FREE_SPACE_TREE |
> 			  FREE_SPACE_TREE_VALID |
> 			  unknown flag: 0x40000000 )
> 
> Then even if we can only mount it RO, we will still cause metadata
> update for log replay:
> 
>  BTRFS info (device dm-1): flagging fs with big metadata feature
>  BTRFS info (device dm-1): using free space tree
>  BTRFS info (device dm-1): has skinny extents
>  BTRFS info (device dm-1): start tree-log replay
> 
> This is definitely against RO compact flag requirement.
> 
> [CAUSE]
> RO compact flag only forces us to do RO mount, but we will still do log
> replay for plain RO mount.
> 
> Thus this will result us to do log replay and update metadata.
> 
> This can be very problematic for new RO compat flag, for example older
> kernel can not understand v2 cache, and if we allow metadata update on
> RO mount and invalidate/corrupt v2 cache.
> 
> [FIX]
> Just reject the mount unless rescue=nologreplay is provided:
> 
>   BTRFS error (device dm-1): cannot replay dirty log with unsupport optional features (0x40000000), try rescue=nologreplay instead
> 
> We don't want to set rescue=nologreply directly, as this would make the
> end user to read the old data, and cause confusion.
> 
> Since the such case is really rare, we're mostly fine to just reject the
> mount with an error message, which also includes the proper workaround.
> 
> Cc: stable@vger.kernel.org #4.9+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Reject the mount instead of setting nologreplay
>   To avoid the confusion which can return old data.
>   Unfortunately I don't have a better to shrink the new error message
>   into one 80-char line.
> ---
>  fs/btrfs/disk-io.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index fe309db9f5ff..f20bd8024334 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3655,6 +3655,20 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>  		err = -EINVAL;
>  		goto fail_alloc;
>  	}
> +	/*
> +	 * We have unsupported RO compat features, although RO mounted, we
> +	 * should not cause any metadata write, including log replay.
> +	 * Or we can screw up whatever the new feature requires.
> +	 */
> +	if (unlikely(features && btrfs_super_log_root(disk_super) &&
> +		     !btrfs_test_opt(fs_info, NOLOGREPLAY))) {
> +		btrfs_err(fs_info,
> +"cannot replay dirty log with unsupport optional features (0x%llx), try rescue=nologreplay instead",

unsupport -> unsupported

The "optional" sounds superfluous.

You are CC'ing stable 4.9+, but IIRC the rescue= mount option is relatively
recent, so the message will need to be updated (4.9, at least, doesn't have it).

Other than that it looks fine to me.

It's clear that it's a problem with the free space tree, but with verity (the only
other RO compat feature), I'm not sure we need this constraint, and it may happen
more often since verity support is recent, unlike the free space tree which has
been around for years.

Thanks.

> +			  features);
> +		err = -EINVAL;
> +		goto fail_alloc;
> +	}
> +
>  
>  	if (sectorsize < PAGE_SIZE) {
>  		struct btrfs_subpage_info *subpage_info;
> -- 
> 2.36.1
> 
