Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E171615E3
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgBQPOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 10:14:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51763 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbgBQPOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 10:14:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so17506192wmi.1
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 07:14:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FEVpse848rMG2l6wyICquaSiFhnG6YvBC4IE8/E7Uys=;
        b=JloWnyEycJJqb6U/HpD0gxbW+vJgJ8SaxoWj2zngGf+79kzXsV0A4RKYFh2D11LlN2
         MM+5igSJldGEALQCgeaC26mJn9u3xPPzNWFkLTqGxnxAQi7Vcq7TVai6vvVA1nzEIdQb
         4EKj1VhS/4Wd3ajDmnI79g0KPGYxqYqvlH92GHhibABDMQ8gktwPpO5b+MQifUNDLmmi
         iC4XasubsavCOjYomj6uixMOSJI6NPJ6D3AdYHwW9Naa8+b3mu4RSoykl7hK6GHYPusN
         AOBh6ABeyQsPE4LN5xp55j26eL+a09TAUv34G1Zp1s2iiv6DXSLdY+B/WN+yxOZ5Mvk8
         eeCw==
X-Gm-Message-State: APjAAAUYVKqGXWo8ZVyAi4bNhnLvtEGVXRqRgEcYaq5C2XRVEktt5ZdS
        XyFbuGFttlL9cbPZguD0kcU=
X-Google-Smtp-Source: APXvYqxwhzDkzdmYhzB2HYa6C5gsN6qRHMKlExkKGUYst9moeiSWuGwPDxrOBe7hkG0MA4zAZVXUoA==
X-Received: by 2002:a1c:7712:: with SMTP id t18mr23363931wmi.32.1581952458585;
        Mon, 17 Feb 2020 07:14:18 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id e6sm1012798wme.3.2020.02.17.07.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 07:14:17 -0800 (PST)
Date:   Mon, 17 Feb 2020 16:14:17 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
Message-ID: <20200217151417.GS31531@dhcp22.suse.cz>
References: <20200216145249.6900-1-laoar.shao@gmail.com>
 <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
 <20200217132443.GM31531@dhcp22.suse.cz>
 <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
 <20200217140430.GO31531@dhcp22.suse.cz>
 <CALOAHbA0=QAo0KkKf-i_tSamhLQX2mmmP7h-CX2bRz9qcOSGwA@mail.gmail.com>
 <20200217143529.GQ31531@dhcp22.suse.cz>
 <CALOAHbA=fL4AbLFBE3riuxO7k48OnqtBwa1YNk6KBm+=CA7hPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbA=fL4AbLFBE3riuxO7k48OnqtBwa1YNk6KBm+=CA7hPw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 17-02-20 22:40:22, Yafang Shao wrote:
> On Mon, Feb 17, 2020 at 10:35 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 17-02-20 22:28:38, Yafang Shao wrote:
> > > On Mon, Feb 17, 2020 at 10:04 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Mon 17-02-20 21:51:23, Yafang Shao wrote:
> > > > > On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > >
> > > > > > On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > > > > > > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > > > > > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > > > > > > them won't be changed until next recalculation in this function. After
> > > > > > > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > > > > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > > > > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > > > > > > the old values of them will be used to calculate scan count, that is not
> > > > > > > > > proper. We should reset them to zero in this case.
> > > > > > > > >
> > > > > > > > > Here's an example of this issue.
> > > > > > > > >
> > > > > > > > >     root_mem_cgroup
> > > > > > > > >          /
> > > > > > > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > > > > > > >
> > > > > > > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > > > > > > this A, and it will assign memory.emin of A with 512M.
> > > > > > > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > > > > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > > > > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > > > > > > 512M, and then this old value will be used in
> > > > > > > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > > > > > > That is not proper.
> > > > > > > >
> > > > > > > > Please document user visible effects of this patch. What does it mean
> > > > > > > > that this is not proper behavior?
> > > > > > >
> > > > > > > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > > > > > > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > > > > > > but now as the old memcg.{emin, elow} value are still there, it will get
> > > > > > > a wrong protection value,
> > > > > > > and the reclaimer can't reclaim the page cache pages protected by this
> > > > > > > wrong protection.
> > > > > >
> > > > > > Could you be more specific please. Your example above says that emin is
> > > > > > not going to be recalculated and stays at 512M even for a potential max
> > > > > > limit reclaim. The min limit is still 512M so why is this value wrong?
> > > > > >
> > > > >
> > > > > Because the relcaimers are changed or the root the relcaimer is changed.
> > > > >
> > > > > Kswapd begins to relcaim memcg-A.
> > > > > kswapd
> > > > >   |
> > > > > calculate the {emin, elow} for memcg-A
> > > > >  |
> > > > > stores {emin, elow} in memory.{emin, elow} of memcg-A
> > > > > |
> > > > > This memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > (See get_scan_count->mem_cgroup_protection)
> > > > > |
> > > > > exit
> > > > > (And it won't relcaim memcg-A for a long time)
> > > > >
> > > > >
> > > > > Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
> > > > > and the root of this new reclaimer is memcg-A.
> > > > >
> > > > > This memcg relcaimer begins to reclaim memcg-A.
> > > > > memcg relcaimer
> > > > >       |
> > > > > As the root of the relcaimer is memcg-A, it won't calculate emin, elow
> > > > > for memcg-A.
> > > > > (See if (memcg == root) in mem_cgroup_protected())
> > > > >      |
> > > > > The old memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > (SO WE SHOULD CLEAR THE OLD VALUE)
> > > >
> > > > I am sorry but I still do not follow. Could you focus on _why_ the old
> > > > value is no longer valid?
> > >
> > > Because for the new reclaimer the memory.{emin, elow} should be 0.
> > > The old value may be not 0, but it was thought as 0 in the if
> > > statement (if (memcg == root)).
> >
> > Why should it be 0 when the A.min is still 512MB?
> 
> Because A's hard limit is reached and A is the root of memcg relcaimer.

Confused. But your examples suggests that memory.max > memory.min so
having an effective emin 0 or not doesn't make any difference.

> If A is the root of the memcg reclaimer, then the memcg protection
> should not prevent it from relcaiming the page cache pages of itself.
> That is why the if statement if (memcg == root) exists.

I suspect you misinterpret the code or your example is incomplete.
Please have a look at the patch I have referred to earlier. Johannes
explicitly sets effective values to their native ones
	if (parent == root) {
		memcg->memory.emin = memcg->memory.min;
		memcg->memory.elow = memcg->memory.low;
		goto out;
	}

and this matches my understanding.
-- 
Michal Hocko
SUSE Labs
