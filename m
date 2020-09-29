Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA4827BD62
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 08:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgI2Gwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 02:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI2Gwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 02:52:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72184206B7;
        Tue, 29 Sep 2020 06:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601362361;
        bh=6KqVFDoYR/Ej4IVjg3AKvUD6uYoOzhctINwi+ieMatQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yhT7FELKUxc9KgxZ0qhglyD6nQB2+kKuq+NjurV4NqUrwHMpecx+oCwslztPLEM5Z
         kj3sSG7tYf7NPd4QbX/EEj8/lt4FpmJzWOfxlDmkE6S8WMO5duTvFb7VXOlqR9e2ls
         ZvX5SVevYQ7DLpDKkevFqpCfu/8lesk5ZL3jUYKk=
Date:   Tue, 29 Sep 2020 08:52:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH 4.19 38/92] kprobes: Fix NULL pointer dereference at
 kprobe_ftrace_handler
Message-ID: <20200929065247.GB2439787@kroah.com>
References: <20200820091537.490965042@linuxfoundation.org>
 <20200820091539.592290034@linuxfoundation.org>
 <CA+G9fYvdQv2Ukvs-UKiEgYaDdBthsWsY=35cQ4YpvMhA0hU5Gg@mail.gmail.com>
 <20200928180942.100aa6c8@oasis.local.home>
 <20200928181535.56d7b2cb@oasis.local.home>
 <20200929144954.56090c5eeb5a36e1f552b315@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200929144954.56090c5eeb5a36e1f552b315@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 02:49:54PM +0900, Masami Hiramatsu wrote:
> Hi,
> 
> On Mon, 28 Sep 2020 18:15:35 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 28 Sep 2020 18:09:42 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Tue, 29 Sep 2020 01:32:59 +0530
> > > Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > 
> > > > stable rc branch 4.19 build warning on arm64.
> > > > 
> > > > ../kernel/kprobes.c: In function ‘kill_kprobe’:
> > > > ../kernel/kprobes.c:1070:33: warning: statement with no effect [-Wunused-value]
> > > >  1070 | #define disarm_kprobe_ftrace(p) (-ENODEV)
> > > >       |                                 ^
> > > > ../kernel/kprobes.c:2090:3: note: in expansion of macro ‘disarm_kprobe_ftrace’
> > > >  2090 |   disarm_kprobe_ftrace(p);
> > > >       |   ^~~~~~~~~~~~~~~~~~~~  
> > > 
> > > Seems to affect upstream as well.
> > > 
> > 
> > Bah, no (tested the wrong kernel).
> > 
> > You want this commit too:
> > 
> > 10de795a5addd ("kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE")
> 
> It seems that this commit's Fixes tag is wrong.
> 
> ae6aa16fdc163 (Masami Hiramatsu           2012-06-05 19:28:32 +0900 1079) #define prepare_kprobe(p)     arch_prepare_kprobe(p)
> 12310e3437554 (Jessica Yu                 2018-01-10 00:51:23 +0100 1080) #define arm_kprobe_ftrace(p)  (-ENODEV)
> 297f9233b53a0 (Jessica Yu                 2018-01-10 00:51:24 +0100 1081) #define disarm_kprobe_ftrace(p)       (-ENODEV)
> 
> Thus, it should have "Fixes: 297f9233b53a ("kprobes: Propagate error from disarm_kprobe_ftrace()")"
> 
> $ git tag -l --contains 297f9233b53a | grep "^v[[:digit:].]*$" | cut -f1-2 -d. | uniq
> v4.16
> v4.17
> v4.18
> v4.19
> v4.20
> v5.0
> v5.1
> v5.2
> v5.3
> v5.4
> v5.5
> v5.6
> v5.7
> v5.8
> 
> So the commit 10de795a5addd must be backported to 4.19.y and 5.4.y.

Now queued up, thanks.

greg k-h
