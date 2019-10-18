Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68BDD0A8
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 22:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404444AbfJRUxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 16:53:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390535AbfJRUxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 16:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mUPVBXLV4K5EO90WfnmPs43qm4UQmzSkfjJgIXw2cYY=; b=UvV6Zikb2r1VEfOW9HSLCda1N
        GTXKwNoLNX4SsOHuLnDq2T/huk5dySxjgOHkaSSoF0vgffTwNSm4dvs2G9dHCb/uDHFpp3KV53nV8
        BFprSAvyq9YVpeNvwPZRBiohNRQ1rKMbPibru/nvnC3jPEUcjYh/QG0fdajBx0sGDalzbeV2LvOCq
        FIuRpRcnebuYQ2RgGDCimVef1lcGtWd3cWHYLlzv9qzuKwHwY0Z+JIGJw27a99iyCKKAF8/9A7uQ4
        eC28+UvmStHQB8F5xClsAIe7Z125qJj1AVvgDZzhElicScrjiCJzLrCEPuIJ7iyDOUBnctOQQ68AV
        cMpINGAzg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLZFZ-0001Yi-CR; Fri, 18 Oct 2019 20:53:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CF4E8301124;
        Fri, 18 Oct 2019 22:52:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BE1D820238A88; Fri, 18 Oct 2019 22:53:26 +0200 (CEST)
Date:   Fri, 18 Oct 2019 22:53:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage
 with high throttling by removing expiration of cpu-local slices
Message-ID: <20191018205326.GB1817@hirez.programming.kicks-ass.net>
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com>
 <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
 <20190927131332.GO8171@sasha-vm>
 <CAC=E7cVyO=j8FKBKkdOU2KOM_O=3XmXZd0OoyYCDWez_twuk-A@mail.gmail.com>
 <20191003065135.GA1813585@kroah.com>
 <CAC=E7cWYpdA1Ufds6OoAu+5eP+kTXY1OzZ8O7nLYrfb_tCBEZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=E7cWYpdA1Ufds6OoAu+5eP+kTXY1OzZ8O7nLYrfb_tCBEZg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 03:23:02PM -0500, Dave Chiluk wrote:
> @Ben @Ingo @Peter
> Can you please please ack this backport request?
> 
> Thank you,
> Dave Chiluk
> 
> On Thu, Oct 3, 2019 at 1:51 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Oct 03, 2019 at 12:15:02AM -0500, Dave Chiluk wrote:
> > > @Greg KH, Qian Cai's compiler warning fix has now been integrated into
> > > Linus' tree as commit: 763a9ec06c409
> > >
> > > Both de53fd7aedb1 and 763a9ec06c40 are now apart of v5.4-rc1.  Can you
> > > please queue up these fixes for backport to all stable kernels.
> >
> > I need an ack from the scheduler maintainers that this is ok to do so...

Sure I suppose, but what makes this commit special? Don't you normally
take just about anything?
