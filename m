Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64CB44AC30
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 12:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245561AbhKILDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 06:03:41 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:44556 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbhKILDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 06:03:41 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CA324218B0;
        Tue,  9 Nov 2021 11:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636455654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=41Cyo/hMei2kmUmbpToJbVcXlj7u0VEEJZBij8c44T4=;
        b=rU3HghRaRnLHqlK1DMI/WDwk63A7cdlqcjv3bnyCf+0PoIBXAakd//+3P3PnoPwxBVvr3/
        GhU5BO4ABLAMnaNBg3uN3kGf87rdGMIf9OvYHkHCZT7ScK4kTD/jnDvWGmoQes37OCZGIF
        UanpITJBU3oM7Yo2K9zUn+acsEKuC5Y=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 295BAA3B8C;
        Tue,  9 Nov 2021 11:00:53 +0000 (UTC)
Date:   Tue, 9 Nov 2021 12:00:46 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     amakhalov@vmware.com, cl@linux.com, dennis@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, tj@kernel.org
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 09-11-21 09:42:56, David Hildenbrand wrote:
> On 09.11.21 09:37, Michal Hocko wrote:
> > I have opposed this patch http://lkml.kernel.org/r/YYj91Mkt4m8ySIWt@dhcp22.suse.cz
> > There was no response to that feedback. I will not go as far as to nack
> > it explicitly because pcp allocator is not an area I would nack patches
> > but seriously, this issue needs a deeper look rather than a paper over
> > patch. I hope we do not want to do a similar thing to all callers of
> > cpu_to_mem.
> 
> While we could move it into the !HOLES version of cpu_to_mem(), calling
> cpu_to_mem() on an offline (and eventually not even present) CPU (with
> an offline node) is really a corner case.
> 
> Instead of additional runtime overhead for all cpu_to_mem(), my take
> would be to just do it for the random special cases. Sure, we can
> document that people should be careful when calling cpu_to_mem() on
> offline CPUs. But IMHO it's really a corner case.

I suspect I haven't made myself clear enough. I do not think we should
be touching cpu_to_mem/cpu_to_node and handle this corner case. We
should be looking at the underlying problem instead. We cannot really
rely on cpu to be onlined to have a proper node association. We should
really look at the initialization code and handle this situation
properly. Memory less nodes are something we have been dealing with
already. This particular instance of the problem is new and we should
understand why.
-- 
Michal Hocko
SUSE Labs
