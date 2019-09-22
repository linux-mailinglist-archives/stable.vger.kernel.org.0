Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3ABBABA1
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 22:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfIVUZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 16:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbfIVUZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 16:25:55 -0400
Received: from localhost (unknown [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC8D20644;
        Sun, 22 Sep 2019 20:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569183954;
        bh=lnqz5lNN8HlaQXC31DrIw2TCWk6wgsRyvy3CZVgtWTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ibZz2JCL3uR8hlgXpw/VtXngL3ZrNRKUQ/xD+kGXti6yM7K8SIqoKHZLUniGtRqx9
         FSJ8FFs6FHIdmAkeiPSbOVm22um6wDn5KwDLSfXqcSWOBTJLUtclqjkTYNAAjzosSC
         4gB9gziS74ERqlQ6GxTg8vjqFoXQyymEDLrCxUJM=
Date:   Sun, 22 Sep 2019 22:25:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Austin Kim <austindh.kim@gmail.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Travis <mike.travis@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russ Anderson <russ.anderson@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Thomas Gleixner <tglx@linutronix.de>, allison@lohutok.net,
        andy@infradead.org, armijn@tjaldur.nl, bp@alien8.de,
        dvhart@infradead.org, hpa@zytor.com, kjlu@umn.edu,
        platform-driver-x86@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.3 169/203] x86/platform/uv: Fix kmalloc() NULL
 check routine
Message-ID: <20190922202544.GA2719513@kroah.com>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-169-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922184350.30563-169-sashal@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 22, 2019 at 02:43:15PM -0400, Sasha Levin wrote:
> From: Austin Kim <austindh.kim@gmail.com>
> 
> [ Upstream commit 864b23f0169d5bff677e8443a7a90dfd6b090afc ]
> 
> The result of kmalloc() should have been checked ahead of below statement:
> 
> 	pqp = (struct bau_pq_entry *)vp;
> 
> Move BUG_ON(!vp) before above statement.
> 
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> Cc: Hedi Berriche <hedi.berriche@hpe.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mike Travis <mike.travis@hpe.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Russ Anderson <russ.anderson@hpe.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: allison@lohutok.net
> Cc: andy@infradead.org
> Cc: armijn@tjaldur.nl
> Cc: bp@alien8.de
> Cc: dvhart@infradead.org
> Cc: gregkh@linuxfoundation.org
> Cc: hpa@zytor.com
> Cc: kjlu@umn.edu
> Cc: platform-driver-x86@vger.kernel.org
> Link: https://lkml.kernel.org/r/20190905232951.GA28779@LGEARND20B15
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/platform/uv/tlb_uv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
> index 20c389a91b803..5f0a96bf27a1f 100644
> --- a/arch/x86/platform/uv/tlb_uv.c
> +++ b/arch/x86/platform/uv/tlb_uv.c
> @@ -1804,9 +1804,9 @@ static void pq_init(int node, int pnode)
>  
>  	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_pq_entry);
>  	vp = kmalloc_node(plsize, GFP_KERNEL, node);
> -	pqp = (struct bau_pq_entry *)vp;
> -	BUG_ON(!pqp);
> +	BUG_ON(!vp);
>  
> +	pqp = (struct bau_pq_entry *)vp;
>  	cp = (char *)pqp + 31;
>  	pqp = (struct bau_pq_entry *)(((unsigned long)cp >> 5) << 5);
>  

How did this even get merged in the first place?  I thought a number of
us complained about it.

This isn't any change in code, and the original is just fine, the author
didn't realize how C works :(

Please drop this.

thanks,

greg k-h
