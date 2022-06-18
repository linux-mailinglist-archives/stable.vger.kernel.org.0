Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A5A5505FE
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiFRQEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 12:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRQEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 12:04:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EB713D69;
        Sat, 18 Jun 2022 09:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 509BFB801B9;
        Sat, 18 Jun 2022 16:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C323CC3411A;
        Sat, 18 Jun 2022 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655568284;
        bh=193OIz2GmZWacmY9R/GZImowBfEqpE8RpzGJ1S9iFxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YkF8GlT/H8y8gscuCVG/0uII3JqbVk9zi1oBgvq9n2b0Ub9JRjNANmrIZINsto6l0
         SSSyidgS3FEGpAHu4mMahwWQf/Vjj5OVqz+D4JwxjGQQ6Kcee2vUseVopjWmjhJtYb
         2m5jbrzBuwem5wIJm0FdjhU4MphCRZUtkjo8yJYKPKddW/n8oxBznem58uShp4wYZD
         hwSIagGjDfsJbSP27KTJ76VG2uE88UyLct4XP3hMvutUS3tPclEc4IrIYkGUM3Xy1E
         YcX8MUTz0uXW18HGbsGqxtcSGGzmx4l+0OoPYFktr84RR11yP8dSWAHsSlSv9q0MJV
         Mdf2t6FfqdWVQ==
Date:   Sun, 19 Jun 2022 01:04:40 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     chuang <nashuiliang@gmail.com>
Cc:     stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: Rollback post_handler on failed arm_kprobe()
Message-Id: <20220619010440.57fe2f296b555df666108559@kernel.org>
In-Reply-To: <CACueBy7Q6TenVFGau7Y+8nuo9ZLqruC1Pijw1YuMgyOUhjULMA@mail.gmail.com>
References: <20220614090633.43832-1-nashuiliang@gmail.com>
        <20220615093424.961cfa58eae0a8ce601e7af6@kernel.org>
        <CACueBy7Q6TenVFGau7Y+8nuo9ZLqruC1Pijw1YuMgyOUhjULMA@mail.gmail.com>
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

On Wed, 15 Jun 2022 11:09:16 +0800
chuang <nashuiliang@gmail.com> wrote:

> On Wed, Jun 15, 2022 at 8:34 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > Hi Chuang,
> >
> > On Tue, 14 Jun 2022 17:06:33 +0800
> > Chuang W <nashuiliang@gmail.com> wrote:
> >
> > > In a scenario where livepatch and aggrprobe coexist, if arm_kprobe()
> > > returns an error, ap.post_handler, while has been modified to
> > > p.post_handler, is not rolled back.
> >
> > Would you mean 'coexist' on the same function?
> 
> Yes, It's the same function.
> 
> >
> > >
> > > When ap.post_handler is not NULL (not rolled back), the caller (e.g.
> > > register_kprobe/enable_kprobe) of arm_kprobe_ftrace() will always fail.
> >
> > It seems this explanation and the actual code does not
> > match. Can you tell me what actually you observed?
> >
> > Thank you,
> >
> 
> I briefly describe the steps involved, a patch (kprobes: Rollback
> kprobe flags on failed arm_kprobe,
> https://lore.kernel.org/all/20220612213156.1323776351ee1be3cabc7fcc@kernel.org/T/)
> must be added, otherwise it will panic:
> 
> 1) add a livepatch
> 
> $ insmod livepatch-XXX.ko
> 
> 2) add a kprobe using tracefs API
> 
> $ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events
> 
> At this time, XXX is a simple kprobe, kprobe->post_handler = NULL.
> 
> 3) add a second kprobe using raw kprobe API (i.e. register_kprobe),
> the new kprobe->post_handler != NULL
> 
> $ insmod kprobe_XXX.ko
> $ insmod: ERROR: could not insert module kprobe_XXX.ko: Device or resource busy

Ah, OK. In this case, "p->post_handler != NULL" indicates this
kprobe will modify regs->ip. Thus the ftrace will conflict
with livepatch. In this case, if ap->post_handler is not
rolled back, the ap will never be enabled.

Can you update the patch description something like below?

-----
In a scenario where livepatch and a aggrprobe coexist on the same
function entry, and if the aggrprobe has a post_handler, the
arm_kprobe() always fail because both of livepatch and the aggrprobe
with post_handler will use FTRACE_OPS_FL_IPMODIFY. This flag is not
allowed to be used by the different ftrace user on the same function
entry.
Since the register_aggr_kprobe() doesn't roll back the post_handler
when the arm_kprobe() is failed, this aggrprobe will not be available
from now on even if all kprobes on the aggrprobe don't have the
post_handler.

Fix to roll back the post_handler of the aggrprobe for this case.
With this fix, if the kprobe which has the post_handler is removed
from the aggrprobe (since arm_kprobe() failed), it will be available
again. 
-----

This will explains the technical background, what will happen
with current code, how it is fixed and what is the corrected
behavior.

Thank you,

> 
> This will fail (as expected). However, XXX is modified to an
> aggrprobe. agKprobe->post_handler = aggr_post_handler, it's not rolled
> back on failed arm_kprobe().
> 
> 4) add a third kprobe using bpftrace/bcc tool
> 
> $ bpftrace -e 'kprobe:XXX {printf("%s", kstack());}'
> Attaching 1 probe...
> perf_event_open(/sys/kernel/debug/tracing/events/kprobes/p_XXX_0_1_bcc_440/id):
> Device or resource busy
> Error attaching probe: 'kprobe:blkcg_destroy_blkgs'
> $ bpftrace -e 'kprobe:XXX {printf("%s", kstack());}'
> Attaching 1 probe...
> perf_event_open(/sys/kernel/debug/tracing/events/kprobes/p_XXX_0_1_bcc_440/id):
> Device or resource busy
> Error attaching probe: 'kprobe:blkcg_destroy_blkgs'
> 
> This will always fail (not as expected).
> 
> > >
> > > Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
> > > Signed-off-by: Chuang W <nashuiliang@gmail.com>
> > > Cc: <stable@vger.kernel.org>
> > > ---
> > >  kernel/kprobes.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > > index f214f8c088ed..0610b02a3a05 100644
> > > --- a/kernel/kprobes.c
> > > +++ b/kernel/kprobes.c
> > > @@ -1300,6 +1300,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
> > >  {
> > >       int ret = 0;
> > >       struct kprobe *ap = orig_p;
> > > +     kprobe_post_handler_t old_post_handler = NULL;
> > >
> > >       cpus_read_lock();
> > >
> > > @@ -1351,6 +1352,9 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
> > >
> > >       /* Copy the insn slot of 'p' to 'ap'. */
> > >       copy_kprobe(ap, p);
> > > +
> > > +     /* save the old post_handler */
> > > +     old_post_handler = ap->post_handler;
> > >       ret = add_new_kprobe(ap, p);
> > >
> > >  out:
> > > @@ -1365,6 +1369,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
> > >                       ret = arm_kprobe(ap);
> > >                       if (ret) {
> > >                               ap->flags |= KPROBE_FLAG_DISABLED;
> > > +                             ap->post_handler = old_post_handler;
> > >                               list_del_rcu(&p->list);
> > >                               synchronize_rcu();
> > >                       }
> > > --
> > > 2.34.1
> > >
> >
> >
> > --
> > Masami Hiramatsu (Google) <mhiramat@kernel.org>


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
