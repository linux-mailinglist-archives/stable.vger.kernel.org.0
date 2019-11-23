Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337FC107FA4
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 18:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfKWRfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 12:35:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbfKWRfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Nov 2019 12:35:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D627B2067D;
        Sat, 23 Nov 2019 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574530549;
        bh=dKzEpKOOSPW3aZELtJVwMo8eAbxh/xiZ2r+45+IxQBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bT/gRgearKafLLp9ZCRBcTuKU0mAOHE/B+YL1MQaI2E4F3BLv+dWIOu4CLkcrHcrZ
         C0u+P8/oscSnnR6TAmnzup69DHKHQBC238UR8CphPjOMQ5Qv8UhISP3suI1wc0qtSv
         o4xo+S95gNZZKIp6Twqj5cbIHAPV9fg76DEXbUD8=
Date:   Sat, 23 Nov 2019 18:35:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/220] 4.19.86-stable review
Message-ID: <20191123173547.GA2188842@kroah.com>
References: <20191122100912.732983531@linuxfoundation.org>
 <ae3d804f-594b-80f9-048b-7da45806278c@roeck-us.net>
 <20191122151631.GA2083451@kroah.com>
 <20191122170534.GV20752@bombadil.infradead.org>
 <20191122213331.GA2102330@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122213331.GA2102330@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 10:33:31PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Nov 22, 2019 at 09:05:34AM -0800, Matthew Wilcox wrote:
> > On Fri, Nov 22, 2019 at 04:16:31PM +0100, Greg Kroah-Hartman wrote:
> > > On Fri, Nov 22, 2019 at 06:47:05AM -0800, Guenter Roeck wrote:
> > > > On 11/22/19 2:26 AM, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 4.19.86 release.
> > > > > There are 220 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > 
> > > > I see the following warning (at least for arm64, ppc64, and x86_64).
> > > > This seems to be caused by "idr: Fix idr_get_next race with idr_remove".
> > > > v4.14.y is also affected. Mainline and v5.3.y are not affected.
> > 
> > That makes sense; the code in question is different after 4.19.
> > Thanks for the report; it's very clear.
> > 
> > > Willy, this looks like something from your patch, is it to be expected?
> > 
> > It's harmless; the problem is that we can't check whether the dereference
> > is safe.  The caller isn't holding the RCU lock, and the IDR code doesn't
> > know what lock is being held to make this dereference safe.  Do you want
> > a changelog for this oneliner which disables the checking?
> > 
> > diff --git a/lib/idr.c b/lib/idr.c
> > index 49e7918603c7..6ff3b1c36e0a 100644
> > --- a/lib/idr.c
> > +++ b/lib/idr.c
> > @@ -237,7 +237,7 @@ void *idr_get_next(struct idr *idr, int *nextid)
> >  
> >  	id = (id < base) ? 0 : id - base;
> >  	radix_tree_for_each_slot(slot, &idr->idr_rt, &iter, id) {
> > -		entry = radix_tree_deref_slot(slot);
> > +		entry = rcu_dereference_raw(*slot);
> >  		if (!entry)
> >  			continue;
> >  		if (!radix_tree_deref_retry(entry))
> 
> Thanks for this, I'll merge it with the existing patch tomorrow, it's
> late here...

Now fixed up in the 4.14 and 4.19 trees, thanks.

greg k-h
