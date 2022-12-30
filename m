Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD83659589
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 07:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbiL3G42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 01:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiL3G4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 01:56:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403066310;
        Thu, 29 Dec 2022 22:56:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1324B81ACE;
        Fri, 30 Dec 2022 06:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77237C433D2;
        Fri, 30 Dec 2022 06:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672383378;
        bh=lTgCtlaw09AQc1EJvxU8dITv7f+/uj/inzYuWCO74g0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F7jrj9+paUtR35nrXp7Zx4Xq+jreoEUQsjZirdbV9CXWvxux1LqYvv+T4Dtn1XwKS
         HwEHKH6QdyaXmBsYsWxSOJWC6mJUCLBUj/eoZuPbjZsHlRsCwKEcgtIMZECXYQqp2+
         tBNlP1uO+J4EIIZMJ7lKeSMojmam2HhzMfs8AVdu5ruT+NwdmjdJL6Rvq4K9K/tOKx
         dnIzxP7vaXzBNfBtSA6/M9JeutEtUdLD6xVKiqizJcoFYrzQSD5qXKb3HkD4Ys/pNm
         TQPPx3xnpeG+SP4ka6QbK6IitBZdNar0c8F6sdTFdVYbluuSny6uzRDjtC4joOUzWl
         QEathYWQNDqNw==
Date:   Thu, 29 Dec 2022 22:56:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com,
        syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix possible use-after-free in ext4_find_extent
Message-ID: <Y66LkPumQjHC2U7d@sol.localdomain>
References: <20221230062931.2344157-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230062931.2344157-1-tudor.ambarus@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 08:29:31AM +0200, Tudor Ambarus wrote:
> syzbot reported a use-after-free Read in ext4_find_extent that is hit when
> using a corrupted file system. The bug was reported on Android 5.15, but
> using the same reproducer triggers the bug on v6.2-rc1 as well.
> 
> Fix the use-after-free by checking the extent header magic. An alternative
> would be to check the values of EXT4_{FIRST,LAST}_{EXTENT,INDEX} used in
> ext4_ext_binsearch() and ext4_ext_binsearch_idx(), so that we make sure
> that pointers returned by EXT4_{FIRST,LAST}_{EXTENT,INDEX} don't exceed the
> bounds of the extent tree node. But this alternative will not squash
> the bug for the cases where eh->eh_entries fit into eh->eh_max. We could
> also try to check the sanity of the path, but costs more than checking just
> the header magic, so stick to the header magic sanity check.
> 
> Link: https://syzkaller.appspot.com/bug?id=be6e90ce70987950e6deb3bac8418344ca8b96cd
> Reported-by: syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> ---
> v2: drop wrong/uneeded le16_to_cpu() conversion for eh->eh_magic
> 
>  fs/ext4/extents.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 9de1c9d1a13d..bedc8c098449 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -894,6 +894,12 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
>  		gfp_flags |= __GFP_NOFAIL;
>  
>  	eh = ext_inode_hdr(inode);
> +	if (eh->eh_magic != EXT4_EXT_MAGIC) {
> +		EXT4_ERROR_INODE(inode, "Extent header has invalid magic.");
> +		ret = -EFSCORRUPTED;
> +		goto err;
> +	}
> +

This is (incompletely) validating the extent header in the inode.  Isn't that
supposed to happen when the inode is loaded?  See how __ext4_iget() calls
ext4_ext_check_inode().  Why isn't that working here?

- Eric
