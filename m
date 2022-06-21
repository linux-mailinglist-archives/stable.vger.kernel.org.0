Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41BB5536A2
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbiFUPve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiFUPve (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 11:51:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17F22BB18;
        Tue, 21 Jun 2022 08:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E93260DF0;
        Tue, 21 Jun 2022 15:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C18C3411C;
        Tue, 21 Jun 2022 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655826691;
        bh=zmoo2ZRmvvNCyIQcE+Da2ZI2pDL/yDnS2nVNJbeGP6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tP57ZQnJDy1t8hDt8nEzibw06dOdkIoIJcBAqfAZ/pZzgwDJksQ0hfGV9RLnDaSSq
         7EYMzUqGrsFbEg9mnJlM//+At6FAlrJ+vI0n/CmBH02Rg3yo3WMvdX5GO2qNFdSOyP
         r29zKSmWlcSn+dqMuqjEW+IMczEA5sqIwwER70h+MWeKRCp5BLsA8fXg5CmEQTjiL0
         1Wr3vMk7/ArqiUTSrI/c8f074q0rdeVcqxFkXX8jgiDrcNeYnHu+tR+j7o2PBmFvRl
         wmHnliM0FVXu4UNBNFKNIqpv3nm31sa6gRATqhMpeV70YWhFGT+DCQjTZEsbj7qYWM
         iarsmtGq78xJg==
Date:   Wed, 22 Jun 2022 00:51:24 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Chuang W <nashuiliang@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kprobes: Rollback the aggrprobe post_handler on
 failed arm_kprobe()
Message-Id: <20220622005124.4704eafa0e89c3fe31eef1f5@kernel.org>
In-Reply-To: <20220619045028.50619-1-nashuiliang@gmail.com>
References: <20220619045028.50619-1-nashuiliang@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 19 Jun 2022 12:50:27 +0800
Chuang W <nashuiliang@gmail.com> wrote:

> In a scenario where livepatch and aggrprobe coexist on the same function
> entry, and if this aggrprobe has a post_handler, arm_kprobe() always
> fails as both livepatch and aggrprobe with post_handler will use
> FTRACE_OPS_FL_IPMODIFY.
> Since register_aggr_kprobe() doesn't roll back the post_handler on
> failed arm_kprobe(), this aggrprobe will no longer be available even if
> all kprobes on this aggrprobe don't have the post_handler.
> 
> Fix to roll back the aggrprobe post_handler for this case.
> With this patch, if a kprobe that has the post_handler is removed from
> this aggrprobe (since arm_kprobe() failed), it will be available again.
> 

This looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thank you!

> Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
> Signed-off-by: Chuang W <nashuiliang@gmail.com>
> Cc: <stable@vger.kernel.org>
> ---
> v1 -> v2:
> - Add commit details
> 
>  kernel/kprobes.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index f214f8c088ed..0610b02a3a05 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1300,6 +1300,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
>  {
>  	int ret = 0;
>  	struct kprobe *ap = orig_p;
> +	kprobe_post_handler_t old_post_handler = NULL;
>  
>  	cpus_read_lock();
>  
> @@ -1351,6 +1352,9 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
>  
>  	/* Copy the insn slot of 'p' to 'ap'. */
>  	copy_kprobe(ap, p);
> +
> +	/* save the old post_handler */
> +	old_post_handler = ap->post_handler;
>  	ret = add_new_kprobe(ap, p);
>  
>  out:
> @@ -1365,6 +1369,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
>  			ret = arm_kprobe(ap);
>  			if (ret) {
>  				ap->flags |= KPROBE_FLAG_DISABLED;
> +				ap->post_handler = old_post_handler;
>  				list_del_rcu(&p->list);
>  				synchronize_rcu();
>  			}
> -- 
> 2.34.1
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
