Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D3026BD37
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIPGdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgIPGdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 02:33:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44177206A5;
        Wed, 16 Sep 2020 06:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600238003;
        bh=wIHXaI6KNDEeIf6lJk7M0ugz5xhnlkyEFdtA6sHzDGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2q9tLnApNZIwyqKiTSt9JDlKToe7BELueEwJvazqnppkuBa2vwDc/M5j9Khj6J77O
         1hOkLQgM69RsmNOWjRVafVr2nBXlGOKdNmlLXnmJmI3iv5DIEml06eFDGjzyS/VGWF
         HcA4O7vh3sngiD7uuss6Pz/L4fB63eiafZrWJbjM=
Date:   Wed, 16 Sep 2020 08:33:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] drm/i915/gt: Wait for CSB entries on Tigerlake
Message-ID: <20200916063358.GL142621@kroah.com>
References: <20200915124150.12045-1-chris@chris-wilson.co.uk>
 <20200915124150.12045-2-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915124150.12045-2-chris@chris-wilson.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 01:41:48PM +0100, Chris Wilson wrote:
> On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
> Forcibly evict stale csb entries") where, presumably, due to a missing
> Global Observation Point synchronisation, the write pointer of the CSB
> ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
> we see the GPU report more context-switch entries for us to parse, but
> those entries have not been written, leading us to process stale events,
> and eventually report a hung GPU.
> 
> However, this effect appears to be much more severe than we previously
> saw on Icelake (though it might be best if we try the same approach
> there as well and measure), and Bruce suggested the good idea of resetting
> the CSB entry after use so that we can detect when it has been updated by
> the GPU. By instrumenting how long that may be, we can set a reliable
> upper bound for how long we should wait for:
> 
>     513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
> References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")

What does "References:" mean?  Should that be "Fixes:"?

thanks,

greg k-h
