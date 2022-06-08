Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148C9542FEA
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbiFHMG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 08:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiFHMGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 08:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C329B2408A;
        Wed,  8 Jun 2022 05:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3D26187F;
        Wed,  8 Jun 2022 12:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F6FC3411C;
        Wed,  8 Jun 2022 12:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654690013;
        bh=3OGpcCZEusqeV7WTYQWC5s+kZ9Fakcr/VjfHB1Q0iqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nv60BFxCLTZpsg9a095nuV92mujJrLLFgD/N4VzGvLYLu/LpYsM5DK/YQfi6wJIrD
         HklSFIksJNxMskO+6rbmtz+Q9Cz3CeVH0ZwuBc5InXaZ+6yU0pAZn+i4vPiI2bzi86
         OscKygEfWcljX1VbdFugnfQ09o+/fZf7omHwjf3c=
Date:   Wed, 8 Jun 2022 14:06:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: fix bio_clone_blkg_association() to associate
 with proper blkcg_gq
Message-ID: <YqCQ0xJBpAqbbF/k@kroah.com>
References: <20220608114528.15611-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608114528.15611-1-jack@suse.cz>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 01:45:28PM +0200, Jan Kara wrote:
> commit 22b106e5355d6e7a9c3b5cb5ed4ef22ae585ea94 upstream.
> 
> Commit d92c370a16cb ("block: really clone the block cgroup in
> bio_clone_blkg_association") changed bio_clone_blkg_association() to
> just clone bio->bi_blkg reference from source to destination bio. This
> is however wrong if the source and destination bios are against
> different block devices because struct blkcg_gq is different for each
> bdev-blkcg pair. This will result in IOs being accounted (and throttled
> as a result) multiple times against the same device (src bdev) while
> throttling of the other device (dst bdev) is ignored. In case of BFQ the
> inconsistency can even result in crashes in bfq_bic_update_cgroup().
> Fix the problem by looking up correct blkcg_gq for the cloned bio.
> 
> Reported-by: Logan Gunthorpe <logang@deltatee.com>
> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> Fixes: d92c370a16cb ("block: really clone the block cgroup in bio_clone_blkg_association")
> CC: stable@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20220602081242.7731-1-jack@suse.cz
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-cgroup.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> This patch should be a backport for 5.15, 5.17, and 5.18 stable branches.

Now queued up, thanks.

greg k-h
