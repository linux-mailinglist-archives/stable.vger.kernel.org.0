Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7337E69334F
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 20:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBKT2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 14:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBKT2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 14:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8C915C8A;
        Sat, 11 Feb 2023 11:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CF21B80AB1;
        Sat, 11 Feb 2023 19:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F85C433D2;
        Sat, 11 Feb 2023 19:28:16 +0000 (UTC)
Date:   Sat, 11 Feb 2023 14:28:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format
 file
Message-ID: <20230211142813.103b1643@gandalf.local.home>
In-Reply-To: <CAADnVQ+iAx8OL_KP3Ae2GhDGrhdQ1wujG-B0=5ZpfQJuEnRQTg@mail.gmail.com>
References: <20230210155921.4610-1-laoar.shao@gmail.com>
        <Y+aJIGig4r/Dqui5@e126311.manchester.arm.com>
        <CAADnVQ+iAx8OL_KP3Ae2GhDGrhdQ1wujG-B0=5ZpfQJuEnRQTg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Feb 2023 14:32:13 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> fwiw I don't mind reverting commit 3087c61ed2c4.
> For the record it didn't go through the bpf tree.
> It went through mm.

I think the solution being presented can work, but still needs some work.

> 
> But first we need to define which part of ftrace format is an abi.
> I think it's a format of tracing/event/foo/format file
> and not the contents of it.
> The tracepoints come and go. Their arguments get changed too.
> So the contents of ftrace format files change.

As Linus always says. The abi is what user space uses. ;-)

> 
> In this case Perfetto stumbled on parsing
> field:char comm[TASK_COMM_LEN];    offset:8;

Perfetto always expected that to be a number, so it must remain one.

> 
> We probably should define that 'field: value  offset: value'
> is an abi, but value-s can change.
> Say offset:8 becomes offset:+8, for whatever reason.
> If Perfetto fails to parse it, it's a Perfetto bug.
> 
> In this case it failed to parse char comm[TASK_COMM_LEN];
> But that's not the only such "field:".
> These three were there for a long time.
>     field:u32 rates[NUM_NL80211_BANDS];    offset:16;    size:24;
>     field:int mcast_rate[NUM_NL80211_BANDS];    offset:60;    size:24;
>     field:int mcast_rate[NUM_NL80211_BANDS];    offset:108;    size:24;
> 
> I suspect Perfetto didn't have a use case to parse them,
> so the bug stayed dormant and a change in TASK_COMM_LEN triggered it.

Correct. Perfetto picks and chooses what events it needs. It does not parse
all events. So it wouldn't notice these. In fact, some tools require these
fields to be numbers and have used the TRACE_EVENT_ENUM() to convert them.

But with this change, we can likely also remove the parsing of the fields
on boot up. Which is a good thing.


> 
> We can use Yafang's patch to do:
> -field:%.*s %s%s;
> +field:%.*s %s[%d];
> but it will affect both TASK_COMM_LEN and NUM_NL80211_BANDS.

Nothing appears to care about the NUM_NL80211_BANDS being there. It's
basically useless information. If nothing complains about it changing, then
it isn't a breakage of user space.

Remember, Linus's rule is not "do not modify user space interfaces", it is
"don't break user space". If a user space interface changes and no user
space tool notices, did it really break? The tree in a forest analogy.

> 
> In summary the TASK_COMM_LEN change from #define to enum didn't
> introduce anything new in the kind of "value"s being printed
> in ftrace files. Hence I'm arguing there is no abi breakage.
> 
> There was a question why change from #define to enum is useful
> to bpf. The reason is that #define-s are not seen in dwarf
> whereas enums and their values are. bpf tooling has ways to extract
> that data and auto-adjust bpf programs when enum-s disappear
> or their values change.

In most cases, having all the [xxx] turn into useful numbers is what we
want. There's a few things broken with the current patch, but I can help
fix those.

-- Steve
