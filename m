Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DAE8EBCA
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 14:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbfHOMne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 08:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfHOMne (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 08:43:34 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5560308A9E0;
        Thu, 15 Aug 2019 12:43:33 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 401A48CBAE;
        Thu, 15 Aug 2019 12:43:27 +0000 (UTC)
Date:   Thu, 15 Aug 2019 20:43:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>
Subject: Re: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU cores
Message-ID: <20190815124321.GB28032@ming.t460p>
References: <20190815121518.16675-1-ming.lei@redhat.com>
 <20190815122419.GA31891@kroah.com>
 <20190815122909.GA28032@ming.t460p>
 <20190815123535.GA29217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815123535.GA29217@kroah.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 15 Aug 2019 12:43:33 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 02:35:35PM +0200, Greg KH wrote:
> On Thu, Aug 15, 2019 at 08:29:10PM +0800, Ming Lei wrote:
> > On Thu, Aug 15, 2019 at 02:24:19PM +0200, Greg KH wrote:
> > > On Thu, Aug 15, 2019 at 08:15:18PM +0800, Ming Lei wrote:
> > > > It is reported that sysfs buffer overflow can be triggered in case
> > > > of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> > > > one hctx.
> > > > 
> > > > So use snprintf for avoiding the potential buffer overflow.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Mark Ray <mark.ray@hpe.com>
> > > > Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >  block/blk-mq-sysfs.c | 30 ++++++++++++++++++------------
> > > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> > > > index d6e1a9bd7131..e75f41a98415 100644
> > > > --- a/block/blk-mq-sysfs.c
> > > > +++ b/block/blk-mq-sysfs.c
> > > > @@ -164,22 +164,28 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
> > > >  	return sprintf(page, "%u\n", hctx->tags->nr_reserved_tags);
> > > >  }
> > > >  
> > > > +/* avoid overflow by too many CPU cores */
> > > >  static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
> > > >  {
> > > > -	unsigned int i, first = 1;
> > > > -	ssize_t ret = 0;
> > > > -
> > > > -	for_each_cpu(i, hctx->cpumask) {
> > > > -		if (first)
> > > > -			ret += sprintf(ret + page, "%u", i);
> > > > -		else
> > > > -			ret += sprintf(ret + page, ", %u", i);
> > > > -
> > > > -		first = 0;
> > > > +	unsigned int cpu = cpumask_first(hctx->cpumask);
> > > > +	ssize_t len = snprintf(page, PAGE_SIZE - 1, "%u", cpu);
> > > > +	int last_len = len;
> > > > +
> > > > +	while ((cpu = cpumask_next(cpu, hctx->cpumask)) < nr_cpu_ids) {
> > > > +		int cur_len = snprintf(page + len, PAGE_SIZE - 1 - len,
> > > > +				       ", %u", cpu);
> > > > +		if (cur_len >= PAGE_SIZE - 1 - len) {
> > > > +			len -= last_len;
> > > > +			len += snprintf(page + len, PAGE_SIZE - 1 - len,
> > > > +					"...");
> > > > +			break;
> > > > +		}
> > > > +		len += cur_len;
> > > > +		last_len = cur_len;
> > > >  	}
> > > >  
> > > > -	ret += sprintf(ret + page, "\n");
> > > > -	return ret;
> > > > +	len += snprintf(page + len, PAGE_SIZE - 1 - len, "\n");
> > > > +	return len;
> > > >  }
> > > >
> > > 
> > > What????
> > > 
> > > sysfs is "one value per file".  You should NEVER have to care about the
> > > size of the sysfs buffer.  If you do, you are doing something wrong.
> > > 
> > > What excatly are you trying to show in this sysfs file?  I can't seem to
> > > find the Documenatation/ABI/ entry for it, am I just missing it because
> > > I don't know the filename for it?
> > 
> > It is /sys/block/$DEV/mq/$N/cpu_list, all CPUs in this hctx($N) will be
> > shown via sysfs buffer. The buffer size is one PAGE, how can it hold when
> > there are too many CPUs(close to 1K)?
> 
> Looks like I only see 1 cpu listed on my machines in those files, what
> am I doing wrong?

It depends on machine. The issue is reported on one machine with 896 CPU
cores, when 4K buffer can only hold 841 cores.

> 
> Also, I don't see cpu_list in any of the documentation files, so I have
> no idea what you are trying to have this file show.
> 
> And again, "one value per file" is the sysfs rule.  "all cpus in the
> system" is not "one value" :)

I agree, and this file shouldn't be there, given each CPU will have one
kobject dir under the hctx dir.

We may kill the 'cpu_list' attribute, is there anyone who objects?


Thanks,
Ming
