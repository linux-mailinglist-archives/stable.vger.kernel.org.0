Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4731B9A67
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 10:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgD0Iia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 04:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgD0Iia (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 04:38:30 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCE7C061A0F
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 01:38:30 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i3so17889922ioo.13
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 01:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEo5ztM7PjwEKEFv1k95Abdu/HT27wQl2C3Wf2GYPfk=;
        b=tSekaGL1GTB9/fxLaUpHu+Bgz8Ma5skUDxlYQER4HX9yGyt2PAyMJjLIGVNY7FjZ/z
         0X7gKdQvKfmZsTVqkhqcpuK96ne76nJ42KBoPKM/23LkEUaG+lw0m+s1i0DECVzoaBE3
         Vez1Tcghmf9z08hFhp/ZpfURZqoF+h35+Blx6U7n9mHkBmsysJXqLV4VrqOX5zqbC6UH
         EauQSraexBXcDNgS+ci4lkJs1coFv3VNZfhiiIliGxoTpF1G0IKZtfo/yqas8HMa7HN5
         XO7VoeM8g+m1Ikr74bHeU50a53M7JPsIAwu24WIfITUXNO1QuuUD5FzoD2KsCMyHgqQG
         5oEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEo5ztM7PjwEKEFv1k95Abdu/HT27wQl2C3Wf2GYPfk=;
        b=R4zm+LPWRu4suoSOwua1/IUsZhksd98LOofFbs9zaHH97Vmfc8Xq2GfHSD+9mUIc70
         3WrXChwhnnujgpJDC0wIuHCpagBXsfDso4cIfrfGRQOBisu+B4CYLoMSSC2zD8/ACY1I
         mjLFAlhbdNbFDYdTupFuqXTVYv5OSphO3Lkg+lio67gVp/twBVLpASFRYqNnGsWxoJkY
         cd0Iw0oLDx5rezk4qqzotlc0+6f0+3Ivsz91K/3tdyHIhcxSOACteVwjwBDTI6W6ZAG8
         MeyiIQraIAeSCwQkpxMKJK5I/louRtKu7GTKNQo8eQNaCt4dGUt+d40BeY7CQV2PWttT
         FzFA==
X-Gm-Message-State: AGi0Pua6+FOqaM/y/y5JbN4+5iZApEXb7w0E6WSCSQELZDdurqxWPbGa
        sIgqd5YLFtcZQUa8zo3HXbJorLtl5KDqHc0yBZQ=
X-Google-Smtp-Source: APiQypJOIfdx6iyW6JazrdwaoStq2TrKM077KYsrXOVErc7JIsDifrp+yjeIKOaE+HVLEVZNremkuwdlYk/zk9Kc62Q=
X-Received: by 2002:a02:5184:: with SMTP id s126mr8883993jaa.81.1587976709613;
 Mon, 27 Apr 2020 01:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz> <20200424151013.GA525165@cmpxchg.org>
 <20200424162103.GK11591@dhcp22.suse.cz> <20200424165103.GA575707@cmpxchg.org> <20200427082524.GC28637@dhcp22.suse.cz>
In-Reply-To: <20200427082524.GC28637@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 27 Apr 2020 16:37:53 +0800
Message-ID: <CALOAHbDXTMK3wdLh1qNS+HFnCxZtt=HJ3duKMkRq5OHCbJE9yA@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 27, 2020 at 4:25 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Fri 24-04-20 12:51:03, Johannes Weiner wrote:
> > On Fri, Apr 24, 2020 at 06:21:03PM +0200, Michal Hocko wrote:
> > > On Fri 24-04-20 11:10:13, Johannes Weiner wrote:
> > > > On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> > > > > On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > > > > > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > > > > > This patch is an improvement of a previous version[1], as the previous
> > > > > > > version is not easy to understand.
> > > > > > > This issue persists in the newest kernel, I have to resend the fix. As
> > > > > > > the implementation is changed, I drop Roman's ack from the previous
> > > > > > > version.
> > > > > >
> > > > > > Now that I understand the problem, I much prefer the previous version.
> > > > > >
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index 745697906ce3..2bf91ae1e640 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> > > > > >
> > > > > >       if (!root)
> > > > > >               root = root_mem_cgroup;
> > > > > > -     if (memcg == root)
> > > > > > +     if (memcg == root) {
> > > > > > +             /*
> > > > > > +              * The cgroup is the reclaim root in this reclaim
> > > > > > +              * cycle, and therefore not protected. But it may have
> > > > > > +              * stale effective protection values from previous
> > > > > > +              * cycles in which it was not the reclaim root - for
> > > > > > +              * example, global reclaim followed by limit reclaim.
> > > > > > +              * Reset these values for mem_cgroup_protection().
> > > > > > +              */
> > > > > > +             memcg->memory.emin = 0;
> > > > > > +             memcg->memory.elow = 0;
> > > > > >               return MEMCG_PROT_NONE;
> > > > > > +     }
> > > > >
> > > > > Could you be more specific why you prefer this over the
> > > > > mem_cgroup_protection which doesn't change the effective value?
> > > > > Isn't it easier to simply ignore effective value for the reclaim roots?
> > > >
> > > > Because now both mem_cgroup_protection() and mem_cgroup_protected()
> > > > have to know about the reclaim root semantics, instead of just the one
> > > > central place.
> > >
> > > Yes this is true but it is also potentially overwriting the state with
> > > a parallel reclaim which can lead to surprising results
> >
> > Checking in mem_cgroup_protection() doesn't avoid the fundamental race:
> >
> >   root
> >      `- A (low=2G, elow=2G, max=3G)
> >         `- A1 (low=2G, elow=2G)
> >
> > If A does limit reclaim while global reclaim races, the memcg == root
> > check in mem_cgroup_protection() will reliably calculate the "right"
> > scan value for A, which has no pages, and the wrong scan value for A1
> > where the memory actually is.
>
> I am sorry but I do not see how A1 would get wrong scan value.
> - Global reclaim
>   - A.elow = 2G
>   - A1.elow = min(A1.low, A1.usage) ; if (A.children_low_usage < A.elow)
>
> - A reclaim.
>   - A.elow = stale/undefined
>   - A1.elow = A1.low
>
> if mem_cgroup_protection returns 0 for A's reclaim targeting A (assuming
> the check is there) then not a big deal as there are no pages there as
> you say.
>
> Let's compare the GR (global reclaim), AR (A reclaim).
> GR(A1.elow) <= AR(A1.elow) by definition, right? For A1.low
> overcommitted we have
> min(A1.low, A1.usage) * A.elow / A.children_low_usage <= min(A1.low, A1.usage)
> because A.elow <= A.children_low_usage
>
> so in both cases we have GR(A1.elow) <= AR(A1.elow) which means that
> racing reclaims will behave sanely because the protection for the
> external pressure pressure is not violated. A is going to reclaim A1
> less than the global reclaim but that should be OK.
>
> Or what do I miss?
>
> > I'm okay with fixing the case where a really old left-over value is
> > used by target reclaim.
> >
> > I don't see a point in special casing this one instance of a
> > fundamental race condition at the expense of less robust code.
>
> I am definitely not calling to fragment the code. I do agree that having
> a special case in mem_cgroup_protection is quite non-intuitive.
> The existing code is quite hard to reason about in its current form
> as we can see. If we can fix all that in mem_cgroup_protected then no
> objections from me at all.

Hi Michal,

Pls. help take a look at my refactor on proportional memcg protection[1].
I think my new patchset can fix all that in mem_cgroup_protected and
make the existing code clear.


[1]. https://lore.kernel.org/linux-mm/20200425152418.28388-1-laoar.shao@gmail.com/T/#t

-- 
Thanks
Yafang
