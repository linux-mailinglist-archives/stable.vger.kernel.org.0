Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623881B728B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 12:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDXK5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 06:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgDXK5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 06:57:49 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0929C09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 03:57:48 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so9896265iob.3
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 03:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W14NOQNLgCCF+107wQXaNZVar3MGasMy5WRrpNRQT4U=;
        b=SHw/vTc1MxAyac2wBzilgn8X3tBU6XIE+102l6O4e7B7BIfTusHPr9hBScjrGtLub2
         cJOMUQwIakcIQc5Q8CTiOu3AlC5eUYOil4W9m7WmkDVGZgnp/lf4rxaOfFm/HqZk4F4K
         97xruXO4OYg7uRRL3+d6RL5X20Shmy/BUhoKwUatl3636sKODjgpenkZ1BafjdqmveOX
         v7mk0FMXqh1PL/ImuC2MADjDRO9AhNoQ4b4Bgto4iPXO53jU/m+IWtDpFSeEShRb+ZNS
         mRFuWT1dJq7POK29Uje1KEm8+xtBUYG6V7AvwuL/srEKkgFk1hL5oA+VZNfSgymahKh6
         wYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W14NOQNLgCCF+107wQXaNZVar3MGasMy5WRrpNRQT4U=;
        b=YBLF8ckKeY1udseNQ43ppVQNvZHXLEYEunwBZbWySwPjJ6R4NCIStQFvRs4mjLNMfp
         /XaNPi6XlcEl1MfLde2XV0Vm1ooZNcbdL1xXRyktjptgjV2PuzWSdFDLfiyizt8HpE67
         EYYEy2+5RvoXbIgb3Fzj8XjAhj6eu5rdvS4XcBBpNDcrQCCZp3mmx1lUHRrHXkQrVR4j
         uz0saYXgV46q4zLLodaLvCGrVYgQZPRbn9RRW4G6VwpUa1icWTj7N1uNJcvCRe2QXq46
         1NmdzqIBvlY8IO8BtYu14Pr7r58Nh0CJzShClKw8ou9q7gzwtZVR0jeps7Vnx+m0aWJU
         3Vew==
X-Gm-Message-State: AGi0PubIYqAJeKH93ciC7VI5iYbjhymKGHOwW7Wu2nij0AOXc1ZA2uV1
        TN1UoDFLecRlDsZC69o/RtmBcQO08LK+1DgVcfA=
X-Google-Smtp-Source: APiQypLXca/a7phxEASsLYORG01eI9t1phsfw0DunZu0lpR8EHvRoISCb3tenDi3OsgWKQFQE/+Kj/MBHgwsREWxEEw=
X-Received: by 2002:a02:ccad:: with SMTP id t13mr7861102jap.64.1587725868245;
 Fri, 24 Apr 2020 03:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200423153323.GA1318256@chrisdown.name>
 <20200423211319.GC83398@carbon.DHCP.thefacebook.com> <20200424104041.GE11591@dhcp22.suse.cz>
In-Reply-To: <20200424104041.GE11591@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 24 Apr 2020 18:57:10 +0800
Message-ID: <CALOAHbC8U+SyauQPraUbEf2=Wx1bBtKZKU4N9iscUV+distEkA@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 6:40 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Thu 23-04-20 14:13:19, Roman Gushchin wrote:
> > On Thu, Apr 23, 2020 at 04:33:23PM +0100, Chris Down wrote:
> > > Hi Yafang,
> > >
> > > I'm afraid I'm just as confused as Michal was about the intent of this patch.
> > >
> > > Can you please be more concise and clear about the practical ramifications
> > > and demonstrate some pathological behaviour? I really can't visualise what's
> > > wrong here from your explanation, and if I can't understand it as the person
> > > who wrote this code, I am not surprised others are also confused :-)
> > >
> > > Or maybe Roman can try to explain, since he acked the previous patch? At
> > > least to me, the emin/elow behaviour seems fairly non-trivial to reason
> > > about right now.
> >
> > Hi Chris!
> >
> > So the thing is that emin/elow cached values are shared between global and
> > targeted (caused by memory.max) reclaim. It's racy by design, but in general
> > it should work ok, because in the end we'll reclaim or not approximately
> > the same amount of memory.
> >
> > In the case which Yafang described, the emin value calculated in the process
> > of the global reclaim leads to a slowdown of the targeted reclaim. It's not
> > a tragedy, but not perfect too. It seems that the proposed patch makes it better,
> > and as now I don't see any bad consequences.
>
> Do we have any means to quantify the effect?
>
> I do understand the racy nature of the effective protection values. We
> do update them in mem_cgroup_protected and that handles the
> reclaim_target == memcg case already. So why do we care later on in
> mem_cgroup_protection? And why don't we care about any other concurrent
> reclaimers which have a different reclaim memcg target? This just
> doesn't make any sense.
>

No, you missed the point.
The issue pointed by me isn't related with racy.  Roman also explained
that the racy is not the point.

> Either we do care about races because they are harmful and then we care
> for all possible case or we don't and this patch doesn't really any big
> value. Or I still miss the point.
>

The real point is memcg relcaim will get a wrong value from
mem_cgroup_protection() after memory.emin is set.
Suppose target memcg has memory.current is 2G and memory.min is 2G, in
memcg reclaim, the scan count will be
(SWAP_CLUSTER_MAX>>sc->priority), rather than (lruvec_size >>
sc->priority). That's a slowdown, and that's explained by Roman as
well.



-- 
Thanks
Yafang
