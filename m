Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A32E24728D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgHQSoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388072AbgHQP4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:56:25 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5924321744;
        Mon, 17 Aug 2020 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679784;
        bh=gb6AJp1/gUftYJ0981u1yL44XSzUl46FG5/OEVcD+kU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tznc/FJfNC+CzrjtuuHI6b0wwD/THFDvzAYbXWqd1joVTaDQ3RDAwmlqdzA+Reg0b
         CGLtVlSZMl1shHYii5sztddMqkfQifO9JdsEV/rMU5YjP4xjPTW76tZ2wJXXM/nlli
         rjrPuFMmi3eIpwAaiio1+7FeITPukuJXwDUZ166w=
Date:   Mon, 17 Aug 2020 08:56:22 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Eric Deal <eric.deal@wdc.com>, stable@vger.kernel.org
Subject: Re: [PATCH] block: fix get_max_io_size()
Message-ID: <20200817155622.GA1221871@dhcp-10-100-145-180.wdl.wdc.com>
References: <20200806215837.3968445-1-kbusch@kernel.org>
 <88d4db76-b912-8987-cfac-a2b926fbfe3d@acm.org>
 <c2275412-5106-e0a3-63db-a7b0ceedd1d3@acm.org>
 <20200807032437.GC3797376@dhcp-10-100-145-180.wdl.wdc.com>
 <60baf63a-6264-812e-15e6-b0a28b07329f@acm.org>
 <20200807171001.GA4155677@dhcp-10-100-145-180.wdl.wdc.com>
 <170914cf-b8f3-a262-7679-989d0182d6d0@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170914cf-b8f3-a262-7679-989d0182d6d0@acm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 12:02:30PM -0700, Bart Van Assche wrote:
> On 2020-08-07 10:10, Keith Busch wrote:
> > On Fri, Aug 07, 2020 at 07:18:49AM -0700, Bart Van Assche wrote:
> >> Hi Keith,
> >>
> >> How about replacing your patch with the (untested) patch below?
> > 
> > 
> > I believe that should be fine, but I broke the kernel last time I did
> > something like that. I still think it was from incorrect queue_limits,
> > but Linus disagreed.
> > 
> >  * http://lkml.iu.edu/hypermail/linux/kernel/1601.2/03994.html
> 
> Hi Keith,
> 
> Thanks for the interesting link. Regarding Linus' comments about bio
> splitting: if the last return statement in get_max_io_size() is reached
> then it is guaranteed that sectors < pbs (physical block size). So I think
> that Linus' comment applies to the previous return statement instead of to
> the last ("return max_sectors - start_offset;"). However, I think it is
> already guaranteed that that value is a multiple of the logical block size
> because start_offset is a multiple of the logical block size and because
> of the following statement: "max_sectors &= ~(pbs - 1);".

This breaks if limits.max_sectors is not a multiple of the queue's
logical block size and the physical block size is larger than
max_sectors.
