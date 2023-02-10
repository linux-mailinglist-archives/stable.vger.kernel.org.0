Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D60692A2F
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 23:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjBJWcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 17:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbjBJWcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 17:32:31 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B065B44C;
        Fri, 10 Feb 2023 14:32:26 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id u21so6142251edv.3;
        Fri, 10 Feb 2023 14:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X1Mf3JT84ZyjaCJEAnP6U0ZNbdFF/MUVgj90NFhtCpE=;
        b=GARmL287wB21HymhXNmSAogN1NM6tFwhwk5qvAPU1eWS/q8fMpv5RlhGVt7LCDkokn
         eIzaXF8IKLKjF2gtgzzrxVHsRWzF1WjfxonkLZVn1nMOMAmGSGuiDyaUYvcmB0zWobeN
         RORy6B/M732IsVb4/JuOG38Gd7mDTUjkDUXC5P0No+fgYVuZUL2tN7d40+ikvc1DsiZa
         ii4LELxlHqQCCAoch4d9ndVZdR8IQW3g0EFH8qqq7Ym3x5EV48aWsMZRLL+25np/s4jy
         24HvZ6acsYgGwKyCQV3iIJikY2dw+iTYYKNolqmEQGhy+82ebk6zBlN4hxKAxD94f3wb
         aJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X1Mf3JT84ZyjaCJEAnP6U0ZNbdFF/MUVgj90NFhtCpE=;
        b=7EroUWseYoKBzpnncTp9bQBF+bUsG2NH5eSp7dQ1MMfokO3XwnA/Byk1XU+lDhNhRG
         YzGof495mBuzpXOjZM65kB0iIgqdQd4N7TwaXJJ9OiDp49ptgyT3NuRL2noKN9dZBpDM
         Kzna/WgVKCN/7CVO5UT9KTFjW9wulpwGT6m1y8Wg5AI8Lt4mjDhbcwydKtAJhb7E+JAe
         DykM1omXSkZqR9ECkSX3I66m/kIEADxGzfCwV8rFaFRJCIozU2IVL06/ZzqSnFwPyhVS
         fhqn5lLTfNhw4DBaQGOPMNRh+Ynzlda23IkgiJL2ulTiUau/Knz89pYSJpZGfIKn0q0m
         o8pg==
X-Gm-Message-State: AO0yUKWxBK0VlOcNHwq/fx+ipThp8fg9smcZf9q48KdYRY9kRL7IZqLP
        LMDII2dAHFMG5A/Egbg3kN0J9K+0Kj8vvOG9gkE=
X-Google-Smtp-Source: AK7set8gY66CYgbjXRLbT2FIX4bPzw00Suzb0P1n1e56X6gahfsu1X/FbMShuniKIwu+vD0VBlQOCVr76jLwDtcD7cg=
X-Received: by 2002:a50:8ade:0:b0:4ab:4933:225b with SMTP id
 k30-20020a508ade000000b004ab4933225bmr927504edk.6.1676068345160; Fri, 10 Feb
 2023 14:32:25 -0800 (PST)
MIME-Version: 1.0
References: <20230210155921.4610-1-laoar.shao@gmail.com> <Y+aJIGig4r/Dqui5@e126311.manchester.arm.com>
In-Reply-To: <Y+aJIGig4r/Dqui5@e126311.manchester.arm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Feb 2023 14:32:13 -0800
Message-ID: <CAADnVQ+iAx8OL_KP3Ae2GhDGrhdQ1wujG-B0=5ZpfQJuEnRQTg@mail.gmail.com>
Subject: Re: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format file
To:     Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 10:13 AM Kajetan Puchalski
<kajetan.puchalski@arm.com> wrote:
>
> Hi Yafang,
>
> > After commit 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN"),
> > the content of the format file under
> > /sys/kernel/debug/tracing/events/task/task_newtask was changed from
> >   field:char comm[16];    offset:12;    size:16;    signed:0;
> > to
> >   field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
> >
> > John reported that this change breaks older versions of perfetto.
> > Then Mathieu pointed out that this behavioral change was caused by the
> > use of __stringify(_len), which happens to work on macros, but not on enum
> > labels. And he also gave the suggestion on how to fix it:
> >   :One possible solution to make this more robust would be to extend
> >   :struct trace_event_fields with one more field that indicates the length
> >   :of an array as an actual integer, without storing it in its stringified
> >   :form in the type, and do the formatting in f_show where it belongs.
> >
> > The result as follows after this change,
> > $ cat /sys/kernel/debug/tracing/events/task/task_newtask/format
> >         field:char comm[16];    offset:12;      size:16;        signed:0;
> >
> > Fixes: 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN")
> > Reported-by: John Stultz <jstultz@google.com>
> > Debugged-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Cc: Kajetan Puchalski <kajetan.puchalski@arm.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: John Stultz <jstultz@google.com>
> > Cc: stable@vger.kernel.org # v5.17+
>
> From my testing this works the same with older Perfetto as the previous
> diff you sent in the older thread, ie this type of errors:
>
> Name    Value   Type
> mismatched_sched_switch_tids    2439    error (analysis)
> systrace_parse_failure  3853    error (analysis)
>
> Meaning that applying this patch on top of the old one ends up with
> different results than just reverting the old one so not a 100% fix
> but as I said before, still an improvement.

fwiw I don't mind reverting commit 3087c61ed2c4.
For the record it didn't go through the bpf tree.
It went through mm.

But first we need to define which part of ftrace format is an abi.
I think it's a format of tracing/event/foo/format file
and not the contents of it.
The tracepoints come and go. Their arguments get changed too.
So the contents of ftrace format files change.

In this case Perfetto stumbled on parsing
field:char comm[TASK_COMM_LEN];    offset:8;

We probably should define that 'field: value  offset: value'
is an abi, but value-s can change.
Say offset:8 becomes offset:+8, for whatever reason.
If Perfetto fails to parse it, it's a Perfetto bug.

In this case it failed to parse char comm[TASK_COMM_LEN];
But that's not the only such "field:".
These three were there for a long time.
    field:u32 rates[NUM_NL80211_BANDS];    offset:16;    size:24;
    field:int mcast_rate[NUM_NL80211_BANDS];    offset:60;    size:24;
    field:int mcast_rate[NUM_NL80211_BANDS];    offset:108;    size:24;

I suspect Perfetto didn't have a use case to parse them,
so the bug stayed dormant and a change in TASK_COMM_LEN triggered it.

We can use Yafang's patch to do:
-field:%.*s %s%s;
+field:%.*s %s[%d];
but it will affect both TASK_COMM_LEN and NUM_NL80211_BANDS.

In summary the TASK_COMM_LEN change from #define to enum didn't
introduce anything new in the kind of "value"s being printed
in ftrace files. Hence I'm arguing there is no abi breakage.

There was a question why change from #define to enum is useful
to bpf. The reason is that #define-s are not seen in dwarf
whereas enums and their values are. bpf tooling has ways to extract
that data and auto-adjust bpf programs when enum-s disappear
or their values change.
