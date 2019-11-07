Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C41F3544
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 18:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKGRCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 12:02:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:47682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726231AbfKGRCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 12:02:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92CBAAB9D;
        Thu,  7 Nov 2019 17:02:01 +0000 (UTC)
Date:   Thu, 7 Nov 2019 18:02:00 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191107170200.GX8314@dhcp22.suse.cz>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191107122125.GS8314@dhcp22.suse.cz>
 <20191107164236.GB2919@castle.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107164236.GB2919@castle.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 07-11-19 16:42:41, Roman Gushchin wrote:
> On Thu, Nov 07, 2019 at 01:21:25PM +0100, Michal Hocko wrote:
> > On Wed 06-11-19 14:51:30, Roman Gushchin wrote:
> > > We've encountered a rcu stall in get_mem_cgroup_from_mm():
> > > 
> > >  rcu: INFO: rcu_sched self-detected stall on CPU
> > >  rcu: 33-....: (21000 ticks this GP) idle=6c6/1/0x4000000000000002 softirq=35441/35441 fqs=5017
> > >  (t=21031 jiffies g=324821 q=95837) NMI backtrace for cpu 33
> > >  <...>
> > >  RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
> > >  <...>
> > >  __memcg_kmem_charge+0x55/0x140
> > >  __alloc_pages_nodemask+0x267/0x320
> > >  pipe_write+0x1ad/0x400
> > >  new_sync_write+0x127/0x1c0
> > >  __kernel_write+0x4f/0xf0
> > >  dump_emit+0x91/0xc0
> > >  writenote+0xa0/0xc0
> > >  elf_core_dump+0x11af/0x1430
> > >  do_coredump+0xc65/0xee0
> > >  ? unix_stream_sendmsg+0x37d/0x3b0
> > >  get_signal+0x132/0x7c0
> > >  do_signal+0x36/0x640
> > >  ? recalc_sigpending+0x17/0x50
> > >  exit_to_usermode_loop+0x61/0xd0
> > >  do_syscall_64+0xd4/0x100
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > 
> > > The problem is caused by an exiting task which is associated with
> > > an offline memcg.
> > 
> > Hmm, how can we have a task in an offline memcg? I thought that any
> > existing task will prevent cgroup removal from proceeding. Is this some
> > sort of race where the task managed to disassociate from the cgroup
> > while there is still a binding to a memcg existing? What am I missing?
> 
> It's an exiting task with the PF_EXITING flag set and it's in their late stages
> of life.

This is a signal delivery path AFAIU (get_signal) and the coredumping
happens before do_exit. My understanding is that that unlinking
happens from cgroup_exit. So either I am misreading the backtrace or
there is some other way to leave cgroups or there is something more
going on.

JFTR I am not really disputing the patch but I simply do not understand
how the problem really happened.

-- 
Michal Hocko
SUSE Labs
