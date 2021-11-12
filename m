Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C64844EC8C
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 19:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhKLSXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 13:23:16 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]:36505 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbhKLSXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 13:23:14 -0500
Received: by mail-qk1-f171.google.com with SMTP id i9so9965986qki.3;
        Fri, 12 Nov 2021 10:20:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JWiZ8wXdpr+ymeir7wbIGENhhh+/R2m3VvP1Bfr2oM4=;
        b=M4sqScv+84j7gLvwUxmu6S4lXTe+X93ITsYiARqNdYmNbPT4aOMr84UVcmAisFoIIJ
         6gbO498HNa6zb/Gna5vDtcyOAHK+P8AqNQuX8AV1kCdz+G6pKsOnYZrDHU18lXTmgVTM
         hA72RHHm2YrIOS7XDTQm/4gls912uAX0/S6Ia8vBdVcFIsnO2xaJ8S1lpevbJ6AjqH0l
         UneOT9GQ46layqTKGDxEXyghxu2Tft9VfzanHi1UAcNx6O4hIYC10sk1shRqSY7yumhk
         Iymw7LKkzMggkaKrbzlm+bcaXTy1IX/gWP3eh8oNiv4INfF9BPBmXBUpW1watnA48Ij5
         FaKg==
X-Gm-Message-State: AOAM532sH57IVLFNC1/5cCr93ozslstiiyWU/78rJjAQuBBA5wjjUwfg
        y3z325UG/xlBCr6kqRvP5fRpFxRvi/IX2Q==
X-Google-Smtp-Source: ABdhPJzkotWNNE2ix4ZDIU6GFE4z6Dw5dyR82WpPFbAh3UAefUEqzld+CDUVl2jJ1IS+fxcn5BaFvw==
X-Received: by 2002:a05:620a:1468:: with SMTP id j8mr14187436qkl.170.1636741222425;
        Fri, 12 Nov 2021 10:20:22 -0800 (PST)
Received: from fedora (pool-173-68-57-129.nycmny.fios.verizon.net. [173.68.57.129])
        by smtp.gmail.com with ESMTPSA id e15sm3289846qtp.94.2021.11.12.10.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 10:20:22 -0800 (PST)
Date:   Fri, 12 Nov 2021 13:20:20 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, amakhalov@vmware.com, cl@linux.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, tj@kernel.org
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <YY6wZMcx/BeddUnH@fedora>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Tue, Nov 09, 2021 at 12:00:46PM +0100, Michal Hocko wrote:
> On Tue 09-11-21 09:42:56, David Hildenbrand wrote:
> > On 09.11.21 09:37, Michal Hocko wrote:
> > > I have opposed this patch http://lkml.kernel.org/r/YYj91Mkt4m8ySIWt@dhcp22.suse.cz
> > > There was no response to that feedback. I will not go as far as to nack
> > > it explicitly because pcp allocator is not an area I would nack patches
> > > but seriously, this issue needs a deeper look rather than a paper over
> > > patch. I hope we do not want to do a similar thing to all callers of
> > > cpu_to_mem.
> > 
> > While we could move it into the !HOLES version of cpu_to_mem(), calling
> > cpu_to_mem() on an offline (and eventually not even present) CPU (with
> > an offline node) is really a corner case.
> > 
> > Instead of additional runtime overhead for all cpu_to_mem(), my take
> > would be to just do it for the random special cases. Sure, we can
> > document that people should be careful when calling cpu_to_mem() on
> > offline CPUs. But IMHO it's really a corner case.
> 
> I suspect I haven't made myself clear enough. I do not think we should
> be touching cpu_to_mem/cpu_to_node and handle this corner case. We
> should be looking at the underlying problem instead. We cannot really
> rely on cpu to be onlined to have a proper node association. We should
> really look at the initialization code and handle this situation
> properly. Memory less nodes are something we have been dealing with
> already. This particular instance of the problem is new and we should
> understand why.
> -- 
> Michal Hocko
> SUSE Labs

So I think we're still short a solution here. This patch solves the side
effect but not the underlying problem related to cpu hotplug.

I'm fine with this going in as a stop gap because I imagine the fixes to
hotplug are a lot more intrusive, but do we have someone who can own
that work to fix hotplug? I think that should be a requirement for
taking this because clearly it's hotplug that's broken and not percpu.

Acked-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis
