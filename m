Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059BA22BC61
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 05:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXDOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 23:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXDOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 23:14:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DDF220792;
        Fri, 24 Jul 2020 03:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595560445;
        bh=7Nn2vijdOpJYv5RRp0kMLo2D//KQ22IaqcB8VQUTtz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HlRbJgYKPEVZSsXegUjp/2v7/SwgSpMQYylFMhoicS2JzBa03usl8BoFyGcmB0z7B
         n1RyZpC+bJY2hnWvW8bJMa6OVOAmq5NvlrrjyOpBEEthdHyI0RlDSmPeTj65hZZO8B
         AcF2dBRPplDmW6/IEOxvQzpgoKWBdUIrGGEFs5xo=
Date:   Thu, 23 Jul 2020 20:14:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Joonsoo Kim <js1304@gmail.com>
Cc:     Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: fix memalloc_nocma_{save/restore}
 APIs
Message-Id: <20200723201404.f76ccd792c9e74f3ae8ec9f5@linux-foundation.org>
In-Reply-To: <CAAmzW4NhY0iaE02vwf+2O+aeK66CoKG_-BvsgqpfwZv3Q-w8dA@mail.gmail.com>
References: <1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com>
        <20200723180814.acde28b92ce6adc785a79120@linux-foundation.org>
        <CAAmzW4N9Y4W7CHenWA=TYu9tttgpYR=ZN+ky1vmXPgUJcjitAw@mail.gmail.com>
        <20200723193600.28e3eedd00925b22f7ca9780@linux-foundation.org>
        <CAAmzW4NhY0iaE02vwf+2O+aeK66CoKG_-BvsgqpfwZv3Q-w8dA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Jul 2020 12:04:02 +0900 Joonsoo Kim <js1304@gmail.com> wrote:

> 2020년 7월 24일 (금) 오전 11:36, Andrew Morton <akpm@linux-foundation.org>님이 작성:
> >
> > On Fri, 24 Jul 2020 11:23:52 +0900 Joonsoo Kim <js1304@gmail.com> wrote:
> >
> > > > > Second, clearing __GFP_MOVABLE in current_gfp_context() has a side effect
> > > > > to exclude the memory on the ZONE_MOVABLE for allocation target.
> > > >
> > > > More whoops.
> > > >
> > > > Could we please have a description of the end-user-visible effects of
> > > > this change?  Very much needed when proposing a -stable backport, I think.
> > >
> > > In fact, there is no noticeable end-user-visible effect since the fallback would
> > > cover the problematic case. It's mentioned in the commit description. Perhap,
> > > performance would be improved due to reduced retry and more available memory
> > > (we can use ZONE_MOVABLE with this patch) but it would be neglectable.
> > >
> > > > d7fefcc8de9147c is over a year old.  Why did we only just discover
> > > > this?  This makes one wonder how serious those end-user-visible effects
> > > > are?
> > >
> > > As mentioned above, there is no visible problem to the end-user.
> >
> > OK, thanks.  In that case, I don't believe that a stable backport is
> > appropriate?
> >
> > (Documentation/process/stable-kernel-rules.rst)
> 
> Thanks for the pointer!
> 
> Hmm... I'm not sure the correct way to handle this patch. I thought that
> memalloc_nocma_{save,restore} is an API that is callable from the module.
> If it is true, it's better to regard this patch as the stable candidate since
> out-of-tree modules could use it without the fallback and it would cause
> a problem. But, yes, there is no visible problem to the end-user, at least,
> within the mainline so it is possibly not a stable candidate.
> 
> Please share your opinion about this situation.

We tend not to care much about out-of-tree modules.  I don't think a
theoretical concern for out-of-tree code justifies risking the
stability of -stable kernels.

