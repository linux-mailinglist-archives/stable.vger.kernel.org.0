Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F761622E6
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 09:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgBRI74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 03:59:56 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42147 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgBRI74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 03:59:56 -0500
Received: by mail-wr1-f68.google.com with SMTP id k11so22863538wrd.9
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 00:59:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ncWC4Mq2l6vBbVjSqC884nuFwg00+CZRskS/qQU9zIw=;
        b=QmPLRrr3WxtOw29W2w1REWy48H2LumCx0bygpH6uSWjWaGD9K8EGacZxYA5pyEUbZP
         WN5JfGG9RzDqRaFAoY3pJsgmJcbHnYH2A2FiYhr/Rb3JI9Y+z4V71ac0vpYwzOaCZaw1
         8xTaixCawjY3lNNo0F7OA/KDkDo9eEDs9jk5jZZkH6U/+YtREH9YQPvlkp0CNDsoBwKZ
         Rqv5e406qUELgoWbXUzJlEmTKiueH+a4Sk8FrbQY7J5do0mYmkY/UU1l7KqJJVUeL99t
         xEGxY5KmSDxyANfG59I80gm3unNz6OujfUhkxtcnbBkZu2YmckpyVE4DVgb8QhI2/i92
         yU6w==
X-Gm-Message-State: APjAAAXKIkYR1DKmgVq9pZ/q2Fl54REbGdlMknMFMqm5u/VQMFijkcPn
        x/ASH7VfuXBdN4ytbXvDOh3guh/q
X-Google-Smtp-Source: APXvYqy8BxA8rme+cZnU5vnOMuCp7mpJEJ0/Z1YSBszNu5Zgz3MfAu12pC5TVbN1RqIW2J1rnyCzFw==
X-Received: by 2002:a05:6000:108c:: with SMTP id y12mr1597849wrw.366.1582016392862;
        Tue, 18 Feb 2020 00:59:52 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id o7sm2657604wmh.11.2020.02.18.00.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 00:59:51 -0800 (PST)
Date:   Tue, 18 Feb 2020 09:59:51 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
Message-ID: <20200218085951.GE21113@dhcp22.suse.cz>
References: <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
 <20200217132443.GM31531@dhcp22.suse.cz>
 <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
 <20200217140430.GO31531@dhcp22.suse.cz>
 <CALOAHbA0=QAo0KkKf-i_tSamhLQX2mmmP7h-CX2bRz9qcOSGwA@mail.gmail.com>
 <20200217143529.GQ31531@dhcp22.suse.cz>
 <CALOAHbA=fL4AbLFBE3riuxO7k48OnqtBwa1YNk6KBm+=CA7hPw@mail.gmail.com>
 <20200217151417.GS31531@dhcp22.suse.cz>
 <CALOAHbD-K_BFjw-mLGWY-PWRe4J9BaMc0w7YmU9yp-t4iV4F_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbD-K_BFjw-mLGWY-PWRe4J9BaMc0w7YmU9yp-t4iV4F_A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 18-02-20 10:09:06, Yafang Shao wrote:
