Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FFC5931C4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiHOP2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiHOP2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:28:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A8F1658E
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C1F6B80F02
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 15:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F970C433C1;
        Mon, 15 Aug 2022 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660577326;
        bh=pMiWq+xzi+kledCP6nb/rZfWXGAmgQDWAY4GWJR8BqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lWnHllvcHZXujE4oWMwSFQLvgC/XnfHTbzVSG7hPKsy+Cy+ClI8Ig1FEYojfFCkl+
         cyq8zT426M5GrXCcxvHIIucID97uSUviT0RlFnpRkacLTWNZvdchgEcqEAGdN1owro
         zUAAMNbUsB2gp/6OnOpSUxVMH7PnEGTvC5uXe+pg=
Date:   Mon, 15 Aug 2022 17:28:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.19] io_uring: mem-account pbuf buckets
Message-ID: <YvpmKk+vCrWa5uyI@kroah.com>
References: <4302b28024f6cf027a305a0b8790066acefb5e73.1660574026.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4302b28024f6cf027a305a0b8790066acefb5e73.1660574026.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 03:52:38PM +0100, Pavel Begunkov wrote:
> [ upstream commit cc18cc5e82033d406f54144ad6f8092206004684 ]
> 
> Potentially, someone may create as many pbuf bucket as there are indexes
> in an xarray without any other restrictions bounding our memory usage,
> put memory needed for the buckets under memory accounting.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e8e769be9ed0..9fa702d707af 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5738,7 +5738,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
>  
>  	bl = io_buffer_get_list(ctx, p->bgid);
>  	if (unlikely(!bl)) {
> -		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
> +		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
>  		if (!bl) {
>  			ret = -ENOMEM;
>  			goto err;
> -- 
> 2.37.0
> 

Thanks for all backports, now queued up.

greg k-h
