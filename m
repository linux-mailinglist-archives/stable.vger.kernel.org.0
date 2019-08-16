Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1428F9A9
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 06:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfHPERq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 00:17:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32901 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfHPERp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 00:17:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so266578wrr.0;
        Thu, 15 Aug 2019 21:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gEuZ0oQvlc1hh0fzWt3HdqljZG+E0Tl/80jYC8+qyFg=;
        b=L4c36XAEfLn5DR9m82nrwS0IJpMOF7dsO5gY6LEoNm98X6lDb1sUutgfBkfYcbtdOo
         IPlNuny3JhRetWi0bC9mwRWnE+ZbGF0TKm2WV2a819FDD5tMFoyRL79HF8Sik9llMiwU
         c+z96vRmNLVxOZCFjVcxne+WdfcK9LHtNWyFq/nD+rghtyovDAACBHSo6LY03/dI9ocB
         SNT2S3M4QuEkk6YF8n99+EBBkVbPmRomsGXUEnEMrT/i80bUwG00WZhTI0QFwZ9avEJP
         0x6pJglk8v4qpuUFJ02Z9Aft21XtrVYjRQK3Nr+dwLS5kf+HJmr9FnOfIwaRJpwS10Up
         rDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gEuZ0oQvlc1hh0fzWt3HdqljZG+E0Tl/80jYC8+qyFg=;
        b=Lr4oZnH5ptHXQQ1nD8J+M2tgiSHQfJqTfEO/HV0wqJH2CEakVnpnP8/mrhnmpZf1ds
         xSPVzOH40A/6gZ1kke8XDpUGl41LTRSQaa76VJribv+6OaD6UexHARkNu5hSpGNrh0eH
         Hw6oVZL1OfoJjil7YT2qCqnHEE8XJDv8x2Ipg7bAxKKcvRXB82lSqjVyFqLM3ry9PAja
         MM4fIAsWqytOfsGYyz7fthTiiLopo0IFGb7pGMmHzwYmMQTVT9xWLhR2soRV+j49PiP0
         r76I+ZpkvF92+R/9ayFp6JwW/daF6IEWpz6qR9rP6Fd+hNNdcufVxv8LilC7URZqZ6Wo
         4f4A==
X-Gm-Message-State: APjAAAWCgm0RYhYFh2jcKTplYKpsoD8kaIU5CwbBwIKf79RvzY51j+Lb
        tWZYPeNgKri4/FqxA5yP4NIvWvRJHCuJw610WXw=
X-Google-Smtp-Source: APXvYqw3G/gjqF/Ef0gievuOoaEo2CmKMPOffL1prKRF+hPNNtI7ZzB8+W0WfRHdA0FbeHoo958/7AkNMylQYtN2New=
X-Received: by 2002:adf:e4c6:: with SMTP id v6mr7628091wrm.315.1565929063662;
 Thu, 15 Aug 2019 21:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190816025417.28964-1-ming.lei@redhat.com> <effdfa46-880f-2d05-19be-8af4f451b8f4@acm.org>
In-Reply-To: <effdfa46-880f-2d05-19be-8af4f451b8f4@acm.org>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Fri, 16 Aug 2019 12:17:31 +0800
Message-ID: <CACVXFVNZJswn_zu_K+N2ooLbq1qqrkbknW0Km6R-mHm_nzc=xA@mail.gmail.com>
Subject: Re: [PATCH V2] blk-mq: avoid sysfs buffer overflow by too many CPU cores
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mark Ray <mark.ray@hpe.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 11:42 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 8/15/19 7:54 PM, Ming Lei wrote:
> > It is reported that sysfs buffer overflow can be triggered in case
> > of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> > blk_mq_hw_sysfs_cpus_show().
> >
> > So use cpumap_print_to_pagebuf() to print the info and fix the potential
> > buffer overflow issue.
> >
> > Cc: stable@vger.kernel.org
> > Cc: Mark Ray <mark.ray@hpe.com>
> > Cc: Greg KH <gregkh@linuxfoundation.org>
> > Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   block/blk-mq-sysfs.c | 15 +--------------
> >   1 file changed, 1 insertion(+), 14 deletions(-)
> >
> > diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> > index d6e1a9bd7131..4d0d32377ba3 100644
> > --- a/block/blk-mq-sysfs.c
> > +++ b/block/blk-mq-sysfs.c
> > @@ -166,20 +166,7 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
> >
> >   static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
> >   {
> > -     unsigned int i, first = 1;
> > -     ssize_t ret = 0;
> > -
> > -     for_each_cpu(i, hctx->cpumask) {
> > -             if (first)
> > -                     ret += sprintf(ret + page, "%u", i);
> > -             else
> > -                     ret += sprintf(ret + page, ", %u", i);
> > -
> > -             first = 0;
> > -     }
> > -
> > -     ret += sprintf(ret + page, "\n");
> > -     return ret;
> > +     return cpumap_print_to_pagebuf(true, page, hctx->cpumask);
> >   }
> >
> >   static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_nr_tags = {
>
> Although this patch looks fine to me, shouldn't this attribute be
> documented under Documentation/ABI/?

That is another problem, not closely related with this buffer-overflow issue.

I suggest to fix the buffer overflow first, which is triggered from userspace.


Thanks,
Ming Lei
