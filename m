Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E3326BF39
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgIPI12 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Sep 2020 04:27:28 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:60598 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726612AbgIPI1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 04:27:09 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22442442-1500050 
        for multiple; Wed, 16 Sep 2020 09:26:57 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200916063358.GL142621@kroah.com>
References: <20200915124150.12045-1-chris@chris-wilson.co.uk> <20200915124150.12045-2-chris@chris-wilson.co.uk> <20200916063358.GL142621@kroah.com>
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915/gt: Wait for CSB entries on Tigerlake
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
To:     Greg KH <gregkh@linuxfoundation.org>
Date:   Wed, 16 Sep 2020 09:26:58 +0100
Message-ID: <160024481825.2231.4268855132793535750@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg KH (2020-09-16 07:33:58)
> On Tue, Sep 15, 2020 at 01:41:48PM +0100, Chris Wilson wrote:
> > On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
> > Forcibly evict stale csb entries") where, presumably, due to a missing
> > Global Observation Point synchronisation, the write pointer of the CSB
> > ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
> > we see the GPU report more context-switch entries for us to parse, but
> > those entries have not been written, leading us to process stale events,
> > and eventually report a hung GPU.
> > 
> > However, this effect appears to be much more severe than we previously
> > saw on Icelake (though it might be best if we try the same approach
> > there as well and measure), and Bruce suggested the good idea of resetting
> > the CSB entry after use so that we can detect when it has been updated by
> > the GPU. By instrumenting how long that may be, we can set a reliable
> > upper bound for how long we should wait for:
> > 
> >     513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)
> > 
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
> > References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")
> 
> What does "References:" mean?  Should that be "Fixes:"?

It's a reference to an earlier w/a for a previous generation for the
same symptoms. This patch should supplement that w/a.
-Chris
