Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA4D5588C1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiFWT1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiFWT1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:27:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2987F20BD3;
        Thu, 23 Jun 2022 11:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03D6F6202D;
        Thu, 23 Jun 2022 18:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2738C341C6;
        Thu, 23 Jun 2022 18:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656010384;
        bh=uKIRvyg7pjGx9VZRIlqn21I3/K3/JUHP9hWujvj8T8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RL6a3wqo7WvdfrWlenL1jjEYetWhAUljOhKZV4Q1henzewDVuCy4RV+NlbhSV8tZV
         KCvxk/i/UJO52K7vr0qcqTp5t/EKESrPPyulJIRhR4cNevq7ozSrTyebtOEN1uOXjc
         Y8UqDOqcuKfVKlqV4Xu4dmRzn822z0ghDT3FvmORkcXad1H71/YeFrDH2ODP2Qv3wV
         7gH7EmnVQwWWEfQvFKx/NJbFsfTEgxI1i3+NtkVqorlbAN8HI1ObqEQByihSOk1z8A
         wpg+xT/HDmAGHH951uvRe/RJTPLI7ywlpILAOeMZTAfg4x1vRzHlI/PgesB/OAlNYx
         t8GU0r1FeBGag==
Date:   Thu, 23 Jun 2022 11:53:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] timekeeping: contribute wall clock to rng on time
 change
Message-ID: <YrS2jtI+mt99AOz1@sol.localdomain>
References: <CAHmME9qy0N3BvDo-0jkS+om0N3Yk--ZAyKvSKshzDBzvuoP+UA@mail.gmail.com>
 <20220623180555.1345684-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623180555.1345684-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 08:05:55PM +0200, Jason A. Donenfeld wrote:
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
>  kernel/time/timekeeping.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 8e4b3c32fcf9..89b894b3ede8 100644
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
> @@ -1331,6 +1332,8 @@ int do_settimeofday64(const struct timespec64 *ts)
>  		goto out;
>  	}
>  
> +	add_device_randomness(&ts, sizeof(ts));
> +
>  	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));

This is now nested inside:

	raw_spin_lock_irqsave(&timekeeper_lock, flags);
	write_seqcount_begin(&tk_core.seq);

Could there be a deadlock if random_get_entropy() in add_device_randomness()
falls back to reading the monotonic clock?

- Eric
