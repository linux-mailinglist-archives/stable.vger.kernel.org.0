Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E21008AC
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfKRPwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:52:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:58334 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbfKRPwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 10:52:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C842AB0E6;
        Mon, 18 Nov 2019 15:52:01 +0000 (UTC)
Date:   Mon, 18 Nov 2019 16:52:00 +0100
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
Message-ID: <20191118155200.GG14255@dhcp22.suse.cz>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214842.621065901@linuxfoundation.org>
 <20191017105940.GA5966@amd>
 <20191017110516.GG24485@dhcp22.suse.cz>
 <20191118152558.GA26236@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118152558.GA26236@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 18-11-19 16:25:58, Pavel Machek wrote:
> Hi!
> 
> > > > From: Michal Hocko <mhocko@suse.com>
> > > > 
> > > > commit b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40 upstream.
> > > > 
> > > > Partially revert 16db3d3f1170 ("kernel/sysctl.c: threads-max observe
> > > > limits") because the patch is causing a regression to any workload which
> > > > needs to override the auto-tuning of the limit provided by kernel.
> > > > 
> > > > set_max_threads is implementing a boot time guesstimate to provide a
> > > > sensible limit of the concurrently running threads so that runaways will
> > > > not deplete all the memory.  This is a good thing in general but there
> > > > are workloads which might need to increase this limit for an application
> > > > to run (reportedly WebSpher MQ is affected) and that is simply not
> > > > possible after the mentioned change.  It is also very dubious to
> > > > override an admin decision by an estimation that doesn't have any direct
> > > > relation to correctness of the kernel operation.
> > > > 
> > > > Fix this by dropping set_max_threads from sysctl_max_threads so any
> > > > value is accepted as long as it fits into MAX_THREADS which is important
> > > > to check because allowing more threads could break internal robust futex
> > > > restriction.  While at it, do not use MIN_THREADS as the lower boundary
> > > > because it is also only a heuristic for automatic estimation and admin
> > > > might have a good reason to stop new threads to be created even when
> > > > below this limit.
> > > 
> > > Ok, why not, but I smell followup work could be done:
> > > 
> > > > @@ -2635,7 +2635,7 @@ int sysctl_max_threads(struct ctl_table
> > > >  	if (ret || !write)
> > > >  		return ret;
> > > >  
> > > > -	set_max_threads(threads);
> > > > +	max_threads = threads;
> > > >  
> > > 
> > > AFAICT set_max_threads can now become __init.
> > 
> > Yes. Care to send a patch?
> 
> I'm not usually hacking in that area. Could you do that?

I can put it on my ever growing todo list. But this should be a low
hanging fruit that doesn't really require a deep understanding of the
specific subsystem.

> > > Plus, I don't see any locking here, should this be WRITE_ONCE() at
> > > minimum?
> > 
> > Why would that matter? Do you expect several root processes race to set
> > the value?
> 
> Well, for example to warn humans that this code is accessing unlocked
> variable. Second, as is, code is not valid C and compilers are
> allowed to do strange stuff ("undefined behaviour"). Third, there are
> concurency checkers that will not like this one.

I do not see any undefined behahvior in assigning an integer in a
lockless manner if there are no actual consistency issues. If this is
not the case then please do describe them in a specific manner.
-- 
Michal Hocko
SUSE Labs
