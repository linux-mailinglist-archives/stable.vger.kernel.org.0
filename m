Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9928C23E189
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 20:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgHFSxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 14:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgHFSxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 14:53:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7197B206A2;
        Thu,  6 Aug 2020 18:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596740019;
        bh=w//eizxwsAVrv+YPmS3JX4NMqcajxqnj5JXlDU41V9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qmg8P7JiHebGl+XnPaxN10Hvl7XUXGsKieVGY6wx5pNCJU+TL9eSSZLg14F1BMhzS
         9IIlLt0mBO+mNtjhJmQcaCT/TwDyaHy55xIKOUqjg59mz9C5HlUGlEFkfYxQS8ImI0
         lILF5Q/NmyZtnDqz12wG8Y1zccsQ3dy651vOsQAw=
Date:   Thu, 6 Aug 2020 20:53:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        x86 <x86@kernel.org>
Subject: Re: [tip: perf/core] perf/core: Fix endless multiplex timer
Message-ID: <20200806185353.GA2942033@kroah.com>
References: <20200305123851.GX2596@hirez.programming.kicks-ass.net>
 <158470908175.28353.4859180707604949658.tip-bot2@tip-bot2>
 <abd1dde6-2761-ae91-195c-cd7c4e4515c6@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abd1dde6-2761-ae91-195c-cd7c4e4515c6@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 07:11:24PM +0100, Robin Murphy wrote:
> On 2020-03-20 12:58, tip-bot2 for Peter Zijlstra wrote:
> > The following commit has been merged into the perf/core branch of tip:
> > 
> > Commit-ID:     90c91dfb86d0ff545bd329d3ddd72c147e2ae198
> > Gitweb:        https://git.kernel.org/tip/90c91dfb86d0ff545bd329d3ddd72c147e2ae198
> > Author:        Peter Zijlstra <peterz@infradead.org>
> > AuthorDate:    Thu, 05 Mar 2020 13:38:51 +01:00
> > Committer:     Peter Zijlstra <peterz@infradead.org>
> > CommitterDate: Fri, 20 Mar 2020 13:06:22 +01:00
> > 
> > perf/core: Fix endless multiplex timer
> > 
> > Kan and Andi reported that we fail to kill rotation when the flexible
> > events go empty, but the context does not. XXX moar
> > 
> > Fixes: fd7d55172d1e ("perf/cgroups: Don't rotate events for cgroups unnecessarily")
> 
> Can this patch (commit 90c91dfb86d0 ("perf/core: Fix endless multiplex
> timer") upstream) be applied to stable please? For PMU drivers built as
> modules, the bug can actually kill the system, since the runaway hrtimer
> loop keeps calling pmu->{enable,disable} after all the events have been
> closed and dropped their references to pmu->module. Thus legitimately
> unloading the module once things have got into this state quickly results in
> a crash when those callbacks disappear.
> 
> (FWIW I spent about two days fighting with this while testing a new driver
> as a module against the 5.3 kernel installed on someone else's machine,
> assuming it was a bug in my code...)

What exactly kernel(s) do you wish for it to be applied to?  It's
already in the latest stable releases of 5.7.y.

thanks,

greg k-h
