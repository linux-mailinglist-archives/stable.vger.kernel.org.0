Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850901F63A0
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 10:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgFKIbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 04:31:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:37176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgFKIbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 04:31:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6329AABC7;
        Thu, 11 Jun 2020 08:31:53 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 39E971E1283; Thu, 11 Jun 2020 10:31:49 +0200 (CEST)
Date:   Thu, 11 Jun 2020 10:31:49 +0200
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] bfq: Avoid false bfq queue merging
Message-ID: <20200611083149.GB18088@quack2.suse.cz>
References: <20200605140837.5394-1-jack@suse.cz>
 <20200605141629.15347-1-jack@suse.cz>
 <FC3651A1-DB65-4A77-9BFB-ACAB80E54F3E@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FC3651A1-DB65-4A77-9BFB-ACAB80E54F3E@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 11-06-20 09:13:07, Paolo Valente wrote:
> 
> 
> > Il giorno 5 giu 2020, alle ore 16:16, Jan Kara <jack@suse.cz> ha scritto:
> > 
> > bfq_setup_cooperator() uses bfqd->in_serv_last_pos so detect whether it
> > makes sense to merge current bfq queue with the in-service queue.
> > However if the in-service queue is freshly scheduled and didn't dispatch
> > any requests yet, bfqd->in_serv_last_pos is stale and contains value
> > from the previously scheduled bfq queue which can thus result in a bogus
> > decision that the two queues should be merged.
> 
> Good catch! 
> 
> > This bug can be observed
> > for example with the following fio jobfile:
> > 
> > [global]
> > direct=0
> > ioengine=sync
> > invalidate=1
> > size=1g
> > rw=read
> > 
> > [reader]
> > numjobs=4
> > directory=/mnt
> > 
> > where the 4 processes will end up in the one shared bfq queue although
> > they do IO to physically very distant files (for some reason I was able to
> > observe this only with slice_idle=1ms setting).
> > 
> > Fix the problem by invalidating bfqd->in_serv_last_pos when switching
> > in-service queue.
> > 
> 
> Apart from the nonexistent problem that even 0 is a valid LBA :)

Yes, I was also thinking about that and decided 0 is "good enough" :). But
I just as well just switch to (sector_t)-1 if you think it would be better.

> Acked-by: Paolo Valente <paolo.valente@linaro.org>

Thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
