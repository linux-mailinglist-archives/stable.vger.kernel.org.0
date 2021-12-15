Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176124755C2
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 11:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhLOKFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 05:05:14 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:35514 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbhLOKFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 05:05:13 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5955F1F382;
        Wed, 15 Dec 2021 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639562712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OAAzviErppZGCS8tC7thMjgNf1ikMh2wNe6PPnH5tIU=;
        b=SW29Usn8ahZEdr7Pb16D31fYyr1zZk8aBIHkD0IBgfvQzyaBgkRoevLfMJtjnzX7iPndpT
        8nz8VGl+BHZ7DnHWAevRMiWvK1KzHeQ3nHVQ0znoGVvQe37MyP7VSKKXkpWpIW7yNnMADz
        cmSOJsFpE0E6dvbI2lf9sIDFv2UtZWo=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 21AF9A3B83;
        Wed, 15 Dec 2021 10:05:12 +0000 (UTC)
Date:   Wed, 15 Dec 2021 11:05:11 +0100
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
Message-ID: <Ybm91+/z8hKuiHYr@dhcp22.suse.cz>
References: <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
 <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
 <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
 <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
 <YZMq++inSmJegJmj@fedora>
 <Ybht6kqwI0aPx3Jr@dhcp22.suse.cz>
 <20211214125748.974a400f0b05a633f9b971b7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214125748.974a400f0b05a633f9b971b7@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 14-12-21 12:57:48, Andrew Morton wrote:
> On Tue, 14 Dec 2021 11:11:54 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > I need some clarification here. It sounds like memoryless nodes work on
> > > x86, but hotplug + memoryless nodes isn't a supported use case or you're
> > > introducing it as a new use case?
> > > 
> > > If this is a new use case, then I'm inclined to say this patch should
> > > NOT go in and a proper fix should be implemented on hotplug's side. I
> > > don't want to be in the business of having/seeing this conversation
> > > reoccur because we just papered over this issue in percpu.
> > 
> > The patch still seems to be in the mmotm tree. I have sent a different
> > fix candidate [1] which should be more robust and cover also other potential
> > places.
> > 
> > [1] http://lkml.kernel.org/r/20211214100732.26335-1-mhocko@kernel.org
> 
> Is cool, I'm paying attention.
> 
> We do want something short and simple for backporting to -stable (like
> Alexey's patch) so please bear that in mind while preparing an
> alternative.

I think we want something that fixes the underlying problem. Please keep
in mind that the pcp allocation is not the only place to hit the issue.
We have more. I do not want we want to handle each and every one
separately.

I am definitly not going to push for my solution but if there is a
consensus this is the right approach then I do not think we really want
to implement these partial workarounds.

-- 
Michal Hocko
SUSE Labs
