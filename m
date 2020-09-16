Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A10B26BF67
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIPIe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgIPIe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 04:34:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CDAF20795;
        Wed, 16 Sep 2020 08:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600245267;
        bh=5KLkA+J2/h4eyGXRPb1P2FQzvzNuKGk/+COHN+p/Ppk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vI336rtD1Shh6hNtyvcoudIm1LkDtc5bt5bmYZ5Dp2UHKGu95jAcATPJff75z82Wj
         CCkhnImzgGirdmdsNURNuDKKTcs+MuOk/WXRz/FjfT1knQGDGOguEqqsgnC8yUMLs1
         VZdZez1PU6f9/qRX4pFcq36uldf4/ngIc3lzee04=
Date:   Wed, 16 Sep 2020 10:35:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915/gt: Wait for CSB entries on
 Tigerlake
Message-ID: <20200916083501.GA675213@kroah.com>
References: <20200915124150.12045-1-chris@chris-wilson.co.uk>
 <20200915124150.12045-2-chris@chris-wilson.co.uk>
 <20200916063358.GL142621@kroah.com>
 <160024481825.2231.4268855132793535750@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160024481825.2231.4268855132793535750@build.alporthouse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 09:26:58AM +0100, Chris Wilson wrote:
> Quoting Greg KH (2020-09-16 07:33:58)
> > On Tue, Sep 15, 2020 at 01:41:48PM +0100, Chris Wilson wrote:
> > > On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
> > > Forcibly evict stale csb entries") where, presumably, due to a missing
> > > Global Observation Point synchronisation, the write pointer of the CSB
> > > ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
> > > we see the GPU report more context-switch entries for us to parse, but
> > > those entries have not been written, leading us to process stale events,
> > > and eventually report a hung GPU.
> > > 
> > > However, this effect appears to be much more severe than we previously
> > > saw on Icelake (though it might be best if we try the same approach
> > > there as well and measure), and Bruce suggested the good idea of resetting
> > > the CSB entry after use so that we can detect when it has been updated by
> > > the GPU. By instrumenting how long that may be, we can set a reliable
> > > upper bound for how long we should wait for:
> > > 
> > >     513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)
> > > 
> > > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
> > > References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")
> > 
> > What does "References:" mean?  Should that be "Fixes:"?
> 
> It's a reference to an earlier w/a for a previous generation for the
> same symptoms. This patch should supplement that w/a.

I see no such "reference" to that tag in
Documentation/process/submitting-patches.rst, so how were we supposed to
know this?  :)

thanks,

greg k-h
