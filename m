Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48046A53D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 19:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347958AbhLFS7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 13:59:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39300 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbhLFS7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 13:59:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EC6CCE17A9;
        Mon,  6 Dec 2021 18:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D600C341C2;
        Mon,  6 Dec 2021 18:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638816969;
        bh=N7zrzVL9603bCZxw3WUkqNCEttXiBcbQdkgUWW59B3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7TpaNVaCplJo0xoyl0mpFw1eVr/98HGOJYNnW9qhAqiRV7xNYqdiSkwpGZ4jjlMn
         1AuUfkIxaqsrwmRE8SAKel0YifubmnaH6RVnlhqtc/bMtXuj2xoZiTImRaQrNiOjam
         M7c8TL0H5GaltRn/A3U8j36Wyvm7CFlruszSI6g75u06/5EmIcqUxR9cy/exdAZv1q
         xPdSXJ9IzNvp5eB37PgI12bA9LALWmRVjXQnj3BxjPCfALpZI6LDyaRoWrL1RtpuMI
         MW91TdP/TLS4hNN2Ly6I1FSJN2iwb6U245uDMgfFmo36fiiPUom1zRt5MhZQ9k/aek
         gXdlMJsH/lx5g==
Date:   Mon, 6 Dec 2021 10:56:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] aio: keep poll requests on waitqueue until completed
Message-ID: <Ya5cx3EcU5SgV9dP@gmail.com>
References: <20211204002301.116139-1-ebiggers@kernel.org>
 <20211204002301.116139-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211204002301.116139-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 03, 2021 at 04:23:00PM -0800, Eric Biggers wrote:
> @@ -1680,20 +1690,24 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>  	if (mask && !(mask & req->events))
>  		return 0;
>  
> -	list_del_init(&req->wait.entry);
> -
> +	/*
> +	 * Complete the iocb inline if possible.  This requires that two
> +	 * conditions be met:
> +	 *   1. The event mask must have been passed.  If a regular wakeup was
> +	 *	done instead, then mask == 0 and we have to call vfs_poll() to
> +	 *	get the events, so inline completion isn't possible.
> +	 *   2. ctx_lock must not be busy.  We have to use trylock because we
> +	 *      already hold the waitqueue lock, so this inverts the normal
> +	 *      locking order.  Use irqsave/irqrestore because not all
> +	 *      filesystems (e.g. fuse) call this function with IRQs disabled,
> +	 *      yet IRQs have to be disabled before ctx_lock is obtained.
> +	 */
>  	if (mask && spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
>  		struct kioctx *ctx = iocb->ki_ctx;
>  
> -		/*
> -		 * Try to complete the iocb inline if we can. Use
> -		 * irqsave/irqrestore because not all filesystems (e.g. fuse)
> -		 * call this function with IRQs disabled and because IRQs
> -		 * have to be disabled before ctx_lock is obtained.
> -		 */
> +		list_del_init(&req->wait.entry);
>  		list_del(&iocb->ki_list);
>  		iocb->ki_res.res = mangle_poll(mask);
> -		req->done = true;
>  		if (iocb->ki_eventfd && eventfd_signal_allowed()) {
>  			iocb = NULL;
>  			INIT_WORK(&req->work, aio_poll_put_work);
> @@ -1703,7 +1717,16 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>  		if (iocb)
>  			iocb_put(iocb);
>  	} else {

I think I missed something here.  Now that the request is left on the waitqueue,
there needs to be a third condition for completing the iocb inline: the
completion work must not have already been scheduled.

- Eric
