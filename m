Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E913C716
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAOPLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgAOPLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 10:11:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD259222C3;
        Wed, 15 Jan 2020 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579101081;
        bh=3gTNlszr+LAWpyQAE9KCG1f9A2EIwYniEezh0GNli7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSztWCtE7OCoSmM5XihhW6xXTTQSxnf9FmQw8flyMeiHK+7qSvtL8C42FQ8Z2sc4T
         rVPD+6bdqi4RgQxeV3urPxq0U+0+XdIyUMGeJ27mCSIQyyPyWQUfjacDJpbPCIdNja
         gEbc9AOg+rgwKSX7+wfvUmz1E5Pn58TmLlH1nlDA=
Date:   Wed, 15 Jan 2020 16:11:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 1/2] coresight: etb10: Do not call
 smp_processor_id from preemptible
Message-ID: <20200115151118.GC3740793@kroah.com>
References: <20200108110541.318672-1-suzuki.poulose@arm.com>
 <20200109143537.GE1706@sasha-vm>
 <a183da32-b933-6ed0-f8b8-703e27d3f15e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a183da32-b933-6ed0-f8b8-703e27d3f15e@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 09, 2020 at 02:36:17PM +0000, Suzuki Kuruppassery Poulose wrote:
> On 09/01/2020 14:35, Sasha Levin wrote:
> > On Wed, Jan 08, 2020 at 11:05:40AM +0000, Suzuki K Poulose wrote:
> > > [ Upstream commit 730766bae3280a25d40ea76a53dc6342e84e6513 ]
> > > 
> > > During a perf session we try to allocate buffers on the "node" associated
> > > with the CPU the event is bound to. If it is not bound to a CPU, we
> > > use the current CPU node, using smp_processor_id(). However this is
> > > unsafe
> > > in a pre-emptible context and could generate the splats as below :
> > > 
> > > BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
> > > 
> > > Use NUMA_NO_NODE hint instead of using the current node for events
> > > not bound to CPUs.
> > > 
> > > Fixes: 2997aa4063d97fdb39 ("coresight: etb10: implementing AUX API")
> > > Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Cc: stable <stable@vger.kernel.org> # v4.9 to v4.19
> > > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > > Link: https://lore.kernel.org/r/20190620221237.3536-5-mathieu.poirier@linaro.org
> > > 
> > 
> > I've queued this for 4.9-4.19. There was a simple conflict on 4.9 which
> > also had to be resolved.
> > 
> 
> 
> Thanks Sasha !

Note, these had to all be dropped as they broke the build :(

So can you please send us patches that at least build?  :)

thanks,

greg k-h
