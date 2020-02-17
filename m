Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312121614D8
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 15:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgBQOlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 09:41:01 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37867 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgBQOlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 09:41:01 -0500
Received: by mail-io1-f66.google.com with SMTP id k24so6191255ioc.4
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 06:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iXh8ro/w+EGserfjICWCWpFNQV+BDXWvCw7yjk7DTfc=;
        b=cupU+tnlN7CQvlfCmxt99n9km9hhcs634U55NPsqdrrRh///r9r35gjKRnP2ZFDoLI
         391me4PVFBAvWw+ZetZdoaL8cxUUk/mg6XWh5vZMqAKBCAaUfA8DvCt6dfVaL3mpD1gP
         Lojd0qgU429oSE6Rmfxy52XEfBHUV8EDvZdoDimg+2VCRc3fY62cLb89Fg7QeR96qno3
         xulWi2nq0ORA9sBBH4lXZbXJJItYsoCSyl4U/wyxPHHf77I2I4j4G1+JEGK9Y9cjYH/9
         V77oCjpIneESc2RyehmvRAaFhwcY+1FpFeSogPCV5Ei8+kFC4/wC+ttEKuVRjLdgIlHt
         vIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iXh8ro/w+EGserfjICWCWpFNQV+BDXWvCw7yjk7DTfc=;
        b=UWNdhAd4pSsYLlX0BPcY8JTeBr66XsMxZEH191UoC3IELG2QbRDYC3Rh0427xUjlkZ
         RCDVqnwgMZUN0JWE//FyvY2JsvE5wYVu82I7lLGhm6t3+Q7UKPQ6VABvZTQpB+E5ovwa
         CephQ6t2bVcfNIAjnl+JqX7S8gjwGin5H1Fp9mOlLIxV2ytWnvRywok5PYAH6kuvrbcg
         WntoHMgH9qJzH9fSk+aDWrQ7MXiXqD9WRaqttfDzjQD2Zfj+oJpB4CwKHodc1I9f0Swf
         Fp34kks/td2h01K4QuS9p8F1u5v8diB5Lgcm6Lln2h+nU/QiqJ9ma3F57aCZXcmPvHtN
         6KOw==
X-Gm-Message-State: APjAAAXhp09jczkSCHkV34KI/b06yc7PVSd7mD5ax97oinB0sUjDdND/
        0puCmnze/qY1zYlOnyxQPqsbptJEY/BOKUrnQ1E=
X-Google-Smtp-Source: APXvYqwR9DhB3u8BaIDxTL5biDNFozfBve70edkTz0cKZftBJA58k3x5WYAcFnTnfZ9hqo85jk7CPgNSOB9CbuJ8dDM=
X-Received: by 2002:a02:b615:: with SMTP id h21mr12403399jam.109.1581950458697;
 Mon, 17 Feb 2020 06:40:58 -0800 (PST)
MIME-Version: 1.0
References: <20200216145249.6900-1-laoar.shao@gmail.com> <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
 <20200217132443.GM31531@dhcp22.suse.cz> <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
 <20200217140430.GO31531@dhcp22.suse.cz> <CALOAHbA0=QAo0KkKf-i_tSamhLQX2mmmP7h-CX2bRz9qcOSGwA@mail.gmail.com>
 <20200217143529.GQ31531@dhcp22.suse.cz>
In-Reply-To: <20200217143529.GQ31531@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 17 Feb 2020 22:40:22 +0800
Message-ID: <CALOAHbA=fL4AbLFBE3riuxO7k48OnqtBwa1YNk6KBm+=CA7hPw@mail.gmail.com>
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

On Mon, Feb 17, 2020 at 10:35 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 17-02-20 22:28:38, Yafang Shao wrote:
> > On Mon, Feb 17, 2020 at 10:04 PM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Mon 17-02-20 21:51:23, Yafang Shao wrote:
> > > > On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > >
> > > > > On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > > > > > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > >
> > > > > > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > > > > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > > > > > them won't be changed until next recalculation in this function. After
> > > > > > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > > > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > > > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > > > > > the old values of them will be used to calculate scan count, that is not
> > > > > > > > proper. We should reset them to zero in this case.
> > > > > > > >
> > > > > > > > Here's an example of this issue.
> > > > > > > >
> > > > > > > >     root_mem_cgroup
> > > > > > > >          /
> > > > > > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > > > > > >
> > > > > > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > > > > > this A, and it will assign memory.emin of A with 512M.
> > > > > > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > > > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > > > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > > > > > 512M, and then this old value will be used in
> > > > > > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > > > > > That is not proper.
> > > > > > >
> > > > > > > Please document user visible effects of this patch. What does it mean
> > > > > > > that this is not proper behavior?
> > > > > >
> > > > > > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > > > > > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > > > > > but now as the old memcg.{emin, elow} value are still there, it will get
> > > > > > a wrong protection value,
> > > > > > and the reclaimer can't reclaim the page cache pages protected by this
> > > > > > wrong protection.
> > > > >
> > > > > Could you be more specific please. Your example above says that emin is
> > > > > not going to be recalculated and stays at 512M even for a potential max
> > > > > limit reclaim. The min limit is still 512M so why is this value wrong?
> > > > >
> > > >
> > > > Because the relcaimers are changed or the root the relcaimer is changed.
> > > >
> > > > Kswapd begins to relcaim memcg-A.
> > > > kswapd
> > > >   |
> > > > calculate the {emin, elow} for memcg-A
> > > >  |
> > > > stores {emin, elow} in memory.{emin, elow} of memcg-A
> > > > |
> > > > This memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > (See get_scan_count->mem_cgroup_protection)
> > > > |
> > > > exit
> > > > (And it won't relcaim memcg-A for a long time)
> > > >
> > > >
> > > > Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
> > > > and the root of this new reclaimer is memcg-A.
> > > >
> > > > This memcg relcaimer begins to reclaim memcg-A.
> > > > memcg relcaimer
> > > >       |
> > > > As the root of the relcaimer is memcg-A, it won't calculate emin, elow
> > > > for memcg-A.
> > > > (See if (memcg == root) in mem_cgroup_protected())
> > > >      |
> > > > The old memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > (SO WE SHOULD CLEAR THE OLD VALUE)
> > >
> > > I am sorry but I still do not follow. Could you focus on _why_ the old
> > > value is no longer valid?
> >
> > Because for the new reclaimer the memory.{emin, elow} should be 0.
> > The old value may be not 0, but it was thought as 0 in the if
> > statement (if (memcg == root)).
>
> Why should it be 0 when the A.min is still 512MB?

Because A's hard limit is reached and A is the root of memcg relcaimer.
If A is the root of the memcg reclaimer, then the memcg protection
should not prevent it from relcaiming the page cache pages of itself.
That is why the if statement if (memcg == root) exists.


-- 
Yafang Shao
DiDi
