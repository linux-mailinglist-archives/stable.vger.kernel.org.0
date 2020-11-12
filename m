Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1AD2B1207
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 23:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgKLWte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 17:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgKLWte (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 17:49:34 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61FCA2085B;
        Thu, 12 Nov 2020 22:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605221360;
        bh=N2fT6BovsDy9Ao7zSSbwkfqL4sixyk1hOcDkGMQ4iuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gBGKEhePfVob0pPdepdYdfcFpZ71O1UuGLdwuEphsS6uLXqnub4VW9HGPgeaMVrcJ
         RB5hum3NYpfQaSCzYWbkC2uEBCwjZnX/0BpWFtRDOsSQg8scFebwFeRTiPkCyKBxjy
         wcYYCNbTUAR6xawMwyumo4CLQ9h6ZiI3/mcwSdGo=
Date:   Thu, 12 Nov 2020 14:49:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert
 "mm/vunmap: add cond_resched() in vunmap_pmd_range"
Message-Id: <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
In-Reply-To: <20201112200101.GC123036@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
        <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
        <20201107083939.GA1633068@google.com>
        <20201112200101.GC123036@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Nov 2020 12:01:01 -0800 Minchan Kim <minchan@kernel.org> wrote:

> 
> On Sat, Nov 07, 2020 at 12:39:39AM -0800, Minchan Kim wrote:
> > Hi Andrew,
> > 
> > On Fri, Nov 06, 2020 at 05:59:33PM -0800, Andrew Morton wrote:
> > > On Thu,  5 Nov 2020 09:02:49 -0800 Minchan Kim <minchan@kernel.org> wrote:
> > > 
> > > > This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> > > > 
> > > > While I was doing zram testing, I found sometimes decompression failed
> > > > since the compression buffer was corrupted. With investigation,
> > > > I found below commit calls cond_resched unconditionally so it could
> > > > make a problem in atomic context if the task is reschedule.
> > > > 
> > > > Revert the original commit for now.
>
> How should we proceed this problem?
>

(top-posting repaired - please don't).

Well, we don't want to reintroduce the softlockup reports which
e47110e90584a2 fixed, and we certainly don't want to do that on behalf
of code which is using the unmap_kernel_range() interface incorrectly.

So I suggest either

a) make zs_unmap_object() stop doing the unmapping from atomic context or

b) figure out whether the vmalloc unmap code is *truly* unsafe from
   atomic context - perhaps it is only unsafe from interrupt context,
   in which case we can rework the vmalloc.c checks to reflect this, or

c) make the vfree code callable from all contexts.  Which is by far
   the preferred solution, but may be tough.


Or maybe not so tough - if the only problem in the vmalloc code is the
use of mutex_trylock() from irqs then it may be as simple as switching
to old-style semaphores and using down_trylock(), which I think is
irq-safe.

However old-style semaphores are deprecated.  A hackyish approach might
be to use an rwsem always in down_write mode and use
down_write_trylock(), which I think is also callable from interrrupt
context.

But I have a feeling that there are other reasons why vfree shouldn't
be called from atomic context, apart from the mutex_trylock-in-irq
issue.
