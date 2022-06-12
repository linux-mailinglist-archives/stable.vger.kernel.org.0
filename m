Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60988547A20
	for <lists+stable@lfdr.de>; Sun, 12 Jun 2022 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbiFLMcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jun 2022 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiFLMcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jun 2022 08:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF8E4DF63;
        Sun, 12 Jun 2022 05:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529FE60EC2;
        Sun, 12 Jun 2022 12:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693B0C34115;
        Sun, 12 Jun 2022 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655037121;
        bh=aP26pcA1mk5mwSGyhoQM9oieDYSaSKZnQ+prXLtBouE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ho3p+08oYlHderfmFF4zLpYO+663zIJAyn8s0OjIUlFiwHG7yXzPa2QFJeqlyOrTA
         6d3Yf19/b9CBTbaT9wwVrv4byCrr4Mq55Fx3FXfCSxykchA5V7EDPEUsAv53y9bXNW
         +Ol65S8QD6E8VJG5qh4Yu2K6esINWX/CBLgdt5wzq6W5gF61l1J744e9w9wyMSfPP+
         LQU5mb8Vis4tdb+oUUjV14LupNJnwD0fO5AzIZcognZAADhdHgY7QWRLWh2zjOS/oM
         YfdeTkXET4BZw9HwSi7JjjI28Z9qblB4Gy7u/DB9AvfHDrCJ8wRbk7IsVxIk43XlXk
         o3Bi7Ei+ONZVg==
Date:   Sun, 12 Jun 2022 21:31:56 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Chuang <nashuiliang@gmail.com>
Cc:     stable@vger.kernel.org, Jingren Zhou <zhoujingren@didiglobal.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kprobes: Rollback kprobe flags on failed arm_kprobe
Message-Id: <20220612213156.1323776351ee1be3cabc7fcc@kernel.org>
In-Reply-To: <20220610150933.37770-1-nashuiliang@gmail.com>
References: <20220610150933.37770-1-nashuiliang@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Jun 2022 23:09:33 +0800
Chuang <nashuiliang@gmail.com> wrote:

> From: Chuang Wang <nashuiliang@gmail.com>
> 
> In aggrprobe scenes, if arm_kprobe() returns an error(e.g. livepatch and
> kprobe are using the same function X), kprobe flags, while has been
> modified to ~KPROBE_FLAG_DISABLED, is not rollled back.
> 
> Then, __disable_kprobe() will be failed in __unregister_kprobe_top(),
> the kprobe list will be not removed from aggrprobe, memory leaks or
> illegal pointers will be caused.
> 
> WARN disarm_kprobe:
>  Failed to disarm kprobe-ftrace at 00000000c729fdbc (-2)
>  RIP: 0010:disarm_kprobe+0xcc/0x110
>  Call Trace:
>   __disable_kprobe+0x78/0x90
>   __unregister_kprobe_top+0x13/0x1b0
>   ? _cond_resched+0x15/0x30
>   unregister_kprobes+0x32/0x80
>   unregister_kprobe+0x1a/0x20
> 
> Illegal Pointers:
>  BUG: unable to handle kernel paging request at 0000000000656369
>  RIP: 0010:__get_valid_kprobe+0x69/0x90
>  Call Trace:
>   register_kprobe+0x30/0x60
>   __register_trace_kprobe.part.7+0x8b/0xc0
>   create_local_trace_kprobe+0xd2/0x130
>   perf_kprobe_init+0x83/0xd0
> 

This looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks for update!

> Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
> Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> ---
> v1->v2:
> - Supplement commit information: fixline, Cc stable
> 
>  kernel/kprobes.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index f214f8c088ed..c11c79e05a4c 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2422,8 +2422,11 @@ int enable_kprobe(struct kprobe *kp)
>  	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
>  		p->flags &= ~KPROBE_FLAG_DISABLED;
>  		ret = arm_kprobe(p);
> -		if (ret)
> +		if (ret) {
>  			p->flags |= KPROBE_FLAG_DISABLED;
> +			if (p != kp)
> +				kp->flags |= KPROBE_FLAG_DISABLED;
> +		}
>  	}
>  out:
>  	mutex_unlock(&kprobe_mutex);
> -- 
> 2.34.1
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
