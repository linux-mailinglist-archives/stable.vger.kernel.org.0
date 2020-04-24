Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC5F1B7BA2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDXQb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgDXQb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 12:31:26 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D18C09B046
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:31:26 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so11014902ioj.1
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8gZzuzuHy1N2O54R+Hhx4bbnAF7GR0rIPTLAkk3+9U=;
        b=n3Ao58aPO1jP631p56XDOWB6KBqKAvqqY+k7HepxaBki97beKAEUEpNRZto5UTwq4C
         xh687hSrTTXAav0JjWMsfzUkS8CsLXF3nwXR7PtqH6mbLXD/xolXmMj2DxvOm9F9Q8pM
         oXFz75KFTHdAaH/QJG7G7Wx7YBIp8qwaNGKrMvuGmV8BgeTvlVIcLqdpMwnwJ9ewLROH
         zB3nlIyYW0dIxX2pfFRRn541S8UMH6VCiTPYunRtpmVHvyOTl9CSYOR8fjUXeD5jWvt1
         k8BTvmtEJenNIp05aCZuOqIC+w/Cog2DaUYZ7RCwjUyX4va0pC5lGS6UWqZkPH+BaVVl
         w1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8gZzuzuHy1N2O54R+Hhx4bbnAF7GR0rIPTLAkk3+9U=;
        b=i9iI4Z2PpEKE/NKNYJxA6Z8Nq2Qjx7fihAJG+0T1086O9C6AxuDgGhJtDxAjabA7Z1
         kjnNdL818JutDdRwGIEbksz5SGDVsktEmuV9m0iMLtx/BA44j7MG4w1VV1/UCPSWAq6j
         R/A0v8bpsuH1LYK0yGPlu5/Wx9Yjx6S10j85oTpNJJ0/8swn3h3sou328ouqO2Q4VcZS
         hpCIugULlK9cvH/is52Y10Ap5T4TGWRiE24jyFNJ6Az7JyUe8DAmzTkPeXf3ttGPRgCF
         I+VuWIPiTPrKyrWHdmvqPkCufx2lHNcPDy1RSF5AjS4VM81F8tGIGJTKpNu212ZOVZ5a
         Amig==
X-Gm-Message-State: AGi0PuYSScVOT+l5awnuG/ZMlfaCy8eTNrXmGmM3HRYXHQ1NV/85/sBl
        LTYHI17lHndItFE7SOdq03qCsLXSYuZ/0h0ql7c=
X-Google-Smtp-Source: APiQypKJEe3y6mru5S+uRWATW1RxNzdISidArH53uC+BeG9bX0aePuzM99o3SmK0gnEnn0qZqk1by7vyCnZeLyJiBT0=
X-Received: by 2002:a6b:7843:: with SMTP id h3mr9421428iop.202.1587745886012;
 Fri, 24 Apr 2020 09:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz> <20200424162148.GA99424@carbon.lan>
In-Reply-To: <20200424162148.GA99424@carbon.lan>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 25 Apr 2020 00:30:14 +0800
Message-ID: <CALOAHbANyQXw862rSxwncY_050AYCpzQT=qrbTdWmsD6Hm=uhA@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
To:     Roman Gushchin <guro@fb.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 25, 2020 at 12:22 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> > On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > > This patch is an improvement of a previous version[1], as the previous
> > > > version is not easy to understand.
> > > > This issue persists in the newest kernel, I have to resend the fix. As
> > > > the implementation is changed, I drop Roman's ack from the previous
> > > > version.
> > >
> > > Now that I understand the problem, I much prefer the previous version.
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 745697906ce3..2bf91ae1e640 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> > >
> > >     if (!root)
> > >             root = root_mem_cgroup;
> > > -   if (memcg == root)
> > > +   if (memcg == root) {
> > > +           /*
> > > +            * The cgroup is the reclaim root in this reclaim
> > > +            * cycle, and therefore not protected. But it may have
> > > +            * stale effective protection values from previous
> > > +            * cycles in which it was not the reclaim root - for
> > > +            * example, global reclaim followed by limit reclaim.
> > > +            * Reset these values for mem_cgroup_protection().
> > > +            */
> > > +           memcg->memory.emin = 0;
> > > +           memcg->memory.elow = 0;
> > >             return MEMCG_PROT_NONE;
> > > +   }
> >
> > Could you be more specific why you prefer this over the
> > mem_cgroup_protection which doesn't change the effective value?
> > Isn't it easier to simply ignore effective value for the reclaim roots?
>
> Hm, I think I like the new version better, because it feels "safer" in terms
> of preserving sane effective protection values for concurrent reclaimers.
>
> >
> > [...]
> >
> > > As others have noted, it's fairly hard to understand the problem from
> > > the above changelog. How about the following:
> > >
> > > A cgroup can have both memory protection and a memory limit to isolate
> > > it from its siblings in both directions - for example, to prevent it
> > > from being shrunk below 2G under high pressure from outside, but also
> > > from growing beyond 4G under low pressure.
> > >
> > > 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > > implemented proportional scan pressure so that multiple siblings in
> > > excess of their protection settings don't get reclaimed equally but
> > > instead in accordance to their unprotected portion.
> > >
> > > During limit reclaim, this proportionality shouldn't apply of course:
> > > there is no competition, all pressure is from within the cgroup and
> > > should be applied as such. Reclaim should operate at full efficiency.
> > >
> > > However, mem_cgroup_protected() never expected anybody to look at the
> > > effective protection values when it indicated that the cgroup is above
> > > its protection. As a result, a query during limit reclaim may return
> > > stale protection values that were calculated by a previous reclaim
> > > cycle in which the cgroup did have siblings.
> >
> > This is better. Thanks!
>
> +1
>
> and I like the proposed renaming/cleanup. Thanks, Johannes!
>
> >
> > > When this happens, reclaim is unnecessarily hesitant and potentially
> > > slow to meet the desired limit. In theory this could lead to premature
> > > OOM kills, although it's not obvious this has occurred in practice.
> >
> > I do not see how this would lead all the way to OOM killer but it
> > certainly can lead to unnecessary increase of the reclaim priority. The
> > smaller the difference between the reclaim target and protection the
> > more visible the effect would be. But if there are reclaimable pages
> > then the reclaim should see them sooner or later
>
> I guess if all memory is protected by emin and the targeted reclaim
> will be unable to reclaim anything, OOM can be triggered.
>
> Btw, I wonder if this case can be covered by a new memcg kselftest?
> I'm not sure it can be easily reproducible, but if it can, it would be
> the best demonstration of a problem and the fix.
> Yafang, don't you want to try?

I have tried to produce the premature OOM before I send this fix, but
I find that it is really not easy to produce.
But if a new memcg kselftest is needed, I can try it again.

-- 
Thanks
Yafang