> On Mon, Feb 17, 2020 at 11:14 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 17-02-20 22:40:22, Yafang Shao wrote:
> > > On Mon, Feb 17, 2020 at 10:35 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Mon 17-02-20 22:28:38, Yafang Shao wrote:
> > > > > On Mon, Feb 17, 2020 at 10:04 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > >
> > > > > > On Mon 17-02-20 21:51:23, Yafang Shao wrote:
> > > > > > > On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > > > > > > > > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > > > > >
> > > > > > > > > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > > > > > > > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > > > > > > > > them won't be changed until next recalculation in this function. After
> > > > > > > > > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > > > > > > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > > > > > > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > > > > > > > > the old values of them will be used to calculate scan count, that is not
> > > > > > > > > > > proper. We should reset them to zero in this case.
> > > > > > > > > > >
> > > > > > > > > > > Here's an example of this issue.
> > > > > > > > > > >
> > > > > > > > > > >     root_mem_cgroup
> > > > > > > > > > >          /
> > > > > > > > > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > > > > > > > > >
> > > > > > > > > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > > > > > > > > this A, and it will assign memory.emin of A with 512M.
> > > > > > > > > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > > > > > > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > > > > > > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > > > > > > > > 512M, and then this old value will be used in
> > > > > > > > > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > > > > > > > > That is not proper.
> > > > > > > > > >
> > > > > > > > > > Please document user visible effects of this patch. What does it mean
> > > > > > > > > > that this is not proper behavior?
> > > > > > > > >
> > > > > > > > > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > > > > > > > > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > > > > > > > > but now as the old memcg.{emin, elow} value are still there, it will get
> > > > > > > > > a wrong protection value,
> > > > > > > > > and the reclaimer can't reclaim the page cache pages protected by this
> > > > > > > > > wrong protection.
> > > > > > > >
> > > > > > > > Could you be more specific please. Your example above says that emin is
> > > > > > > > not going to be recalculated and stays at 512M even for a potential max
> > > > > > > > limit reclaim. The min limit is still 512M so why is this value wrong?
> > > > > > > >
> > > > > > >
> > > > > > > Because the relcaimers are changed or the root the relcaimer is changed.
> > > > > > >
> > > > > > > Kswapd begins to relcaim memcg-A.
> > > > > > > kswapd
> > > > > > >   |
> > > > > > > calculate the {emin, elow} for memcg-A
> > > > > > >  |
> > > > > > > stores {emin, elow} in memory.{emin, elow} of memcg-A
> > > > > > > |
> > > > > > > This memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > > > (See get_scan_count->mem_cgroup_protection)
> > > > > > > |
> > > > > > > exit
> > > > > > > (And it won't relcaim memcg-A for a long time)
> > > > > > >
> > > > > > >
> > > > > > > Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
> > > > > > > and the root of this new reclaimer is memcg-A.
> > > > > > >
> > > > > > > This memcg relcaimer begins to reclaim memcg-A.
> > > > > > > memcg relcaimer
> > > > > > >       |
> > > > > > > As the root of the relcaimer is memcg-A, it won't calculate emin, elow
> > > > > > > for memcg-A.
> > > > > > > (See if (memcg == root) in mem_cgroup_protected())
> > > > > > >      |
> > > > > > > The old memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > > > (SO WE SHOULD CLEAR THE OLD VALUE)
> > > > > >
> > > > > > I am sorry but I still do not follow. Could you focus on _why_ the old
> > > > > > value is no longer valid?
> > > > >
> > > > > Because for the new reclaimer the memory.{emin, elow} should be 0.
> > > > > The old value may be not 0, but it was thought as 0 in the if
> > > > > statement (if (memcg == root)).
> > > >
> > > > Why should it be 0 when the A.min is still 512MB?
> > >
> > > Because A's hard limit is reached and A is the root of memcg relcaimer.
> >
> > Confused. But your examples suggests that memory.max > memory.min so
> > having an effective emin 0 or not doesn't make any difference.
> >
> 
> Why is it having an effective emin 0 if memory.max > memory.min ?
> Note that effective emin is only set in function
> mem_cgroup_protected(), so if we don't set it explicitly to 0 then it
> can't be 0.
>
> Besides mem_cgroup_protected(), the effective emin also take effect in
> the function mem_cgroup_protection(), but in this function it only use
> the existed memory.emin rather than verifying memory.max > memory.min.
> 
> So the real issue is in mem_cgroup_protection(), because the value it
> is using may be an old value.

I am sorry but I still do not follow. You keep focusing on talking about
the code while I am really interested in the user visible semantic that
you want to achieve. I am sorry to be dense here but believe me I am
trying.

Your example doesn't help much because the effective protection doesn't
play any role in the limit reclaim there AFAICS. I would even argue that
emin == min is the proper thing in your example.

So I can only recommend you to rethink your usecase and try to describe
it in a higher level way.

Thanks!
-- 
Michal Hocko
SUSE Labs
