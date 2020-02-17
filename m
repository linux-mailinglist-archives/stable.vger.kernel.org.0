Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253A71614B3
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 15:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgBQO3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 09:29:15 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:45902 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbgBQO3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 09:29:15 -0500
Received: by mail-il1-f196.google.com with SMTP id p8so14380451iln.12
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 06:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AJxsfYhMcSNCydJtht5svn+AT1jw5g6RPzwLlHAmpsU=;
        b=L/ZD+iCJp843KveJCu6Iqg2257OYOWSC9S7ugGXP3eHRi2cJ/7qSMZFuzDQvbe/vo9
         Ik4s5qNFovUc4CrD66Xi3OmrAlJDw7ti4QvVaqqm/dxa9UuQPeq3p83g/PezsUuhRqzA
         bOgKMnuAG4ggWQRqyc5KgsacJ5IiYroOZhi/+kbx5GYG7BfHYYfTF8bI2I5bmICH3pmG
         47fMkQLPd/EQKSbjELvUwLIRTp8dtEWtFYmy0kjRAg+BHohFHcPHUoU7vOAsYKHMSaL4
         ETZVwgMmTo4d0k3nF2E+TXVNuRATvWpvQpDrEPksBxg6nBo8q4crw7Ei9JO7312UOATK
         koJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AJxsfYhMcSNCydJtht5svn+AT1jw5g6RPzwLlHAmpsU=;
        b=FasdVvqxLFgx5WjK66UsAHc86+V/S4VUXsFcewrgnn3NjsQ860MGOhIWGvX0ryPyeo
         5wIbTUa13MZlrDaBR2fgE0DcSxYX8vW29HSVNztOdFkW2ObMDSQ7GhmUqr+IpW0umwcV
         7d1rHtNoxeTKortyk9ete6E3T7dleHRpubu/1gDoD0QP3tCCWCFeWZkBHJgEvTh3DRwL
         fa1Nq49rVSIAOMGKD1MFf20d6iRvfGdjotJDUCHrzbE/IQaw/zSHEEcZ87+blmi5ciul
         Y6VI3c8PtBtGItFh8Wuss0Cte+mNaN1aa9SHSxrrfZ/geeCwSos/cQVYP+0G+5Ekjdbs
         0R3Q==
X-Gm-Message-State: APjAAAUUdvwMpdOq7p+8unLZUXcEWBI5IPXYYG6Sffbwvc2CDxQLGe8V
        huuy2AsOruPXpc16hmwmE3pIDsa5v1eBA9F4NLY=
X-Google-Smtp-Source: APXvYqwQ7qeAu0FbgjGgYW8HSc8iHOZFQ9RjV3fa8KpHaALVEF6kooPWZ8mkAp5c3vX/b6hTyXeVO5csjA8mhytr6io=
X-Received: by 2002:a92:84ce:: with SMTP id y75mr14423694ilk.93.1581949754497;
 Mon, 17 Feb 2020 06:29:14 -0800 (PST)
MIME-Version: 1.0
References: <20200216145249.6900-1-laoar.shao@gmail.com> <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
 <20200217132443.GM31531@dhcp22.suse.cz> <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
 <20200217140430.GO31531@dhcp22.suse.cz>
In-Reply-To: <20200217140430.GO31531@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 17 Feb 2020 22:28:38 +0800
Message-ID: <CALOAHbA0=QAo0KkKf-i_tSamhLQX2mmmP7h-CX2bRz9qcOSGwA@mail.gmail.com>
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 10:04 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 17-02-20 21:51:23, Yafang Shao wrote:
> > On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > > > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > >
> > > > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > > > them won't be changed until next recalculation in this function. After
> > > > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > > > the old values of them will be used to calculate scan count, that is not
> > > > > > proper. We should reset them to zero in this case.
> > > > > >
> > > > > > Here's an example of this issue.
> > > > > >
> > > > > >     root_mem_cgroup
> > > > > >          /
> > > > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > > > >
> > > > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > > > this A, and it will assign memory.emin of A with 512M.
> > > > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > > > 512M, and then this old value will be used in
> > > > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > > > That is not proper.
> > > > >
> > > > > Please document user visible effects of this patch. What does it mean
> > > > > that this is not proper behavior?
> > > >
> > > > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > > > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > > > but now as the old memcg.{emin, elow} value are still there, it will get
> > > > a wrong protection value,
> > > > and the reclaimer can't reclaim the page cache pages protected by this
> > > > wrong protection.
> > >
> > > Could you be more specific please. Your example above says that emin is
> > > not going to be recalculated and stays at 512M even for a potential max
> > > limit reclaim. The min limit is still 512M so why is this value wrong?
> > >
> >
> > Because the relcaimers are changed or the root the relcaimer is changed.
> >
> > Kswapd begins to relcaim memcg-A.
> > kswapd
> >   |
> > calculate the {emin, elow} for memcg-A
> >  |
> > stores {emin, elow} in memory.{emin, elow} of memcg-A
> > |
> > This memory.{emin, elow} will protect the page cache pages in memcg-A
> > (See get_scan_count->mem_cgroup_protection)
> > |
> > exit
> > (And it won't relcaim memcg-A for a long time)
> >
> >
> > Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
> > and the root of this new reclaimer is memcg-A.
> >
> > This memcg relcaimer begins to reclaim memcg-A.
> > memcg relcaimer
> >       |
> > As the root of the relcaimer is memcg-A, it won't calculate emin, elow
> > for memcg-A.
> > (See if (memcg == root) in mem_cgroup_protected())
> >      |
> > The old memory.{emin, elow} will protect the page cache pages in memcg-A
> > (SO WE SHOULD CLEAR THE OLD VALUE)
>
> I am sorry but I still do not follow. Could you focus on _why_ the old
> value is no longer valid?

Because for the new reclaimer the memory.{emin, elow} should be 0.
The old value may be not 0, but it was thought as 0 in the if
statement (if (memcg == root)).

>
> Btw. have you seen the latest patch from Johannes touching this area
> [1]? Is it possible that the issue you are referring to is related with
> the one he has fixed?
>
> [1] http://lkml.kernel.org/r/20191219200718.15696-2-hannes@cmpxchg.org
>

I haven't taken a look at it yet.


-- 
Yafang Shao
DiDi
