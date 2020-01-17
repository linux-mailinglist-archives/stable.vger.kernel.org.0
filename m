Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2AD140890
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 12:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgAQLBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 06:01:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:56288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgAQLBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 06:01:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 07982ADAD;
        Fri, 17 Jan 2020 11:00:59 +0000 (UTC)
Subject: Re: [PATCH] xen/balloon: Support xend-based toolstack take two
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
References: <20200116170004.14373-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <c29c92e3-eb20-7e0a-0174-ef72398b0998@suse.com>
Date:   Fri, 17 Jan 2020 12:01:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200116170004.14373-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.01.2020 18:00, Juergen Gross wrote:
> Commit 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
> tried to fix a regression with running on rather ancient Xen versions.
> Unfortunately the fix was based on the assumption that xend would
> just use another Xenstore node, but in reality only some downstream
> versions of xend are doing that. The upstream xend does not write
> that Xenstore node at all, so the problem must be fixed in another
> way.
> 
> The easiest way to achieve that is to fall back to the behavior before
> commit 5266b8e4445c ("xen: fix booting ballooned down hvm guest")
> in case the static memory maximum can't be read.

I could use some help here: Prior to said commit there was

	target_diff = new_target - balloon_stats.target_pages;


Which is, afaict, ...

> --- a/drivers/xen/xen-balloon.c
> +++ b/drivers/xen/xen-balloon.c
> @@ -94,7 +94,7 @@ static void watch_target(struct xenbus_watch *watch,
>  				  "%llu", &static_max) == 1))
>  			static_max >>= PAGE_SHIFT - 10;
>  		else
> -			static_max = new_target;
> +			static_max = balloon_stats.current_pages;
>  
>  		target_diff = (xen_pv_domain() || xen_initial_domain()) ? 0
>  				: static_max - balloon_stats.target_pages;

... what the code does before your change. Afaict there was
never a use of balloon_stats.current_pages in this function.

Jan
