Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66C414AC0D
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 23:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgA0WbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 17:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgA0WbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 17:31:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C58F22527;
        Mon, 27 Jan 2020 22:31:11 +0000 (UTC)
Date:   Mon, 27 Jan 2020 17:31:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tom Zanussi <zanussi@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Fix histogram code when
 expression has same var as" failed to apply to 4.19-stable tree
Message-ID: <20200127173109.71dc6ab7@gandalf.local.home>
In-Reply-To: <20200127143624.78121b64@gandalf.local.home>
References: <15801394743854@kroah.com>
        <1580150181.5072.5.camel@kernel.org>
        <20200127135147.5c1ae6d1@gandalf.local.home>
        <1580152768.2442.2.camel@kernel.org>
        <20200127143624.78121b64@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jan 2020 14:36:24 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 27 Jan 2020 13:19:28 -0600
> Tom Zanussi <zanussi@kernel.org> wrote:
> 
> > It does fix the issue for me and passes the selftests.  Remember that
> > 4.19 doesn't have the .trace() hist action - you need to use the event
> > name e.g. .first()  
> 
> Yeah I did that, but it was still clearing out the start variable when
> I tried. I'll test the full commits next, right after I fix my git repo
> that got corrupted because it had an alternative based on a repo that
> rebased :-(
> 

Finally got my repo fixed. Yes, after applying the two commits, this
failed patch applies fine, and it does fix the issue. The test I did:

 # mount -t tracefs nodev /sys/kernel/tracing
 # cd /sys/kernel/tracing
 # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >> synthetic_events
 # echo 'hist:keys=pid:start=common_timestamp' > events/sched/sched_waking/trigger 
 # echo 'hist:keys=next_pid:delta=common_timestamp-$start,start2=$start:onmatch(sched.sched_waking).first($start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger
 # cat events/sched/sched_switch/hist

And make sure there were events:

 # cat events/sched/sched_switch/hist 
# event histogram
#
# trigger info: hist:keys=next_pid:vals=hitcount:delta=common_timestamp-$start,start2=$start:sort=hitcount:size=2048:clock=global:onmatch(sched.sched_waking).first($start2,common_timestamp,next_pid,$delta) [active]
#

{ next_pid:       1246 } hitcount:          1
{ next_pid:        153 } hitcount:          1
{ next_pid:         21 } hitcount:          1
{ next_pid:         26 } hitcount:          1
{ next_pid:       1245 } hitcount:          1
{ next_pid:       1613 } hitcount:          1
{ next_pid:       1303 } hitcount:          1
{ next_pid:       1375 } hitcount:          1
{ next_pid:         67 } hitcount:          1
{ next_pid:         41 } hitcount:          1
{ next_pid:         12 } hitcount:          1
{ next_pid:         31 } hitcount:          1
{ next_pid:         46 } hitcount:          1
{ next_pid:         36 } hitcount:          1
{ next_pid:         16 } hitcount:          1
{ next_pid:        606 } hitcount:          3
{ next_pid:        102 } hitcount:          3
{ next_pid:        936 } hitcount:          3
{ next_pid:         13 } hitcount:          6
{ next_pid:         10 } hitcount:          7
{ next_pid:       1584 } hitcount:         13
{ next_pid:       1579 } hitcount:         27
{ next_pid:        145 } hitcount:         30
{ next_pid:       1417 } hitcount:         33

Totals:
    Hits: 140
    Entries: 24
    Dropped: 0

Greg,

This patch is dependent on commits
656fe2ba85e81d00e4447bf77b8da2be3c47acb2 and
de40f033d4e84e843d6a12266e3869015ea9097c

Can you backport them as well to 4.19 and then apply this fix?

Thanks!

-- Steve
