Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64AA8FBB4
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 09:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfHPHJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 03:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfHPHJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 03:09:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC1112077C;
        Fri, 16 Aug 2019 07:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565939363;
        bh=OzGNAC+SiFUl2TD75zYIe9tgmn8SEdwIz2GLkMRYOzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZOd9BSQp06wp3FRs1lAR9wdnq1uoIdXIeh8n+VL4/vnYkFyrsGAg0hH/WZcm15sMQ
         giKtkT6zQTIN9wpiydse5T3lcuaKdCSSLgIsBoV9j4tTYmiFV6j+sAJ9JCMZjmjoPL
         Y3BH+pXmawOd/ByyCCt+H22C6F4Iq9VvPkxOLoOs=
Date:   Fri, 16 Aug 2019 09:09:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mark Ray <mark.ray@hpe.com>
Subject: Re: [PATCH V2] blk-mq: avoid sysfs buffer overflow by too many CPU
 cores
Message-ID: <20190816070921.GC1368@kroah.com>
References: <20190816025417.28964-1-ming.lei@redhat.com>
 <effdfa46-880f-2d05-19be-8af4f451b8f4@acm.org>
 <CACVXFVNZJswn_zu_K+N2ooLbq1qqrkbknW0Km6R-mHm_nzc=xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNZJswn_zu_K+N2ooLbq1qqrkbknW0Km6R-mHm_nzc=xA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 12:17:31PM +0800, Ming Lei wrote:
> On Fri, Aug 16, 2019 at 11:42 AM Bart Van Assche <bvanassche@acm.org> wrote:
> >
> > On 8/15/19 7:54 PM, Ming Lei wrote:
> > > It is reported that sysfs buffer overflow can be triggered in case
> > > of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> > > blk_mq_hw_sysfs_cpus_show().
> > >
> > > So use cpumap_print_to_pagebuf() to print the info and fix the potential
> > > buffer overflow issue.
> > >
> > > Cc: stable@vger.kernel.org
> > > Cc: Mark Ray <mark.ray@hpe.com>
> > > Cc: Greg KH <gregkh@linuxfoundation.org>
> > > Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >   block/blk-mq-sysfs.c | 15 +--------------
> > >   1 file changed, 1 insertion(+), 14 deletions(-)
> > >
> > > diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> > > index d6e1a9bd7131..4d0d32377ba3 100644
> > > --- a/block/blk-mq-sysfs.c
> > > +++ b/block/blk-mq-sysfs.c
> > > @@ -166,20 +166,7 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
> > >
> > >   static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
> > >   {
> > > -     unsigned int i, first = 1;
> > > -     ssize_t ret = 0;
> > > -
> > > -     for_each_cpu(i, hctx->cpumask) {
> > > -             if (first)
> > > -                     ret += sprintf(ret + page, "%u", i);
> > > -             else
> > > -                     ret += sprintf(ret + page, ", %u", i);
> > > -
> > > -             first = 0;
> > > -     }
> > > -
> > > -     ret += sprintf(ret + page, "\n");
> > > -     return ret;
> > > +     return cpumap_print_to_pagebuf(true, page, hctx->cpumask);
> > >   }
> > >
> > >   static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_nr_tags = {
> >
> > Although this patch looks fine to me, shouldn't this attribute be
> > documented under Documentation/ABI/?
> 
> That is another problem, not closely related with this buffer-overflow issue.
> 
> I suggest to fix the buffer overflow first, which is triggered from userspace.

I suggest you just delete this whole sysfs attribute, which will solve
the buffer overflow, as no one should be using it and it is incorrect to
have.

thanks,

greg k-h
