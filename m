Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D2727BC8B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 07:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI2Ft7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 01:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgI2Ft7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 01:49:59 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9955420BED;
        Tue, 29 Sep 2020 05:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601358598;
        bh=LNuCdYX/8j1ql9YsuaAraX7IDziICskf09LYTmVNjm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xk24tV0IpX8v12Lqbl5cwuyW6CBa2/foUA1c2zSMJ4XkbeP/6UdtzdoR6hrEfh5sx
         TSSmzuwvC+LHwR3m7HDMK85VjVLJWjhTg/Rqrh/chE9WKyKT+kPHF9VJxp+yddzzJt
         zLULJZ5jPQ6/8r98hDzOm3OegMOdAFF71oUrLenc=
Date:   Tue, 29 Sep 2020 14:49:54 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH 4.19 38/92] kprobes: Fix NULL pointer dereference at
 kprobe_ftrace_handler
Message-Id: <20200929144954.56090c5eeb5a36e1f552b315@kernel.org>
In-Reply-To: <20200928181535.56d7b2cb@oasis.local.home>
References: <20200820091537.490965042@linuxfoundation.org>
        <20200820091539.592290034@linuxfoundation.org>
        <CA+G9fYvdQv2Ukvs-UKiEgYaDdBthsWsY=35cQ4YpvMhA0hU5Gg@mail.gmail.com>
        <20200928180942.100aa6c8@oasis.local.home>
        <20200928181535.56d7b2cb@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, 28 Sep 2020 18:15:35 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 28 Sep 2020 18:09:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Tue, 29 Sep 2020 01:32:59 +0530
> > Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > 
> > > stable rc branch 4.19 build warning on arm64.
> > > 
> > > ../kernel/kprobes.c: In function ‘kill_kprobe’:
> > > ../kernel/kprobes.c:1070:33: warning: statement with no effect [-Wunused-value]
> > >  1070 | #define disarm_kprobe_ftrace(p) (-ENODEV)
> > >       |                                 ^
> > > ../kernel/kprobes.c:2090:3: note: in expansion of macro ‘disarm_kprobe_ftrace’
> > >  2090 |   disarm_kprobe_ftrace(p);
> > >       |   ^~~~~~~~~~~~~~~~~~~~  
> > 
> > Seems to affect upstream as well.
> > 
> 
> Bah, no (tested the wrong kernel).
> 
> You want this commit too:
> 
> 10de795a5addd ("kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE")

It seems that this commit's Fixes tag is wrong.

ae6aa16fdc163 (Masami Hiramatsu           2012-06-05 19:28:32 +0900 1079) #define prepare_kprobe(p)     arch_prepare_kprobe(p)
12310e3437554 (Jessica Yu                 2018-01-10 00:51:23 +0100 1080) #define arm_kprobe_ftrace(p)  (-ENODEV)
297f9233b53a0 (Jessica Yu                 2018-01-10 00:51:24 +0100 1081) #define disarm_kprobe_ftrace(p)       (-ENODEV)

Thus, it should have "Fixes: 297f9233b53a ("kprobes: Propagate error from disarm_kprobe_ftrace()")"

$ git tag -l --contains 297f9233b53a | grep "^v[[:digit:].]*$" | cut -f1-2 -d. | uniq
v4.16
v4.17
v4.18
v4.19
v4.20
v5.0
v5.1
v5.2
v5.3
v5.4
v5.5
v5.6
v5.7
v5.8

So the commit 10de795a5addd must be backported to 4.19.y and 5.4.y.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
