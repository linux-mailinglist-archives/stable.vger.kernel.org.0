Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DEC5587AC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiFWSg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiFWSgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:36:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22BF237CD;
        Thu, 23 Jun 2022 10:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F0A1B824B4;
        Thu, 23 Jun 2022 17:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D74C3411B;
        Thu, 23 Jun 2022 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656005951;
        bh=PXxXykZcJt2J7liqAGVgScadQ39TBjThf1Z3m0Lbwok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gYjpWR77iWUnBU5ZNYjt5N19atC1ieM5uimCVtMbm4yaiMdtDt/Jqz67+f9HJGebr
         FHoXXH2SEtXS+zyj7brl2CMYTRxc4ahgp+dwIEEokVjI35X+TpDEYdMtnujd/TFL9S
         NZreBTpdlDl2EG3kZgSibFd7M19TUsh0ohL3ep3OwluvnlDLhwoTDqnfn87mCkgKIj
         ut+7TPu/6zgebgPCiK/Yne9VGzgRWhIufMOqjV87pES1odUxgaoswk6/+Zwbv9wghv
         HZAF6plGd3gAgP29WE0YMlCH/9O1xdXOniEje2mQSGg0kscdTmhhnQfNUd+mS1d6u/
         N3GA22KOUc7HQ==
Date:   Thu, 23 Jun 2022 10:39:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] timekeeping: contribute wall clock to rng on time change
Message-ID: <YrSlPUhqhOosqpMH@sol.localdomain>
References: <20220623165226.1335679-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220623165226.1335679-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 06:52:26PM +0200, Jason A. Donenfeld wrote:
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

Good idea.

> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 8e4b3c32fcf9..ad55da792f13 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c

This doesn't compile:

kernel/time/timekeeping.c: In function ‘do_settimeofday64’:
kernel/time/timekeeping.c:1350:9: error: implicit declaration of function ‘add_device_randomness’ [-Werror=implicit-function-declaratio ]
 1350 |         add_device_randomness(&xt, sizeof(xt));
      |         ^~~~~~~~~~~~~~~~~~~~~

> @@ -1346,6 +1346,9 @@ int do_settimeofday64(const struct timespec64 *ts)
>  	if (!ret)
>  		audit_tk_injoffset(ts_delta);
>  
> +	ktime_get_real_ts64(&xt);
> +	add_device_randomness(&xt, sizeof(xt));
> +
>  	return ret;

Isn't the new time already available in 'ts'?  Is the call to
ktime_get_real_ts64() necessary?

>  }
>  EXPORT_SYMBOL(do_settimeofday64);
> @@ -2475,6 +2478,9 @@ int do_adjtimex(struct __kernel_timex *txc)
>  
>  	ntp_notify_cmos_timer();
>  
> +	ktime_get_real_ts64(&ts);
> +	add_device_randomness(&ts, sizeof(ts));
> +
>  	return ret;
>  }

adjtimex() actually triggers a gradual adjustment of the clock, rather than
setting it immediately.  Is there a way to mix in the target time rather than
the current time as this does?

- Eric
