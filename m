Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE8FDAAC6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 13:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfJQLFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 07:05:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:34468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728464AbfJQLFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 07:05:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6320B302;
        Thu, 17 Oct 2019 11:05:17 +0000 (UTC)
Date:   Thu, 17 Oct 2019 13:05:16 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 56/81] kernel/sysctl.c: do not override max_threads
 provided by userspace
Message-ID: <20191017110516.GG24485@dhcp22.suse.cz>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214842.621065901@linuxfoundation.org>
 <20191017105940.GA5966@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017105940.GA5966@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 17-10-19 12:59:40, Pavel Machek wrote:
> Hi!
> 
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > commit b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40 upstream.
> > 
> > Partially revert 16db3d3f1170 ("kernel/sysctl.c: threads-max observe
> > limits") because the patch is causing a regression to any workload which
> > needs to override the auto-tuning of the limit provided by kernel.
> > 
> > set_max_threads is implementing a boot time guesstimate to provide a
> > sensible limit of the concurrently running threads so that runaways will
> > not deplete all the memory.  This is a good thing in general but there
> > are workloads which might need to increase this limit for an application
> > to run (reportedly WebSpher MQ is affected) and that is simply not
> > possible after the mentioned change.  It is also very dubious to
> > override an admin decision by an estimation that doesn't have any direct
> > relation to correctness of the kernel operation.
> > 
> > Fix this by dropping set_max_threads from sysctl_max_threads so any
> > value is accepted as long as it fits into MAX_THREADS which is important
> > to check because allowing more threads could break internal robust futex
> > restriction.  While at it, do not use MIN_THREADS as the lower boundary
> > because it is also only a heuristic for automatic estimation and admin
> > might have a good reason to stop new threads to be created even when
> > below this limit.
> 
> Ok, why not, but I smell followup work could be done:
> 
> > @@ -2635,7 +2635,7 @@ int sysctl_max_threads(struct ctl_table
> >  	if (ret || !write)
> >  		return ret;
> >  
> > -	set_max_threads(threads);
> > +	max_threads = threads;
> >  
> 
> AFAICT set_max_threads can now become __init.

Yes. Care to send a patch?

> Plus, I don't see any locking here, should this be WRITE_ONCE() at
> minimum?

Why would that matter? Do you expect several root processes race to set
the value?
-- 
Michal Hocko
SUSE Labs
