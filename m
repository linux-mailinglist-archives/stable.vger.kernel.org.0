Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FDE4502A7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 11:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhKOKoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 05:44:19 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:38774 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhKOKoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 05:44:16 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 697CD2191E;
        Mon, 15 Nov 2021 10:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636972880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PVNsXCJ9mV2w4AZVO8KqrAIByVUi1c/2ydEbDb/Gq5E=;
        b=tETV2wL7aCu9rtbFwfaA0m2uCCAnnjwWT6nTObjNQAbxU7VWzGnCCaSGEE4VjS05QPEaFY
        UII9ty6Db0St2c8XSA3ydKRFg6XyWYaNvQvU3oxvfCJccC81BdNvzIsegKEf/2KeLBsxGd
        2R36tsg6/jLPF2J6enNxeL2kUxSMgCY=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 368BEA3B84;
        Mon, 15 Nov 2021 10:41:20 +0000 (UTC)
Date:   Mon, 15 Nov 2021 11:41:16 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, amakhalov@vmware.com, cl@linux.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, tj@kernel.org
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
 <YY6wZMcx/BeddUnH@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY6wZMcx/BeddUnH@fedora>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 12-11-21 13:20:20, Dennis Zhou wrote:
> Hello,
> 
> On Tue, Nov 09, 2021 at 12:00:46PM +0100, Michal Hocko wrote:
> > On Tue 09-11-21 09:42:56, David Hildenbrand wrote:
> > > On 09.11.21 09:37, Michal Hocko wrote:
> > > > I have opposed this patch http://lkml.kernel.org/r/YYj91Mkt4m8ySIWt@dhcp22.suse.cz
> > > > There was no response to that feedback. I will not go as far as to nack
> > > > it explicitly because pcp allocator is not an area I would nack patches
> > > > but seriously, this issue needs a deeper look rather than a paper over
> > > > patch. I hope we do not want to do a similar thing to all callers of
> > > > cpu_to_mem.
> > > 
> > > While we could move it into the !HOLES version of cpu_to_mem(), calling
> > > cpu_to_mem() on an offline (and eventually not even present) CPU (with
> > > an offline node) is really a corner case.
> > > 
> > > Instead of additional runtime overhead for all cpu_to_mem(), my take
> > > would be to just do it for the random special cases. Sure, we can
> > > document that people should be careful when calling cpu_to_mem() on
> > > offline CPUs. But IMHO it's really a corner case.
> > 
> > I suspect I haven't made myself clear enough. I do not think we should
> > be touching cpu_to_mem/cpu_to_node and handle this corner case. We
> > should be looking at the underlying problem instead. We cannot really
> > rely on cpu to be onlined to have a proper node association. We should
> > really look at the initialization code and handle this situation
> > properly. Memory less nodes are something we have been dealing with
> > already. This particular instance of the problem is new and we should
> > understand why.
> > -- 
> > Michal Hocko
> > SUSE Labs
> 
> So I think we're still short a solution here. This patch solves the side
> effect but not the underlying problem related to cpu hotplug.
> 
> I'm fine with this going in as a stop gap because I imagine the fixes to
> hotplug are a lot more intrusive, but do we have someone who can own
> that work to fix hotplug? I think that should be a requirement for
> taking this because clearly it's hotplug that's broken and not percpu.

I have asked several times for details about the specific setup that has
led to the reported crash. Without much success so far. Reproduction
steps would be the first step. That would allow somebody to work on this
at least if Alexey doesn't have time to dive into this deeper.

I would be more inclined to a stop gap workaround if this was a more
wide spread problem but a lack of other repports suggests this has been
a one off.

The final saying is yours of course.
 
> Acked-by: Dennis Zhou <dennis@kernel.org>
> 
> Thanks,
> Dennis

-- 
Michal Hocko
SUSE Labs
