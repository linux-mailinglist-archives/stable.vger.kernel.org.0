Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74F4223672
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 10:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgGQICN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 04:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727853AbgGQICI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 04:02:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4DB20704;
        Fri, 17 Jul 2020 08:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594972927;
        bh=pEmoznDf9gF70xYZ0kn/H4fgKmERVzSDzcKBW/BAJt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3CS3Xz68p3vMXm1ko7gqCHBUTMYtSJ2y3amw8cf43q4XBPBdLTbXiMR6nm5+B+xs
         zuCl6k3g9Tms9B+8ir1h39MMAfWw8FwF4awBmUlf5gF7g7HksMyaMw+gEa8T3vR+mu
         i7UWlXt9CTD11QJ7cTGnSTHWElXfzXmw9tvfeW+0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jwLJm-00CYk1-7g; Fri, 17 Jul 2020 09:02:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 17 Jul 2020 09:02:06 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, arnd@arndb.de, sashal@kernel.org,
        naresh.kamboju@linaro.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [Stable-5.4][PATCH 0/3] arm64: Allow the compat vdso to be
 disabled at runtime
In-Reply-To: <20200716115813.GB1668009@kroah.com>
References: <20200715125614.3240269-1-maz@kernel.org>
 <20200716115813.GB1668009@kroah.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <c9f5b2b0512067b128dd5c98acc5db7e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, stable@vger.kernel.org, arnd@arndb.de, sashal@kernel.org, naresh.kamboju@linaro.org, mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, daniel.lezcano@linaro.org, vincenzo.frascino@arm.com, linux@arm.linux.org.uk, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2020-07-16 12:58, Greg KH wrote:
> On Wed, Jul 15, 2020 at 01:56:11PM +0100, Marc Zyngier wrote:
>> This is a backport of the series that recently went into 5.8. Note
>> that the first patch is more a complete rewriting than a backport, as
>> the vdso implementation in 5.4 doesn't have much in common with
>> mainline. This affects the 32bit arch code in a benign way.
>> 
>> It has seen very little testing, as I don't have the HW that triggers
>> this issue. I have run it in VMs by faking the CPU MIDR, and nothing
>> caught fire. Famous last words.
> 
> These are also needed in 5.7.y, right?  If so, I need that series 
> before
> I can take this one as we don't want people moving to a newer kernel 
> and
> suffer regressions :(

The original mainline changes:

4b661d6133c5 arm64: arch_timer: Disable the compat vdso for cores 
affected by ARM64_WORKAROUND_1418040
c1fbec4ac0d7 arm64: arch_timer: Allow an workaround descriptor to 
disable compat vdso
97884ca8c292 arm64: Introduce a way to disable the 32bit vdso

do apply cleanly to stable-5.7. Do you want me to resend them 
separately,
or will you pick the patches directly from mainline?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
