Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4F639EA5E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 01:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhFGXud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 19:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhFGXud (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 19:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D21660E0B;
        Mon,  7 Jun 2021 23:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623109721;
        bh=v4XGwm1bFkqdysT1pXCIPTptFnI6B+Bk7EfjNiRUQuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SposmXyYh4UeoO+ia4kd+yHm1tkWD+hb4iWpzX2pc8+0lF10BdFLPeThWQ+dFp50x
         62akqtNA9BBGxwGizt/fxls3iSS6VrdsNc9yjylYnEG49bLHLrhePtvu7XGj0QwpaQ
         thH/0X6VHKW/xTWxFJ5BMHMZt0d+tXa4X2s/we7lm3tmomdxcqAW67ILtR+r4JOcYu
         SYo/TQ+rB5X/XDoCg0wwd8aYwTn6FOH1GtfqeKtb1lh2nfMJKDPYa+36JTB4SKTmiY
         DEfeP8uIxGhBjNi8WhIPwjz8WE+p1CnhdjZY5qkXad/uesBZUk/28KowIxOlrySh8c
         FDU2n4fynhalg==
Date:   Mon, 7 Jun 2021 19:48:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org, fw@strlen.de,
        pablo@netfilter.org
Subject: Re: 4.19 queue: netfilter: conntrack: unregister ipv4 sockopts on
 error unwind
Message-ID: <YL6wWOHYzBXjNTpD@sashalap>
References: <20210607223854.GA12130@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210607223854.GA12130@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 12:38:54AM +0200, Pavel Machek wrote:
>Hi!
>
>That patch is wrong for 4.19. Wrong version is 066585c43 in stable
>queue.
>
>    netfilter: conntrack: unregister ipv4 sockopts on error unwind
>
>    [ Upstream commit 22cbdbcfb61acc78d5fc21ebb13ccc0d7e29f793 ]
>
>    When ipv6 sockopt register fails, the ipv4 one needs to be
>    removed.
>
>...
>
>+++ b/net/netfilter/nf_conntrack_proto.c
>@@ -962,7 +962,7 @@ int nf_conntrack_proto_init(void)
> nf_unregister_sockopt(&so_getorigdst);
> #if IS_ENABLED(CONFIG_IPV6)
>cleanup_sockopt:
> -       nf_unregister_sockopt(&so_getorigdst6);
> +       nf_unregister_sockopt(&so_getorigdst);
> #endif
> return ret;
>
>Note the context. cleanup_sockopt2: needs to do
>nf_unregister_sockopt(&so_getorigdst6);, otherwise we end up
>unregistering the same pointer twice.

Good catch! I've dropped it from 4.19, the rest of the trees look ok.

-- 
Thanks,
Sasha
