Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100C054C000
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 05:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiFODJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 23:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiFODJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 23:09:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6AF4C413;
        Tue, 14 Jun 2022 20:09:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id m20so20568619ejj.10;
        Tue, 14 Jun 2022 20:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PZdjTiMB2cT7RGXSEMxyEsUGs5PUBdVqhv7g3Zq8KIQ=;
        b=ODtrmNvbPKBXS+8TmcmX9gSI0b/1rw5ShjzVEGHpDFOfb5gzZc8QDbKvBKq69s4gMk
         Dk/VIY3wPaTpiBO2wcoF+vf5sNBmbiE1ehJ7Z9/uXAFfzQl/zm5Fl+vTiBb+6t/BBdph
         OfCkaFmQ8HPlBYvS6XxYdOh5vIHFY6LuzjIHvMskTGtUWFzZRqC3JbJ3iGNlq/sri341
         H9idDSn0UYljrmS5W/FZo+R+U8eIpjy2xau2GBe6rCXicmufxMk9XsWTDB52eQeW9cZz
         A1NUhi6EOKFk8xF2ESSbDDNruSaCsZtv4LpM6eqRQSEpIeLVrcpugg80kvctQXF7tM6h
         AcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PZdjTiMB2cT7RGXSEMxyEsUGs5PUBdVqhv7g3Zq8KIQ=;
        b=FRww7QBc1WutBsmHJfAX/QeqTNoPwS/S6zxdhj16kUjN6qp1g2k73/uWXEzW6NeFqN
         xCqFQ8SoIYpM0FvVEN7eN+4gEBl1B2jZvfh/GrLcEiJcRq4gtnypQzqU9vKa2ejDIoXt
         ofkOKLBeTh3iCdI0eteZukl8Pb52GsF0NfhzeCqQJJAMF/OTmHSmncnjU5qHOZNxkKRh
         RIzQU0B+kjsubpr246Xc8GXEG4lmnMYRMwkQ1nkcfJbatox9WIkVsrI0EpEp+mceJrIC
         EkA42hNxka/dVLLGtXoFW6//hT5xctPW4OXkz3lxXOv45eTN9NoH3G8w3BJi+83aaKnX
         r0Mg==
X-Gm-Message-State: AOAM530fadI3QeOVZgW7N84Bwxi+Ab0RyAJJAuKhQ+eh9Mg5xyvYedWX
        gxb9dg2L6I64G4kza0zZkaFDhABlvTWMTThnwW0=
X-Google-Smtp-Source: ABdhPJxt9GVPA9DjVN9pjyBVoaZOf5BMUo0nAuBMyDRzbdXHIL3molT65W9iQPzeBKVpMYv9c28iqyLgPEvmJ4M12Ck=
X-Received: by 2002:a17:906:649b:b0:711:fde7:be43 with SMTP id
 e27-20020a170906649b00b00711fde7be43mr7174456ejm.294.1655262567782; Tue, 14
 Jun 2022 20:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220614090633.43832-1-nashuiliang@gmail.com> <20220615093424.961cfa58eae0a8ce601e7af6@kernel.org>
In-Reply-To: <20220615093424.961cfa58eae0a8ce601e7af6@kernel.org>
From:   chuang <nashuiliang@gmail.com>
Date:   Wed, 15 Jun 2022 11:09:16 +0800
Message-ID: <CACueBy7Q6TenVFGau7Y+8nuo9ZLqruC1Pijw1YuMgyOUhjULMA@mail.gmail.com>
Subject: Re: [PATCH] kprobes: Rollback post_handler on failed arm_kprobe()
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 8:34 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> Hi Chuang,
>
> On Tue, 14 Jun 2022 17:06:33 +0800
> Chuang W <nashuiliang@gmail.com> wrote:
>
> > In a scenario where livepatch and aggrprobe coexist, if arm_kprobe()
> > returns an error, ap.post_handler, while has been modified to
> > p.post_handler, is not rolled back.
>
> Would you mean 'coexist' on the same function?

Yes, It's the same function.

>
> >
> > When ap.post_handler is not NULL (not rolled back), the caller (e.g.
> > register_kprobe/enable_kprobe) of arm_kprobe_ftrace() will always fail.
>
> It seems this explanation and the actual code does not
> match. Can you tell me what actually you observed?
>
> Thank you,
>

I briefly describe the steps involved, a patch (kprobes: Rollback
kprobe flags on failed arm_kprobe,
https://lore.kernel.org/all/20220612213156.1323776351ee1be3cabc7fcc@kernel.org/T/)
must be added, otherwise it will panic:

1) add a livepatch

$ insmod livepatch-XXX.ko

2) add a kprobe using tracefs API

$ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events

At this time, XXX is a simple kprobe, kprobe->post_handler = NULL.

3) add a second kprobe using raw kprobe API (i.e. register_kprobe),
the new kprobe->post_handler != NULL

$ insmod kprobe_XXX.ko
$ insmod: ERROR: could not insert module kprobe_XXX.ko: Device or resource busy

This will fail (as expected). However, XXX is modified to an
aggrprobe. agKprobe->post_handler = aggr_post_handler, it's not rolled
back on failed arm_kprobe().

4) add a third kprobe using bpftrace/bcc tool

$ bpftrace -e 'kprobe:XXX {printf("%s", kstack());}'
Attaching 1 probe...
perf_event_open(/sys/kernel/debug/tracing/events/kprobes/p_XXX_0_1_bcc_440/id):
Device or resource busy
Error attaching probe: 'kprobe:blkcg_destroy_blkgs'
$ bpftrace -e 'kprobe:XXX {printf("%s", kstack());}'
Attaching 1 probe...
perf_event_open(/sys/kernel/debug/tracing/events/kprobes/p_XXX_0_1_bcc_440/id):
Device or resource busy
Error attaching probe: 'kprobe:blkcg_destroy_blkgs'

This will always fail (not as expected).

> >
> > Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
> > Signed-off-by: Chuang W <nashuiliang@gmail.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  kernel/kprobes.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index f214f8c088ed..0610b02a3a05 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -1300,6 +1300,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
> >  {
> >       int ret = 0;
> >       struct kprobe *ap = orig_p;
> > +     kprobe_post_handler_t old_post_handler = NULL;
> >
> >       cpus_read_lock();
> >
> > @@ -1351,6 +1352,9 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
> >
> >       /* Copy the insn slot of 'p' to 'ap'. */
> >       copy_kprobe(ap, p);
> > +
> > +     /* save the old post_handler */
> > +     old_post_handler = ap->post_handler;
> >       ret = add_new_kprobe(ap, p);
> >
> >  out:
> > @@ -1365,6 +1369,7 @@ static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
> >                       ret = arm_kprobe(ap);
> >                       if (ret) {
> >                               ap->flags |= KPROBE_FLAG_DISABLED;
> > +                             ap->post_handler = old_post_handler;
> >                               list_del_rcu(&p->list);
> >                               synchronize_rcu();
> >                       }
> > --
> > 2.34.1
> >
>
>
> --
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
