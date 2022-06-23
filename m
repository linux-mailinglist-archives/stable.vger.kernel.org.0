Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548785588ED
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiFWTdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiFWTcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BA9993F7;
        Thu, 23 Jun 2022 12:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C088FB824EF;
        Thu, 23 Jun 2022 19:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EBEC341C6;
        Thu, 23 Jun 2022 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656011417;
        bh=hdPxiwoRttBIzWEIb6YpO8NBXxG6GrweSOsSURG0ZAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQc3kJxeKCboJwgvhir6MFPrFAP/UwTApTO+r4Iz5mu/lo6BcV5hixPq0C5mcrxkT
         XrscgWjih7BqhafEmJlihi/V/zlMk2i+qy/Ix3J82OYbCsFHly4KotpiatoJwqoyTb
         XjSGvu86PWX1j1Q/n9odsbQSCYsB0UIkGHl5T87lP10ksrUPzflDj64AoNs7UZE/Wh
         rJdRuszu4AQ5uzljXyxE01I9pwJ9+lv5pdtJGwXRRN89U4L64+IlrTzOCEUceKpGwA
         lU4Xz4U1YwmpUI1qZ7WlA8HhbUqXrSh/aog/H3/ZYs1c3GTm/0wUQ6szjJ7ICJ00yd
         umy6uAAFmryvg==
Date:   Thu, 23 Jun 2022 12:10:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] timekeeping: contribute wall clock to rng on time
 change
Message-ID: <YrS6l38HDhqJIYS9@sol.localdomain>
References: <CAHmME9rbOt14sHkPVgb7yysYSXk-eiwzkp9PzPnyO_9HyrmQ3Q@mail.gmail.com>
 <20220623190014.1355583-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623190014.1355583-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 09:00:14PM +0200, Jason A. Donenfeld wrote:
> The rng's random_init() function contributes the real time to the rng at
> boot time, so that events can at least start in relation to something
> particular in the real world. But this clock might not yet be set that
> point in boot, so nothing is contributed. In addition, the relation
> between minor clock changes from, say, NTP, and the cycle counter is
> potentially useful entropic data.
> 
> This commit addresses this by mixing in a time stamp on calls to
> settimeofday and adjtimex. No entropy is credited in doing so, so it
> doesn't make initialization faster, but it is still useful input to
> have.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  kernel/time/timekeeping.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 8e4b3c32fcf9..49ee8ef16544 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -23,6 +23,7 @@
>  #include <linux/pvclock_gtod.h>
>  #include <linux/compiler.h>
>  #include <linux/audit.h>
> +#include <linux/random.h>
>  
>  #include "tick-internal.h"
>  #include "ntp_internal.h"
> @@ -1343,8 +1344,10 @@ int do_settimeofday64(const struct timespec64 *ts)
>  	/* Signal hrtimers about time change */
>  	clock_was_set(CLOCK_SET_WALL);
>  
> -	if (!ret)
> +	if (!ret) {
>  		audit_tk_injoffset(ts_delta);
> +		add_device_randomness(&ts, sizeof(ts));
> +	}

It should be:

add_device_randomness(ts, sizeof(*ts));

- Eric
