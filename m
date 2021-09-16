Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A290F40D59C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 11:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhIPJNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 05:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhIPJNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 05:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCACD61108;
        Thu, 16 Sep 2021 09:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631783539;
        bh=jQYIRqs2aOJnPuLh7/xWhgGZj1/WGuhO3shpVt0IrBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ojr0p/6iFYpEBqQJcGzCy250PQmsyBHJ92oSUn4Sfp41wMkIGqBFvfzJKP9U77omi
         3fM63VG7ziMoUiGnw919DNrgVbP4qq4YKoHEX9Y4xLn4nlXXw0IVBD10Puf88TukD6
         HO2LWeZiETDE3nUbkl71Ae54P0F2R1CwR+Iw6ywk=
Date:   Thu, 16 Sep 2021 11:12:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
Message-ID: <YUMKcSemcTHcIlXR@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 09:00:32PM +0200, Arnd Bergmann wrote:
> On Tue, Sep 14, 2021 at 1:22 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >  /*
> >   * Limits for settimeofday():
> > @@ -124,10 +126,13 @@ static inline bool timespec64_valid_sett
> >   */
> >  static inline s64 timespec64_to_ns(const struct timespec64 *ts)
> >  {
> > -       /* Prevent multiplication overflow */
> > -       if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
> > +       /* Prevent multiplication overflow / underflow */
> > +       if (ts->tv_sec >= KTIME_SEC_MAX)
> >                 return KTIME_MAX;
> >
> > +       if (ts->tv_sec <= KTIME_SEC_MIN)
> > +               return KTIME_MIN;
> > +
> 
> I just saw this get merged for the stable kernels, and had not seen this when
> Thomas originally merged it.
> 
> I can see how this helps the ptp_clock_adjtime() users, but I just
> double-checked
> what other callers exist, and I think it introduces a regression in setitimer(),
> which does
> 
>         nval = timespec64_to_ns(&value->it_value);
>         ninterval = timespec64_to_ns(&value->it_interval);
> 
> without any further range checking that I could find. Setting timers
> with negative intervals sounds like a bad idea, and interpreting negative
> it_value as a past time instead of KTIME_SEC_MAX sounds like an
> unintended interface change.
> 
> I haven't done any proper analysis of the changes, so maybe it's all
> good, but I think we need to double-check this, and possibly revert
> it from the stable kernels until a final conclusion.

I will revert it now from all stable kernels, thanks.

greg k-h
