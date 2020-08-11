Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6662241BB7
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHKNr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 09:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbgHKNrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 09:47:47 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B3462076B;
        Tue, 11 Aug 2020 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597153666;
        bh=5yMEp9SyDxPuo/xXOdliP4xpnslVqaycciG2uRFajHk=;
        h=Date:From:To:Subject:Reply-To:References:In-Reply-To:From;
        b=wtdh1lcpu2MOuXVkpZaTW+KsbfecM8PsgIi8ucIUwmgrSVpyJ0qQ/hHCVK6hApvLK
         ONu2szekPDI4KmUgBtuvKcjhuSfczaU0kttSOsEJlJCmNwRxsB0w3uVCCeFBXw6PMd
         e+d6+mU2CB1qjb0mSvl3OwsEYJ4FUiBqYNm8z+yI=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 26D473522FF7; Tue, 11 Aug 2020 06:47:46 -0700 (PDT)
Date:   Tue, 11 Aug 2020 06:47:46 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 03/16] fs/btrfs: Add cond_resched() for
 try_release_extent_mapping() stalls
Message-ID: <20200811134746.GV4295@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200810191443.3795581-1-sashal@kernel.org>
 <20200810191443.3795581-3-sashal@kernel.org>
 <20200811075720.GL2026@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811075720.GL2026@twin.jikos.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 09:57:20AM +0200, David Sterba wrote:
> On Mon, Aug 10, 2020 at 03:14:30PM -0400, Sasha Levin wrote:
> > From: "Paul E. McKenney" <paulmck@kernel.org>
> > 
> > [ Upstream commit 9f47eb5461aaeb6cb8696f9d11503ae90e4d5cb0 ]
> > 
> > Very large I/Os can cause the following RCU CPU stall warning:
> > 
> > RIP: 0010:rb_prev+0x8/0x50
> > Code: 49 89 c0 49 89 d1 48 89 c2 48 89 f8 e9 e5 fd ff ff 4c 89 48 10 c3 4c =
> > 89 06 c3 4c 89 40 10 c3 0f 1f 00 48 8b 0f 48 39 cf 74 38 <48> 8b 47 10 48 85 c0 74 22 48 8b 50 08 48 85 d2 74 0c 48 89 d0 48
> > RSP: 0018:ffffc9002212bab0 EFLAGS: 00000287 ORIG_RAX: ffffffffffffff13
> > RAX: ffff888821f93630 RBX: ffff888821f93630 RCX: ffff888821f937e0
> > RDX: 0000000000000000 RSI: 0000000000102000 RDI: ffff888821f93630
> > RBP: 0000000000103000 R08: 000000000006c000 R09: 0000000000000238
> > R10: 0000000000102fff R11: ffffc9002212bac8 R12: 0000000000000001
> > R13: ffffffffffffffff R14: 0000000000102000 R15: ffff888821f937e0
> >  __lookup_extent_mapping+0xa0/0x110
> >  try_release_extent_mapping+0xdc/0x220
> >  btrfs_releasepage+0x45/0x70
> >  shrink_page_list+0xa39/0xb30
> >  shrink_inactive_list+0x18f/0x3b0
> >  shrink_lruvec+0x38e/0x6b0
> >  shrink_node+0x14d/0x690
> >  do_try_to_free_pages+0xc6/0x3e0
> >  try_to_free_mem_cgroup_pages+0xe6/0x1e0
> >  reclaim_high.constprop.73+0x87/0xc0
> >  mem_cgroup_handle_over_high+0x66/0x150
> >  exit_to_usermode_loop+0x82/0xd0
> >  do_syscall_64+0xd4/0x100
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > On a PREEMPT=n kernel, the try_release_extent_mapping() function's
> > "while" loop might run for a very long time on a large I/O.  This commit
> > therefore adds a cond_resched() to this loop, providing RCU any needed
> > quiescent states.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> 
> Paul,
> 
> this patch was well hidden in some huge RCU pile
> (https://lore.kernel.org/lkml/20200623002147.25750-11-paulmck@kernel.org/)
> 
> I wonder why you haven't CCed linux-btrfs, I spotted the patch queued
> for stable by incidentally. The timestamp is from June, that's quite
> some time ago. We can deal with one more patch and I tend to reply with
> acks quickly for easy patches like this to not block other peoples work
> but I'm a bit disappointed by sidestepping maintained subsystems. It's
> not just this patch, it happens from time time only to increase the
> disapointement.

My bad, and please accept my apologies.  I clearly left out the
step of adding proper Cc: lines.  :-/

							Thanx, Paul
