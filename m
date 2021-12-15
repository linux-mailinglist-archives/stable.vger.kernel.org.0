Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AC34758BC
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 13:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbhLOMVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 07:21:13 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57922 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242384AbhLOMVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 07:21:08 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0F3DF212C1;
        Wed, 15 Dec 2021 12:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639570862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sCQuKlEuH5PJS4RgJOInUUe+I9iRj43vidhR7aKJ1wk=;
        b=AuQ7HusEJBwwsUOHdHqobSrnXD2eF0GLsHke7nrjev1p2Sx5f5rIPJd0oKcASUkGLLMeq7
        QplHpL2iC97GHxeUCk1eyTQ17uiILeI1PxYmQpS49xCWa0w5TrUvqW6Z+NeBySPCYEMMx9
        hf5/13lOTk5qNcP7EbVAkSBH0SlFFMI=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D1234A3B81;
        Wed, 15 Dec 2021 12:21:01 +0000 (UTC)
Date:   Wed, 15 Dec 2021 13:20:58 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>,
        Alexey Makhalov <amakhalov@vmware.com>,
        "cl@linux.com" <cl@linux.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <Ybndqj/15Mc+GfU2@dhcp22.suse.cz>
References: <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
 <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
 <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
 <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
 <YZMq++inSmJegJmj@fedora>
 <Ybht6kqwI0aPx3Jr@dhcp22.suse.cz>
 <20211214125748.974a400f0b05a633f9b971b7@linux-foundation.org>
 <Ybm91+/z8hKuiHYr@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybm91+/z8hKuiHYr@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 15-12-21 11:05:12, Michal Hocko wrote:
> On Tue 14-12-21 12:57:48, Andrew Morton wrote:
> > On Tue, 14 Dec 2021 11:11:54 +0100 Michal Hocko <mhocko@suse.com> wrote:
> > 
> > > > I need some clarification here. It sounds like memoryless nodes work on
> > > > x86, but hotplug + memoryless nodes isn't a supported use case or you're
> > > > introducing it as a new use case?
> > > > 
> > > > If this is a new use case, then I'm inclined to say this patch should
> > > > NOT go in and a proper fix should be implemented on hotplug's side. I
> > > > don't want to be in the business of having/seeing this conversation
> > > > reoccur because we just papered over this issue in percpu.
> > > 
> > > The patch still seems to be in the mmotm tree. I have sent a different
> > > fix candidate [1] which should be more robust and cover also other potential
> > > places.
> > > 
> > > [1] http://lkml.kernel.org/r/20211214100732.26335-1-mhocko@kernel.org
> > 
> > Is cool, I'm paying attention.
> > 
> > We do want something short and simple for backporting to -stable (like
> > Alexey's patch) so please bear that in mind while preparing an
> > alternative.
> 
> I think we want something that fixes the underlying problem. Please keep
> in mind that the pcp allocation is not the only place to hit the issue.
> We have more. I do not want we want to handle each and every one
> separately.
> 
> I am definitly not going to push for my solution but if there is a
> consensus this is the right approach then I do not think we really want
> to implement these partial workarounds.

Btw. I forgot to add that if we do not agree on the preallocation
approach then the approach should be something like 
http://lkml.kernel.org/r/51c65635-1dae-6ba4-daf9-db9df0ec35d8@redhat.com
proposed by David.
-- 
Michal Hocko
SUSE Labs
