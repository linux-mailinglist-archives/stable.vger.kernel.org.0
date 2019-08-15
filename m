Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1848EB96
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 14:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbfHOMfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 08:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730903AbfHOMfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 08:35:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1B2D2083B;
        Thu, 15 Aug 2019 12:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565872538;
        bh=k4R/CgnyhJEBYltM8R7yPkXjy6ktMcNaPHC6rI0ILYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wsCNvT6/Xt4uBMke+T9Z9zGdxel2qT0n3r5RyUUqERVJm8cicz97OgxcO/tmr9FZ0
         1gshfnkDdcliV6K0GBC3U9Qw0wkfsjBemABPuQLSr5u40/8h4l1lj80Wet7Ay9+VSv
         bVTNWLZ2DmXHeFGRYeUGslUsWW0uj1HN56dkAfeY=
Date:   Thu, 15 Aug 2019 14:35:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>
Subject: Re: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU cores
Message-ID: <20190815123535.GA29217@kroah.com>
References: <20190815121518.16675-1-ming.lei@redhat.com>
 <20190815122419.GA31891@kroah.com>
 <20190815122909.GA28032@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815122909.GA28032@ming.t460p>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 08:29:10PM +0800, Ming Lei wrote:
> On Thu, Aug 15, 2019 at 02:24:19PM +0200, Greg KH wrote:
> > On Thu, Aug 15, 2019 at 08:15:18PM +0800, Ming Lei wrote:
> > > It is reported that sysfs buffer overflow can be triggered in case
> > > of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> > > one hctx.
> > > 
> > > So use snprintf for avoiding the potential buffer overflow.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Mark Ray <mark.ray@hpe.com>
> > > Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  block/blk-mq-sysfs.c | 30 ++++++++++++++++++------------
> > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> > > index d6e1a9bd7131..e75f41a98415 100644
> > > --- a/block/blk-mq-sysfs.c
> > > +++ b/block/blk-mq-sysfs.c
> > > @@ -164,22 +164,28 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
> > >  	return sprintf(page, "%u\n", hctx->tags->nr_reserved_tags);
> > >  }
> > >  
> > > +/* avoid overflow by too many CPU cores */
> > >  static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
> > >  {
> > > -	unsigned int i, first = 1;
> > > -	ssize_t ret = 0;
> > > -
> > > -	for_each_cpu(i, hctx->cpumask) {
> > > -		if (first)
> > > -			ret += sprintf(ret + page, "%u", i);
> > > -		else
> > > -			ret += sprintf(ret + page, ", %u", i);
> > > -
> > > -		first = 0;
> > > +	unsigned int cpu = cpumask_first(hctx->cpumask);
> > > +	ssize_t len = snprintf(page, PAGE_SIZE - 1, "%u", cpu);
> > > +	int last_len = len;
> > > +
> > > +	while ((cpu = cpumask_next(cpu, hctx->cpumask)) < nr_cpu_ids) {
> > > +		int cur_len = snprintf(page + len, PAGE_SIZE - 1 - len,
> > > +				       ", %u", cpu);
> > > +		if (cur_len >= PAGE_SIZE - 1 - len) {
> > > +			len -= last_len;
> > > +			len += snprintf(page + len, PAGE_SIZE - 1 - len,
> > > +					"...");
> > > +			break;
> > > +		}
> > > +		len += cur_len;
> > > +		last_len = cur_len;
> > >  	}
> > >  
> > > -	ret += sprintf(ret + page, "\n");
> > > -	return ret;
> > > +	len += snprintf(page + len, PAGE_SIZE - 1 - len, "\n");
> > > +	return len;
> > >  }
> > >
> > 
> > What????
> > 
> > sysfs is "one value per file".  You should NEVER have to care about the
> > size of the sysfs buffer.  If you do, you are doing something wrong.
> > 
> > What excatly are you trying to show in this sysfs file?  I can't seem to
> > find the Documenatation/ABI/ entry for it, am I just missing it because
> > I don't know the filename for it?
> 
> It is /sys/block/$DEV/mq/$N/cpu_list, all CPUs in this hctx($N) will be
> shown via sysfs buffer. The buffer size is one PAGE, how can it hold when
> there are too many CPUs(close to 1K)?

Looks like I only see 1 cpu listed on my machines in those files, what
am I doing wrong?

Also, I don't see cpu_list in any of the documentation files, so I have
no idea what you are trying to have this file show.

And again, "one value per file" is the sysfs rule.  "all cpus in the
system" is not "one value" :)

thanks,

greg k-h
