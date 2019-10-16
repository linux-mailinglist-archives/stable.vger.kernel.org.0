Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D72AD96B6
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404352AbfJPQN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 12:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404056AbfJPQN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 12:13:26 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 351642067D;
        Wed, 16 Oct 2019 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571242406;
        bh=3QqlymOq8IiOXuOkO6/urqcLgAXGbkapHVtiBwlHlCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCi9WBaPU0tPTammkIo2q+OlFlu5aG5vJ5VUV5FSi9wRu5NvMxV3h2MTtd/Y0wesU
         xI5LqLggZzT1ZNBy6kdrKPN3XL43Tiixbnqx2z5msCjKO+Ho8JtSyKTewIW9hKsonw
         x//m/EE5uW+kcXo2fHww5U70cXG8DB/4LNtZTA6A=
Date:   Wed, 16 Oct 2019 09:13:20 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     axboe@kernel.dk, stefanha@redhat.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: only flush workqueues on
 fileset removal" failed to apply to 5.3-stable tree
Message-ID: <20191016161320.GC441788@kroah.com>
References: <1571241883130167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571241883130167@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 09:04:43AM -0700, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.3-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From 8a99734081775c012a4a6c442fdef0379fe52bdf Mon Sep 17 00:00:00 2001
> From: Jens Axboe <axboe@kernel.dk>
> Date: Wed, 9 Oct 2019 14:40:13 -0600
> Subject: [PATCH] io_uring: only flush workqueues on fileset removal
> 
> We should not remove the workqueue, we just need to ensure that the
> workqueues are synced. The workqueues are torn down on ctx removal.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6b06314c47e1 ("io_uring: add file set registration")
> Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ceb3497bdd2a..2c44648217bd 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2866,8 +2866,12 @@ static void io_finish_async(struct io_ring_ctx *ctx)
>  static void io_destruct_skb(struct sk_buff *skb)
>  {
>  	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ctx->sqo_wq); i++)
> +		if (ctx->sqo_wq[i])
> +			flush_workqueue(ctx->sqo_wq[i]);
>  
> -	io_finish_async(ctx);
>  	unix_destruct_scm(skb);
>  }
>  
> 

This fails to build as sqo_wq is a pointer in 5.3, not an arrary.
Backporting that array change feels "big" for 5.3, is that needed here,
or can this be fixed differently?

thanks,

greg k-h
