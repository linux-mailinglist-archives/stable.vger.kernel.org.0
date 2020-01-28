Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F4614B09D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 09:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgA1ICX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 03:02:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgA1ICX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 03:02:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B768E2465B;
        Tue, 28 Jan 2020 08:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580198542;
        bh=/S4qENmmbzGEVLUdojasTXMBmwqL+7PE6GMY5EAzPqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BnY7/ckSV8Vmz/27WmTbjqBtbNZuKqAllNXsJngIwNLte5B7l/xyZHy+nuelbI9iC
         xAZMliBiPVRY/8JkZKYrN+yZzbiUFFlRDVlftATzCztQ2AcbKqs2GprLbfr+Qc5gEC
         Ayssvlp7AQwHKVAu4C6Hdw4Osd7E5ayQUqvgYjjo=
Date:   Tue, 28 Jan 2020 09:02:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Fix histogram code when
 expression has same var as" failed to apply to 4.19-stable tree
Message-ID: <20200128080219.GF2105706@kroah.com>
References: <15801394743854@kroah.com>
 <1580150181.5072.5.camel@kernel.org>
 <20200127135147.5c1ae6d1@gandalf.local.home>
 <1580152768.2442.2.camel@kernel.org>
 <20200127143624.78121b64@gandalf.local.home>
 <20200127173109.71dc6ab7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127173109.71dc6ab7@gandalf.local.home>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 27, 2020 at 05:31:09PM -0500, Steven Rostedt wrote:
> On Mon, 27 Jan 2020 14:36:24 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 27 Jan 2020 13:19:28 -0600
> > Tom Zanussi <zanussi@kernel.org> wrote:
> > 
> > > It does fix the issue for me and passes the selftests.  Remember that
> > > 4.19 doesn't have the .trace() hist action - you need to use the event
> > > name e.g. .first()  
> > 
> > Yeah I did that, but it was still clearing out the start variable when
> > I tried. I'll test the full commits next, right after I fix my git repo
> > that got corrupted because it had an alternative based on a repo that
> > rebased :-(
> > 
> 
> Finally got my repo fixed. Yes, after applying the two commits, this
> failed patch applies fine, and it does fix the issue. The test I did:
> 
>  # mount -t tracefs nodev /sys/kernel/tracing
>  # cd /sys/kernel/tracing
>  # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >> synthetic_events
>  # echo 'hist:keys=pid:start=common_timestamp' > events/sched/sched_waking/trigger 
>  # echo 'hist:keys=next_pid:delta=common_timestamp-$start,start2=$start:onmatch(sched.sched_waking).first($start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger
>  # cat events/sched/sched_switch/hist
> 
> And make sure there were events:
> 
>  # cat events/sched/sched_switch/hist 
> # event histogram
> #
> # trigger info: hist:keys=next_pid:vals=hitcount:delta=common_timestamp-$start,start2=$start:sort=hitcount:size=2048:clock=global:onmatch(sched.sched_waking).first($start2,common_timestamp,next_pid,$delta) [active]
> #
> 
> { next_pid:       1246 } hitcount:          1
> { next_pid:        153 } hitcount:          1
> { next_pid:         21 } hitcount:          1
> { next_pid:         26 } hitcount:          1
> { next_pid:       1245 } hitcount:          1
> { next_pid:       1613 } hitcount:          1
> { next_pid:       1303 } hitcount:          1
> { next_pid:       1375 } hitcount:          1
> { next_pid:         67 } hitcount:          1
> { next_pid:         41 } hitcount:          1
> { next_pid:         12 } hitcount:          1
> { next_pid:         31 } hitcount:          1
> { next_pid:         46 } hitcount:          1
> { next_pid:         36 } hitcount:          1
> { next_pid:         16 } hitcount:          1
> { next_pid:        606 } hitcount:          3
> { next_pid:        102 } hitcount:          3
> { next_pid:        936 } hitcount:          3
> { next_pid:         13 } hitcount:          6
> { next_pid:         10 } hitcount:          7
> { next_pid:       1584 } hitcount:         13
> { next_pid:       1579 } hitcount:         27
> { next_pid:        145 } hitcount:         30
> { next_pid:       1417 } hitcount:         33
> 
> Totals:
>     Hits: 140
>     Entries: 24
>     Dropped: 0
> 
> Greg,
> 
> This patch is dependent on commits
> 656fe2ba85e81d00e4447bf77b8da2be3c47acb2 and
> de40f033d4e84e843d6a12266e3869015ea9097c
> 
> Can you backport them as well to 4.19 and then apply this fix?

Will do, thanks!

greg k-h
