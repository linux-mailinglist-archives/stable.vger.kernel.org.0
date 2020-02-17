Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470C2161340
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 14:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgBQNYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 08:24:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53374 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgBQNYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 08:24:48 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so17145055wmh.3
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 05:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5dkQgPE9L5LB87LYvgYERUBPRBzO7AwTWjajMNSOj1k=;
        b=GzZRP8H8ssRsWZorEIuRDg6AJsUUThtw3tBIlOSIB03lc0QpwY+FC+huIKdfxeYZur
         LFOdUs6RSnS+aiRETcqVe3HnuYF0rKongZ2Vjxcy808CYIBPlNckjfX3jhhrpdEybpqD
         V5eZx81skM9p/aionvRYCVyiGaPdcKDDXAs0LsayNxF7Xpv636pqa/CJhXV81NsunNGT
         4yemyC5Wvo6MOiByPg3HvSopucuGz8mZSnbW9Xgc938PvYziNvKLXk1UAkV01QqaYP1G
         wtTLVczl4X6xZ/MssT+7v+K0RTGXPtNRgPuy2RgcfNfh9Y6TlW+FOAahnnCdeHwwWAOr
         zdAA==
X-Gm-Message-State: APjAAAVZK6vuG5byJCpLG9rfF+Yr8o1y30cjzZ54GQUlhS3lnDy7oFke
        vA4R7lYSMCF38k00XrjZrb6Hv/zF
X-Google-Smtp-Source: APXvYqyuJVhTme6dNyn9eOJj4i5TBbNgNXy/l6eJfzz62HxGRdIayLKDm6TKwRfqZYDgxo43JDDaUw==
X-Received: by 2002:a05:600c:54e:: with SMTP id k14mr21459023wmc.115.1581945885771;
        Mon, 17 Feb 2020 05:24:45 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id i204sm601920wma.44.2020.02.17.05.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 05:24:44 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:24:43 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
Message-ID: <20200217132443.GM31531@dhcp22.suse.cz>
References: <20200216145249.6900-1-laoar.shao@gmail.com>
 <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > them won't be changed until next recalculation in this function. After
> > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > the old values of them will be used to calculate scan count, that is not
> > > proper. We should reset them to zero in this case.
> > >
> > > Here's an example of this issue.
> > >
> > >     root_mem_cgroup
> > >          /
> > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > >
> > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > this A, and it will assign memory.emin of A with 512M.
> > > After that, A may reach its hard limit(memory.max), and then it will
> > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > not calculate its memory.emin. So the memory.emin is the old value
> > > 512M, and then this old value will be used in
> > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > That is not proper.
> >
> > Please document user visible effects of this patch. What does it mean
> > that this is not proper behavior?
> 
> In the memcg reclaim, if the target memcg is the root of the reclaimer,
> the reclaimer should scan this memcg's all page cache pages in the LRU,
> but now as the old memcg.{emin, elow} value are still there, it will get
> a wrong protection value,
> and the reclaimer can't reclaim the page cache pages protected by this
> wrong protection.

Could you be more specific please. Your example above says that emin is
not going to be recalculated and stays at 512M even for a potential max
limit reclaim. The min limit is still 512M so why is this value wrong?

> > What happens if we have concurrent
> > reclaimers at different levels of the hierarchy how that would affect
> > the resulting protection?
> >
> 
> Well, I thought the synchronization mechanisms have already existed ?
> Otherwise there must be concurrent issue in the original code of
> setting the memcg.{emin, elow} as well.
> (Because memcg->memory.{emin, elow} are also set at the end of the
> function mem_cgroup_protected())

This function is documented to be racy and I believe this is OK because
it doesn't really have to be precise and concurrent updates are not
going to change values much. But does the same apply to reseting the
effective values? Maybe yes. Make sure to document this in the changelog
please.

-- 
Michal Hocko
SUSE Labs
