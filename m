Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253161B7859
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgDXOdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 10:33:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35846 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgDXOdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 10:33:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id u127so11022826wmg.1
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 07:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1dmTq9GYPFXiIasqQmCsmDhwPpqRF+E4SKqVryAxjAs=;
        b=jJkcaCiMxj2SaMQtok8ALFUqdNhypLq5EB1X2g5rN/qYODMEk8DHiYr0jOFtjoBieV
         C9e2elYqsPi2K1Td1HcFF6X7T9flu+zjnOcJVcyk35RxpnEAi7DUk9lQxOm8slsAunno
         ACZcretQOx5/Uq9eg0uldF1ACpgJaaTw1A7ReTr0CR8IuPhFMVrtNpA7k/v3CmU/NV5z
         omiaqfnTN2W+CsKt9uJsaPkIC9HnUEASUyM3Q/VJtdKmY1ZJ9uoOQggRYuUuc0UIXZYb
         9EbyV+Rl0mVNQQqiPHEOb9NPWVDUGlasepIfUcqXBV5QHI9n0g2Xq6SsU7bKj3Hh7qNx
         QR5w==
X-Gm-Message-State: AGi0PuZI4CUGO4BYmUcxk+hWCwMY2fsbNbvrP0oFuiQm7krNOyUrNO7I
        LQhAjSfPEcfQrjIQzkEDOp4=
X-Google-Smtp-Source: APiQypKxPPwhck2+CtPILFT0UzPpuF4y1M2wxk9KzL2S44daGsMJL+fRSi9kEDyC1i4kwgqcAPfQuw==
X-Received: by 2002:a1c:3dd6:: with SMTP id k205mr10495213wma.138.1587738829017;
        Fri, 24 Apr 2020 07:33:49 -0700 (PDT)
Received: from localhost (ip-37-188-130-62.eurotel.cz. [37.188.130.62])
        by smtp.gmail.com with ESMTPSA id h1sm3247165wme.42.2020.04.24.07.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:33:48 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:33:46 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424143346.GG11591@dhcp22.suse.cz>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
 <20200424134438.GA496852@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424134438.GA496852@cmpxchg.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-04-20 09:44:38, Johannes Weiner wrote:
> On Fri, Apr 24, 2020 at 09:14:52AM -0400, Johannes Weiner wrote:
> > However, mem_cgroup_protected() never expected anybody to look at the
> > effective protection values when it indicated that the cgroup is above
> > its protection. As a result, a query during limit reclaim may return
> > stale protection values that were calculated by a previous reclaim
> > cycle in which the cgroup did have siblings.
> 
> Btw, I think there is opportunity to make this a bit less error prone.
> 
> We have a mem_cgroup_protected() that returns yes or no, essentially,
> but protection isn't a binary state anymore.
> 
> It's also been a bit iffy that it looks like a simple predicate
> function, but it indeed needs to run procedurally for each cgroup in
> order for the calculations throughout the tree to be correct.
> 
> It might be better to have a
> 
> 	mem_cgroup_calculate_protection()
> 
> that runs for every cgroup we visit and sets up the internal state;
> then have more self-explanatory query functions on top of that:
> 
> 	mem_cgroup_below_min()
> 	mem_cgroup_below_low()
> 	mem_cgroup_protection()
> 
> What do you guys think?

Fully agreed. I have to say that I have considered the predicate with
side effects really confusing.
-- 
Michal Hocko
SUSE Labs
