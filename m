Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E0869251D
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 19:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjBJSNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 13:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjBJSNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 13:13:40 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35DD15DC0C;
        Fri, 10 Feb 2023 10:13:34 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F2AE2F4;
        Fri, 10 Feb 2023 10:14:16 -0800 (PST)
Received: from e126311.manchester.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C69D3F71E;
        Fri, 10 Feb 2023 10:13:31 -0800 (PST)
Date:   Fri, 10 Feb 2023 18:12:48 +0000
From:   Kajetan Puchalski <kajetan.puchalski@arm.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format
 file
Message-ID: <Y+aJIGig4r/Dqui5@e126311.manchester.arm.com>
References: <20230210155921.4610-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210155921.4610-1-laoar.shao@gmail.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Yafang,

> After commit 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN"),
> the content of the format file under
> /sys/kernel/debug/tracing/events/task/task_newtask was changed from
>   field:char comm[16];    offset:12;    size:16;    signed:0;
> to
>   field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
> 
> John reported that this change breaks older versions of perfetto.
> Then Mathieu pointed out that this behavioral change was caused by the
> use of __stringify(_len), which happens to work on macros, but not on enum
> labels. And he also gave the suggestion on how to fix it:
>   :One possible solution to make this more robust would be to extend
>   :struct trace_event_fields with one more field that indicates the length
>   :of an array as an actual integer, without storing it in its stringified
>   :form in the type, and do the formatting in f_show where it belongs.
> 
> The result as follows after this change,
> $ cat /sys/kernel/debug/tracing/events/task/task_newtask/format
>         field:char comm[16];    offset:12;      size:16;        signed:0;
> 
> Fixes: 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN")
> Reported-by: John Stultz <jstultz@google.com>
> Debugged-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: stable@vger.kernel.org # v5.17+

From my testing this works the same with older Perfetto as the previous
diff you sent in the older thread, ie this type of errors:

Name	Value	Type
mismatched_sched_switch_tids	2439	error (analysis)
systrace_parse_failure	3853	error (analysis)

Meaning that applying this patch on top of the old one ends up with
different results than just reverting the old one so not a 100% fix
but as I said before, still an improvement.

Thanks,
Kajetan
