Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1F6D7B28
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbjDELXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbjDELXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9E459D1;
        Wed,  5 Apr 2023 04:23:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC2463C54;
        Wed,  5 Apr 2023 11:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04193C433D2;
        Wed,  5 Apr 2023 11:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680693785;
        bh=gDUUhfjPhn4XPOrIvw2EMvXLAG1GTVGNJXbK0+5TDNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rVa9heXB1eA342juTZovSTdnzHubWyo1h5kIQ53SIguHSxzt5ZIqhbkEp+IzcTiaZ
         ne5xnwRo9jqJX6+d869rPjNoKrvmDLZiCkY+vZqCgzQwRW+1HF/T505o15bY7FlmRL
         +F2w1dqrtV21ogA9v8UpNyXAWJwWOOuyCpPzOf/o=
Date:   Wed, 5 Apr 2023 13:23:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shaun Tancheff <shaun.tancheff@gmail.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Shaun Tancheff <shaun.tancheff@hpe.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg-v1: Enable setting memory min, low, high
Message-ID: <2023040529-commodore-humongous-47c3@gregkh>
References: <20230405110107.127156-1-shaun.tancheff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405110107.127156-1-shaun.tancheff@gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 06:01:07PM +0700, Shaun Tancheff wrote:
> From: Shaun Tancheff <shaun.tancheff@hpe.com>
> 
> For users that are unable to update to memcg-v2 this
> provides a method where memcg-v1 can more effectively
> apply enough memory pressure to effectively throttle
> filesystem I/O or otherwise minimize being memcg oom
> killed at the expense of reduced performance.
> 
> This patch extends the memcg-v1 legacy sysfs entries
> with:
>     limit_in_bytes.min, limit_in_bytes.low and
>     limit_in_bytes.high
> Since old software will need to be updated to take
> advantage of the new files a secondary method
> of setting min, low and high based on a percentage
> of the limit is also provided. The percentages
> are determined by module parameters.
> 
> The available module parameters can be set at
> kernel boot time, for example:
>    memcontrol.memcg_min=10
>    memcontrol.memcg_low=30
>    memcontrol.memcg_high=80
> 
> Would set min to 10%, low to 30% and high to 80% of
> the value written to:
>   /sys/fs/cgroup/memory/<grp>/memory.limit_in_bytes
> 
> Signed-off-by: Shaun Tancheff <shaun.tancheff@hpe.com>
> ---
> v0: Initial hard coded limits by percent.
> v1: Added sysfs access and module parameters for percent values to enable
> v2: Fix 32-bit, remove need for missing __udivdi3
>  mm/memcontrol.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2eee092f8f11..3cf8386f4f45 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -73,6 +73,18 @@
>  
>  #include <trace/events/vmscan.h>
>  
> +static unsigned int memcg_v1_min_default_percent;
> +module_param_named(memcg_min, memcg_v1_min_default_percent, uint, 0600);
> +MODULE_PARM_DESC(memcg_min, "memcg v1 min default percent");
> +
> +static unsigned int memcg_v1_low_default_percent;
> +module_param_named(memcg_low, memcg_v1_low_default_percent, uint, 0600);
> +MODULE_PARM_DESC(memcg_low, "memcg v1 low default percent");
> +
> +static unsigned int memcg_v1_high_default_percent;
> +module_param_named(memcg_high, memcg_v1_high_default_percent, uint, 0600);
> +MODULE_PARM_DESC(memcg_high, "memcg v1 high default percent");

This is not the 1990's, why are you using module parameters for this?
And this isn't a module, so why use module options, how are you supposed
to set them?

And you didn't document them anywhere?

Also, why is this cc: stable?

thanks,

greg k-h
