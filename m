Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C17714C2
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfGWJPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:15:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37071 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729111AbfGWJPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:15:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so18825658pfa.4
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 02:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fkSxgqWnfvZd2cjTyVDsfDKJ19ZkRmGA1pV7ZfRj0rw=;
        b=LR3qimyh3XF2uYyuQtngaGPLFqSqqg9O4NhCfdSjR37DxYIMgAAdwtAG2Riqs+o9Hz
         pfESUB7ttcZ4wZKT6D+9gw/aDDFbZ0XiRsgR59njw1yIGJifQIaU6lcenoVqDtGR4sW9
         ankV0TAOpdNKQpEFTjaHYaiHAm0t6bWSXW1cjtNjWsNqYtVeCEn1qlSPGe7I6p2M7Pac
         DegOaHz4KWMQPowIp8fj/GULDemiIUwXZ0xGql1XUhAMsQKuLJ77pMv+wwxTdreey74y
         DU5rcREeQ3OPHbP6AWcm3dzh87xDh4Iw3KQvcfC+4Bj3owNwRf8p0JKaBMg2tky/olLC
         zJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fkSxgqWnfvZd2cjTyVDsfDKJ19ZkRmGA1pV7ZfRj0rw=;
        b=UT1JA9BBMfQxGhJdqMwqBTW+ZTP4dkNshdKYL7ZDynBT+mcg5a7lroZHvTudW6JpiO
         /wRlP5dW8Wq94VLMyqqB0ABVGwgpD4zpJZNZNCVQVP6L+AKSpKM59ZLJ6rd3lD+47sR+
         M/TnkxwqHE/hBC5MZ0i2lmlkQ7U/Jzb8WBxG9BhkptHPSc3hCyRdcRsIKHoFj7io/ZKX
         sL4MJIlliagJFwRbR7Lx4ZjFSk4v+pRp++v9ON0kCy6rpuUrgGSlzyVjgb/OHqElsko0
         dHR7IvgaWvsSZ4uPUkQY8+kdDJHojZPtLDKRaKJ7C7S+XAxwle3YH4fHFkQZfMZzM2pl
         liDQ==
X-Gm-Message-State: APjAAAXOyPlvSEnAiHz6l+ylNsaus0PcbrBRf2Zy3kFzIs+IMwFKNBx8
        aX9N77+K4wlsGmidVKN+vi3bBw==
X-Google-Smtp-Source: APXvYqyhC1JGujJhd/15VMC3f2eJlP5NjZ3v6gT+3Czho+EDkdgkK8r3pHDreHENwZeCQkitpnCM1w==
X-Received: by 2002:a62:5c47:: with SMTP id q68mr4857251pfb.205.1563873354211;
        Tue, 23 Jul 2019 02:15:54 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id v18sm35637116pgl.87.2019.07.23.02.15.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 02:15:53 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:45:51 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     'Rafael Wysocki' <rjw@rjwysocki.net>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        linux-pm@vger.kernel.org,
        'Vincent Guittot' <vincent.guittot@linaro.org>,
        joel@joelfernandes.org, "'v4 . 18+'" <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits
 change
Message-ID: <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
 <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
 <001201d54125$a6a82350$f3f869f0$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201d54125$a6a82350$f3f869f0$@net>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23-07-19, 00:10, Doug Smythies wrote:
> On 2019.07.21 23:52 Viresh Kumar wrote:
> 
> > To avoid reducing the frequency of a CPU prematurely, we skip reducing
> > the frequency if the CPU had been busy recently.
> > 
> > This should not be done when the limits of the policy are changed, for
> > example due to thermal throttling. We should always get the frequency
> > within limits as soon as possible.
> >
> > Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
> > Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
> > Reported-by: Doug Smythies <doug.smythies@gmail.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > @Doug: Please try this patch, it must fix the issue you reported.
> 
> It fixes the driver = acpi-cpufreq ; governor = schedutil test case
> It does not fix the driver = intel_cpufreq ; governor = schedutil test case
> 
> I have checked my results twice, but will check again in the day or two.

The patch you tried to revert wasn't doing any driver specific stuff
but only schedutil. If that revert fixes your issue with both the
drivers, then this patch should do it as well.

I am clueless now on what can go wrong with intel_cpufreq driver with
schedutil now.

Though there is one difference between intel_cpufreq and acpi_cpufreq,
intel_cpufreq has fast_switch_possible=true and so it uses slightly
different path in schedutil. I tried to look from that perspective as
well but couldn't find anything wrong.

If you still find intel_cpufreq to be broken, even with this patch,
please set fast_switch_possible=false instead of true in
__intel_pstate_cpu_init() and try tests again. That shall make it very
much similar to acpi-cpufreq driver.

-- 
viresh
