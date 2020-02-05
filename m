Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46406153261
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgBEOBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:01:39 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54112 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgBEOBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 09:01:39 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id ED7AC293653;
        Wed,  5 Feb 2020 14:01:37 +0000 (GMT)
Date:   Wed, 5 Feb 2020 15:01:34 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Icecream95 <ixn@keemail.me>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm/panfrost: Make sure MMU context lifetime is not
 bound to panfrost_priv
Message-ID: <20200205150134.340a72c8@collabora.com>
In-Reply-To: <b798bc8f-e8a9-01e9-e234-a8fdef290259@arm.com>
References: <20200204143504.135388-1-boris.brezillon@collabora.com>
        <b798bc8f-e8a9-01e9-e234-a8fdef290259@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Feb 2020 13:39:21 +0000
Steven Price <steven.price@arm.com> wrote:

> On 04/02/2020 14:35, Boris Brezillon wrote:
> > Jobs can be in-flight when the file descriptor is closed (either because
> > the process did not terminate properly, or because it didn't wait for
> > all GPU jobs to be finished), and apparently panfrost_job_close() does
> > not cancel already running jobs. Let's refcount the MMU context object
> > so it's lifetime is no longer bound to the FD lifetime and running jobs
> > can finish properly without generating spurious page faults.  
> 
> Is there any good reason not to just make panfrost_job_close() kill off
> any running jobs?

Nope, I just didn't know how to do that without stopping all other jobs
(should have looked at how mali_kbase is doing that before posting this
patch :)).

> I'm not sure what the benefit is of allowing the jobs
> to still run after the file descriptor has closed.

None that I can think of.

> 
> In particular this could cause problems when(/if) Panfrost starts trying
> to deal with "compute" work loads that might have long runtimes. It's
> quite possible to produce a job which never (naturally) exits, currently
> we have a simplistic timeout which kills anything which doesn't complete
> promptly. However there is nothing conceptually wrong with a job which
> takes seconds (or even minutes) to complete.

Absolutely. That was also one of my concerns.

> The hardware has support
> for task switching ('soft stopping') between jobs so this can be done to
> prevent blocking other applications.

Okay. I guess it's implemented in mali_kbase. I'll have a look.

> 
> If panfrost_job_close() doesn't kill the jobs then removing the timeouts
> could lead to the situation where there is an 'infinite' job with no
> owner and no way of killing it off. Which doesn't seem like a great
> feature ;)

Didn't know you were planning to remove the timeouts.

> 
> Another approach could be simply to silence the page fault output in
> this case - switching the address space to UNMAPPED is actually an
> effective way of killing jobs - at some point I think this was a
> workaround to a hardware bug, but IIRC that was unreleased hardware :)

Okay. I'll check how it's done in mali_kbase.

Thanks for the feedback.

Boris
