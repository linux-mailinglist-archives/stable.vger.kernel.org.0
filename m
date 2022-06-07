Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6DA53FA55
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbiFGJvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240647AbiFGJuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:50:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB74E8B8E;
        Tue,  7 Jun 2022 02:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1202C61281;
        Tue,  7 Jun 2022 09:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE5C34115;
        Tue,  7 Jun 2022 09:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654595357;
        bh=0+2nPFhe/3tV+T5VodeQDdS2EQoa2YHS7Xnlsba9zbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vRGjKlQVQq9QIaPqSozVX2ma1ZqpEighHTcTKxXwwvxd9X9qLxxR7bGBm/au2YePU
         Ce6Bjgux79C6ciZJWhfI8qPaqPXJndlPqUJDy57dkAMWLkcMgw0f8X/Y/OJt6a+124
         20i+CQKw1dJND5M10sRxI15jnH2V67PFQpw4fQ9spEAvCEAxamAogAqHoMFNypO+my
         DyGWueS4YR0TshJL73QsByjYigL+EGia8uuP+/fCnWLiCu24210e9HlswDfdIrLFGo
         zTp/BfHGV4LSKqF74PaDIRfEOZJGUdT2oKPurGkC7LiEFITES3d7ME5sn+m+jgeI4G
         DEFy4VPmS97xA==
Date:   Tue, 7 Jun 2022 10:49:14 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: reject log replay if there is unsupported RO flag
Message-ID: <20220607094914.GC3554947@falcondesktop>
References: <429396b1039ec416504bc2bffca36d66ec8b52e2.1654569076.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <429396b1039ec416504bc2bffca36d66ec8b52e2.1654569076.git.wqu@suse.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 10:31:46AM +0800, Qu Wenruo wrote:
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
> Just set the nologreplay flag if there is any unsupported RO compact
> flag.
> 
> This will reject log replay no matter if we have dirty log or not, with
> the following message:
> 
>  BTRFS info (device dm-1): disabling log replay due to unsupported ro compat features
> 
> Cc: stable@vger.kernel.org #4.9+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index fe309db9f5ff..d06f1a176b5b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3655,6 +3655,14 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>  		err = -EINVAL;
>  		goto fail_alloc;
>  	}
> +	/*
> +	 * We have unsupported RO compat features, although RO mounted, we
> +	 * should any metadata write, including the log replay.
> +	 * Or we can screw up whatever the new feature requires.
> +	 */
> +	if (features)
> +		btrfs_set_and_info(fs_info, NOLOGREPLAY,
> +		"disabling log replay due to unsupported ro compat features");

Well, this might be surprising for users.

On mount, it's expected that everything that was fsynced is available.
Yes, there's a message printed informing the logs were not replayed,
but this allows for applications to read stale data.

I think just failing the mount and printing a message telling that the
fs needs to be explicitly mounted with -o nologreplay is less prone to
having stale data being read and used.

Thanks.

>  
>  	if (sectorsize < PAGE_SIZE) {
>  		struct btrfs_subpage_info *subpage_info;
> -- 
> 2.36.1
> 
