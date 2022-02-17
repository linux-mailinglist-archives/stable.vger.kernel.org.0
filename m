Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEBF4BA91B
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241857AbiBQTB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:01:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiBQTB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:01:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD6A6E7AB;
        Thu, 17 Feb 2022 11:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBA45B823E9;
        Thu, 17 Feb 2022 19:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1B5C340E8;
        Thu, 17 Feb 2022 19:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645124469;
        bh=Aoe0gyEVvW9ObG8svvmEoi/SOKZWIMHsOJgYb+hnrgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2IU2IoXUCWV44g16xnYHsg8k3VE8F7MLm23P87LmZmyV1d6KEkIbdWh0f6txZm8+H
         /Vo4jWc9deD1AyP+Mfh6xdOYss/3sWPZGwIIM7TcqOknnTJkRtnBaxjE0ityKeYaEK
         UmxVZHfuiIqoTdWy0HbIecxhGUq1Q4P+Hh21smsA=
Date:   Thu, 17 Feb 2022 20:01:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH for v5.15 1/2] btrfs: don't hold CPU for too long when
 defragging a file
Message-ID: <Yg6bcq2stNcvDLOv@kroah.com>
References: <cover.1644994950.git.wqu@suse.com>
 <67dd6f0e69c59a8554d7a2977939f94221af00c1.1644994950.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67dd6f0e69c59a8554d7a2977939f94221af00c1.1644994950.git.wqu@suse.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 03:09:07PM +0800, Qu Wenruo wrote:
> commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b upstream.

This commit is already in 5.15.22.

> 
> There is a user report about "btrfs filesystem defrag" causing 120s
> timeout problem.
> 
> For btrfs_defrag_file() it will iterate all file extents if called from
> defrag ioctl, thus it can take a long time.
> 
> There is no reason not to release the CPU during such a long operation.
> 
> Add cond_resched() after defragged one cluster.
> 
> CC: stable@vger.kernel.org # 5.15
> Link: https://lore.kernel.org/linux-btrfs/10e51417-2203-f0a4-2021-86c8511cc367@gmx.com
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6a863b3f6de0..38a1b68c7851 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1581,6 +1581,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  				last_len = 0;
>  			}
>  		}
> +		cond_resched();
>  	}
>  
>  	ret = defrag_count;
> -- 
> 2.35.1
> 

The original commit looks nothing like this commit at all.  Are you sure
you got this correct?

confused,

greg k-h
