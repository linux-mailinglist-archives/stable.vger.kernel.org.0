Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD49354BEC2
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 02:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiFOAed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 20:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiFOAed (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 20:34:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0889435DDF;
        Tue, 14 Jun 2022 17:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 615C461939;
        Wed, 15 Jun 2022 00:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB1AC3411B;
        Wed, 15 Jun 2022 00:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655253269;
        bh=Yz13IgKOC0iptK56o8LR0wiHGkxHflnnEptjcBA8JLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tmV7wIidivjbcMYZ1hU1aTj9NB/A1MRCBVya/3tpreqni8hYFTx913TzD1NS8JXzo
         7yfglVwuTvYpw2EBONC4IqG7Qtnl28CanSp6+3xRhBnJG6By8uYCcvThL1H0kyaOIb
         Y1TG1oVICzZ69U54EejXLTINvPLTLZ0MhanhQosB3nppl1C96/A2bGlpoySXWo61s+
         tdzeedOKE9kJl8OO1hWVBeLNBSntRl7/wS8d2mNyV2LezzrsgBr75Jd95vG4vKbrM/
         KQ79GkATvcNvu3c3s6SUp9oEnpDqkpo4QUN4W5MVZ5cUtfx4xPmuUS8ERy9NG/KjHg
         Dh2sVTlY4r3Zg==
Date:   Wed, 15 Jun 2022 09:34:24 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Chuang W <nashuiliang@gmail.com>
Cc:     stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: Rollback post_handler on failed arm_kprobe()
Message-Id: <20220615093424.961cfa58eae0a8ce601e7af6@kernel.org>
In-Reply-To: <20220614090633.43832-1-nashuiliang@gmail.com>
References: <20220614090633.43832-1-nashuiliang@gmail.com>
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

Hi Chuang,

On Tue, 14 Jun 2022 17:06:33 +0800
Chuang W <nashuiliang@gmail.com> wrote:

> In a scenario where livepatch and aggrprobe coexist, if arm_kprobe()
> returns an error, ap.post_handler, while has been modified to
> p.post_handler, is not rolled back.

Would you mean 'coexist' on the same function?

> 
> When ap.post_handler is not NULL (not rolled back), the caller (e.g.
> register_kprobe/enable_kprobe) of arm_kprobe_ftrace() will always fail.

It seems this explanation and the actual code does not
match. Can you tell me what actually you observed?

Thank you,

> 
> Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
> Signed-off-by: Chuang W <nashuiliang@gmail.com>
> Cc: <stable@vger.kernel.org>
> ---
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
