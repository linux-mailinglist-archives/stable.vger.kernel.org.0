Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70685161419
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 15:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgBQOEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 09:04:34 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40602 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgBQOEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 09:04:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so18591315wmi.5
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 06:04:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bTSXX2tzVgPrIDb/nP/w/B7H+mftA9xhun3z7FKYpWQ=;
        b=tAiw/9AVxHiJ9BkLbtJKll4OEnSTFT1701LH+0A2eVUcR1p/xz6c3WZLk1o2toAyvt
         cwCIF7DfPqN1PqVf7xIFcVaKbhjt094/fK9VaKbxsi9Gb1tBZLuO05d9id8DmHcWAJNT
         HBKYiiCy2Zw8JuA2/41+66y1my8e2DYlbcMoIACd4o8SypzP24fSnBOASpGUNoREu8Jo
         FQYEE3Sn2usLM8Uhv9z8Kf6yO3u7UiairL72LENpDWaIEPgPSUuSFw2IGB8iz/lfxi1v
         9Pd08uhIM3hwkuVYF9X1nF1JekCoArMZsAU2yv0zdWnx8EBcwq4kLEcjghTlxfIyohLR
         nqww==
X-Gm-Message-State: APjAAAWCJSfSR+NIdLJe6DvVBmCxCJ2vvNVYitNRliyLp6IH+oN6IjmB
        gMjh5KqFLfyMKW78FYPpPO4=
X-Google-Smtp-Source: APXvYqzmOxVK9r/xnCHWXDkzgzhjA0g3fMfXnd9WMeBsWLvvwSP2iE7RSGtQCcv7muMI3oX6iLtnTw==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr23387814wmo.12.1581948272336;
        Mon, 17 Feb 2020 06:04:32 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id x17sm1123676wrt.74.2020.02.17.06.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 06:04:31 -0800 (PST)
Date:   Mon, 17 Feb 2020 15:04:30 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
Message-ID: <20200217140430.GO31531@dhcp22.suse.cz>
References: <20200216145249.6900-1-laoar.shao@gmail.com>
 <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
 <20200217132443.GM31531@dhcp22.suse.cz>
 <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 17-02-20 21:51:23, Yafang Shao wrote:
> On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > > them won't be changed until next recalculation in this function. After
> > > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > > the old values of them will be used to calculate scan count, that is not
> > > > > proper. We should reset them to zero in this case.
> > > > >
> > > > > Here's an example of this issue.
> > > > >
> > > > >     root_mem_cgroup
> > > > >          /
> > > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > > >
> > > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > > this A, and it will assign memory.emin of A with 512M.
> > > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > > 512M, and then this old value will be used in
> > > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > > That is not proper.
> > > >
> > > > Please document user visible effects of this patch. What does it mean
> > > > that this is not proper behavior?
> > >
> > > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > > but now as the old memcg.{emin, elow} value are still there, it will get
> > > a wrong protection value,
> > > and the reclaimer can't reclaim the page cache pages protected by this
> > > wrong protection.
> >
> > Could you be more specific please. Your example above says that emin is
> > not going to be recalculated and stays at 512M even for a potential max
> > limit reclaim. The min limit is still 512M so why is this value wrong?
> >
> 
> Because the relcaimers are changed or the root the relcaimer is changed.
> 
> Kswapd begins to relcaim memcg-A.
> kswapd
>   |
> calculate the {emin, elow} for memcg-A
>  |
> stores {emin, elow} in memory.{emin, elow} of memcg-A
> |
> This memory.{emin, elow} will protect the page cache pages in memcg-A
> (See get_scan_count->mem_cgroup_protection)
> |
> exit
> (And it won't relcaim memcg-A for a long time)
> 
> 
> Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
> and the root of this new reclaimer is memcg-A.
> 
> This memcg relcaimer begins to reclaim memcg-A.
> memcg relcaimer
>       |
> As the root of the relcaimer is memcg-A, it won't calculate emin, elow
> for memcg-A.
> (See if (memcg == root) in mem_cgroup_protected())
>      |
> The old memory.{emin, elow} will protect the page cache pages in memcg-A
> (SO WE SHOULD CLEAR THE OLD VALUE)

I am sorry but I still do not follow. Could you focus on _why_ the old
value is no longer valid?

Btw. have you seen the latest patch from Johannes touching this area
[1]? Is it possible that the issue you are referring to is related with
the one he has fixed?

[1] http://lkml.kernel.org/r/20191219200718.15696-2-hannes@cmpxchg.org

-- 
Michal Hocko
SUSE Labs
