Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5AD318889
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhBKKsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:48:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhBKKp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 05:45:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD75B64E2E;
        Thu, 11 Feb 2021 10:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613040316;
        bh=VtpwSJuu8vZwtLlMpm1Il8/iSK9AOKEm7hw18O46ScI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JRnu+eBrz3TXBThr/tpcC+SOO5NaB+5/UMM7UMFM6yhoraDD/6NsX8ULTuEtIE/Gy
         wrD3OakGvpm5GjmfeWpCtXGuJykI+tNRG7mvHvJkz/K+qwNB73m8NRIwNG0gefxYtS
         Sl3QuriOPheMniu3zkMX+1qJZU3/ao91t6DdBquA=
Date:   Thu, 11 Feb 2021 11:45:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [4.14] Failing selftest timer/adjtick
Message-ID: <YCUKuNsIvPcaMM1e@kroah.com>
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com>
 <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
 <20210210131916.GC1903164@localhost>
 <897e03f9-4062-d34f-0445-ff4f047ccd13@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <897e03f9-4062-d34f-0445-ff4f047ccd13@jv-coder.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 11:33:05AM +0100, Joerg Vehlow wrote:
> Hi Miroslav,
> 
> On 2/10/2021 2:19 PM, Miroslav Lichvar wrote:
> > That patch cannot be applied alone. It would break the timekeeping in
> > not so obvious ways as there will be unexpected sources of the NTP
> > tracking error. IIRC, at least the following changes would need to be
> > included with it. There may be others.
> > 
> > c2cda2a5bda9 ("timekeeping/ntp: Don't align NTP frequency adjustments to ticks")
> > aea3706cfc4d ("timekeeping: Remove CONFIG_GENERIC_TIME_VSYSCALL_OLD")
> > d4d1fc61eb38 ("ia64: Update fsyscall gettime to use modern vsyscall_update")
> > 
> > My suggestion for a fix would be to increase the limit in the failing
> > test.
> Thanks, that's what I expected. But I still wonder why the test is failing
> almost 100% of time for me on qemu-arm64 (running on x86). Is this a
> regression in 4.14, that was working at some point or was it never tested on
> arm?

Does it work on a real system?  That's the proper test...
