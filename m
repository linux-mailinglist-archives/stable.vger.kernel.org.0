Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E45153203
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 14:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgBENjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 08:39:25 -0500
Received: from foss.arm.com ([217.140.110.172]:47394 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbgBENjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 08:39:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4773131B;
        Wed,  5 Feb 2020 05:39:24 -0800 (PST)
Received: from [10.1.195.32] (e112269-lin.cambridge.arm.com [10.1.195.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 218BE3F52E;
        Wed,  5 Feb 2020 05:39:23 -0800 (PST)
Subject: Re: [PATCH 1/2] drm/panfrost: Make sure MMU context lifetime is not
 bound to panfrost_priv
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Icecream95 <ixn@keemail.me>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <20200204143504.135388-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <b798bc8f-e8a9-01e9-e234-a8fdef290259@arm.com>
Date:   Wed, 5 Feb 2020 13:39:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200204143504.135388-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/02/2020 14:35, Boris Brezillon wrote:
> Jobs can be in-flight when the file descriptor is closed (either because
> the process did not terminate properly, or because it didn't wait for
> all GPU jobs to be finished), and apparently panfrost_job_close() does
> not cancel already running jobs. Let's refcount the MMU context object
> so it's lifetime is no longer bound to the FD lifetime and running jobs
> can finish properly without generating spurious page faults.

Is there any good reason not to just make panfrost_job_close() kill off
any running jobs? I'm not sure what the benefit is of allowing the jobs
to still run after the file descriptor has closed.

In particular this could cause problems when(/if) Panfrost starts trying
to deal with "compute" work loads that might have long runtimes. It's
quite possible to produce a job which never (naturally) exits, currently
we have a simplistic timeout which kills anything which doesn't complete
promptly. However there is nothing conceptually wrong with a job which
takes seconds (or even minutes) to complete. The hardware has support
for task switching ('soft stopping') between jobs so this can be done to
prevent blocking other applications.

If panfrost_job_close() doesn't kill the jobs then removing the timeouts
could lead to the situation where there is an 'infinite' job with no
owner and no way of killing it off. Which doesn't seem like a great
feature ;)

Another approach could be simply to silence the page fault output in
this case - switching the address space to UNMAPPED is actually an
effective way of killing jobs - at some point I think this was a
workaround to a hardware bug, but IIRC that was unreleased hardware :)

Steve
