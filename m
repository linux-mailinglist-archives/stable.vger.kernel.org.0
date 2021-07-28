Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA2B3D94F5
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 20:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhG1SFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 14:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhG1SFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 14:05:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F15C60EB9;
        Wed, 28 Jul 2021 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627495513;
        bh=eZ+hxUAJISyL9CVvEcR/4RSsc0JO+QZFpy96V90ZR5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JWeXhwoXio9mFlRUG/PcGJdKFpNMCmv2KF3WUehnmKRjsLak4/Bxy5qnE17xVhhIk
         n7MkrkcA6sQuFN5tLYIs2ON/ViH4YyERVspb2BQ5yckjR7Ky72B+8Egz1NAu0QaMFp
         e2t7BYhShaMd4+xAqWWRduOr5qBudezuYqjlxWZs=
Date:   Wed, 28 Jul 2021 20:05:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 4.9 2/2] tipc: Fix backport of
 b77413446408fdd256599daf00d5be72b5f3e7c6
Message-ID: <YQGcVymPkS6+HZm3@kroah.com>
References: <20210727225650.726875-1-nathan@kernel.org>
 <20210727225650.726875-2-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727225650.726875-2-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 03:56:50PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> net/tipc/link.c:896:23: warning: variable 'hdr' is uninitialized when
> used here [-Wuninitialized]
>         imp = msg_importance(hdr);
>                              ^~~
> net/tipc/link.c:890:22: note: initialize the variable 'hdr' to silence
> this warning
>         struct tipc_msg *hdr;
>                             ^
>                              = NULL
> 1 warning generated.
> 
> The backport of commit b77413446408 ("tipc: fix NULL deref in
> tipc_link_xmit()") to 4.9 as commit 310014f572a5 ("tipc: fix NULL deref
> in tipc_link_xmit()") added the hdr initialization above the
> 
>     if (unlikely(msg_size(hdr) > mtu)) {
> 
> like in the upstream commit; however, in 4.9, that check is below imp's
> first use because commit 365ad353c256 ("tipc: reduce risk of user
> starvation during link congestion") is not present. This results in hdr
> being used uninitialized.
> 
> Fix this by moving hdr's initialization before imp and after the if
> check like the original backport did.
> 
> Cc: Hoang Le <hoang.h.le@dektech.com.au>
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Fixes: 310014f572a5 ("tipc: fix NULL deref in tipc_link_xmit()")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  net/tipc/link.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/tipc/link.c b/net/tipc/link.c
> index 06327f78f203..6fc2fa75503d 100644
> --- a/net/tipc/link.c
> +++ b/net/tipc/link.c
> @@ -893,6 +893,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
>  	if (pkt_cnt <= 0)
>  		return 0;
>  
> +	hdr = buf_msg(skb_peek(list));
>  	imp = msg_importance(hdr);
>  	/* Match msg importance against this and all higher backlog limits: */
>  	if (!skb_queue_empty(backlogq)) {
> @@ -902,7 +903,6 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
>  		}
>  	}
>  
> -	hdr = buf_msg(skb_peek(list));
>  	if (unlikely(msg_size(hdr) > mtu)) {
>  		skb_queue_purge(list);
>  		return -EMSGSIZE;
> -- 
> 2.32.0.264.g75ae10bc75
> 

Thanks for these, now both queued up.

greg k-h
