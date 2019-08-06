Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDE182A2D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 06:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfHFEKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 00:10:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39253 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFEKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 00:10:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so37338238pls.6
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 21:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7f2EvO5gb/gF1pHUEiS10k+vqob3KzvKRDpJw7YgyDc=;
        b=kL9lyAApHjKrFWMjvVQgGntfAqj0l3ygD1PGr+eFgyPTwM7LqYSHklBRMk7LrYvQg7
         IxsJY8dERYCkTtqdFsQUeKWmxVE/N/6oYdZx0WsUSObDb228rpNFd1RNpJPfA6h+Yew+
         FHQ6nPQvkX2DcHxn4jErfSEAvZKLFpmLECvOoKAzrhmgx8TjF3dUjIqitmUXcKztOsbx
         6hslncKxYmN+9GQbaAMZcBaxxsaxYOk7mJPZeReuAJJuJ301uSx/av3H+MiD9OUL+Mwt
         HbEmy0ukS5IvRHguPdIfPF6ORQPS0k6RGVTZEgZrbsRhqiEHl86F/+Tva54B5Ldk+QyO
         FIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7f2EvO5gb/gF1pHUEiS10k+vqob3KzvKRDpJw7YgyDc=;
        b=bvaiUsvERTNx5HPZ1KCpj0QTKn5dmXgFdtj63P/vpKMIMI7u4sDNWEikdb684sYXCO
         znJnaz9ZE2gr+bcuOahptRw5dQp90pdCeJZ7TSTiKrdmiUAEMe7YmDT7ax2AcUhDzDTp
         ythOHbkZVFuRnmQk804YUht93gfuMxLcXAdZ+zcqGimBaCHocuwl8wJ24Yl8VQosY/vF
         D89zIq7UkKJBGyF/FeETwW+9GhuNKf8NDo/4whB3pcxqcobLHQMiPJ1/lt17HlLLpkD+
         xCFRMIdqnlphpLUut07ziEGrZ0sjCFHBXv5lTj6LL2Lv+tbCN5UWrZzFqGp8ki1ZsqIH
         +01Q==
X-Gm-Message-State: APjAAAVupZgqcGH3GJJ6AlZXnHA8VPilHpRw651rx1RO++8ZphF74IR9
        tZlX2VCkVJ5MH7koWrjejX2dMA==
X-Google-Smtp-Source: APXvYqwEZh6EPRtHwi5fjKhv6XjpkhMidWikuyLXVKSpwNu/hIGcVTqdrS1glwhtaKHn7A4MVlLH+A==
X-Received: by 2002:a17:902:8bc1:: with SMTP id r1mr1152698plo.42.1565064651684;
        Mon, 05 Aug 2019 21:10:51 -0700 (PDT)
Received: from localhost ([122.172.146.3])
        by smtp.gmail.com with ESMTPSA id g4sm100629374pfo.93.2019.08.05.21.10.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 21:10:50 -0700 (PDT)
Date:   Tue, 6 Aug 2019 09:40:48 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Doug Smythies <doug.smythies@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/2] cpufreq: intel_pstate: Implement ->resolve_freq()
Message-ID: <20190806041048.ksqs3l5bzsakaael@vireshk-i7>
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
 <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org>
 <CAJZ5v0iqztRWyxf1cgiAN1dK4qTGwy9raaGOx5u3tfBTGUKOng@mail.gmail.com>
 <2676200.jfxhmTd764@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2676200.jfxhmTd764@kreacher>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02-08-19, 11:28, Rafael J. Wysocki wrote:
> On Friday, August 2, 2019 11:17:55 AM CEST Rafael J. Wysocki wrote:
> > On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > >
> > > Intel pstate driver exposes min_perf_pct and max_perf_pct sysfs files,
> > > which can be used to force a limit on the min/max P state of the driver.
> > > Though these files eventually control the min/max frequencies that the
> > > CPUs will run at, they don't make a change to policy->min/max values.
> > 
> > That's correct.
> > 
> > > When the values of these files are changed (in passive mode of the
> > > driver), it leads to calling ->limits() callback of the cpufreq
> > > governors, like schedutil. On a call to it the governors shall
> > > forcefully update the frequency to come within the limits.
> > 
> > OK, so the problem is that it is a bug to invoke the governor's ->limits()
> > callback without updating policy->min/max, because that's what
> > "limits" mean to the governors.
> > 
> > Fair enough.
> 
> AFAICS this can be addressed by adding PM QoS freq limits requests of each CPU to
> intel_pstate in the passive mode such that changing min_perf_pct or max_perf_pct
> will cause these requests to be updated.

Right, that sounds like a good plan.

But that will never make it to the stable kernels as there will be a
long dependency of otherwise unrelated patches to get that done. My
initial thought was to get this patch merged as it is and then later
migrate to QoS, but since this patch doesn't fix ondemand and
conservative, this patch isn't good enough as well.

Maybe we should add the regular notifier based solution first, mark it
for stable kernels, and then add the QoS specific solution ?

-- 
viresh
