Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F389014B0BD
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 09:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgA1IPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 03:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgA1IPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 03:15:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C17F2467B;
        Tue, 28 Jan 2020 08:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580199324;
        bh=ds5dM3AIAtcb+wm25J2UVNjJPJLyE/L9V/4RrPyIPr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PM0n0JNfC02/ZfV8nuuf67Ms78ascFZ+WMQ2LKb//+/97/4TikoCyrQyrW9Rwum99
         agE1xWJ5j0yke0UVRfsGHZHF6cqfs0teMaIg+MOsWTYt0xqjW4ddj+E32jHZKNGO/U
         jXnLwO4iz2ET5qHawKynoZsChqX39LSj11BhnSUc=
Date:   Tue, 28 Jan 2020 09:15:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 1/2] coresight: etb10: Do not call
 smp_processor_id from preemptible
Message-ID: <20200128081520.GL2105706@kroah.com>
References: <20200108110541.318672-1-suzuki.poulose@arm.com>
 <20200109143537.GE1706@sasha-vm>
 <a183da32-b933-6ed0-f8b8-703e27d3f15e@arm.com>
 <20200115151118.GC3740793@kroah.com>
 <d3cd59e0-8fa2-9e69-534f-15f13cb14897@arm.com>
 <20200115172126.GB4127163@kroah.com>
 <b8c38ac4-4b47-59b3-e0d4-22be3f6aca42@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8c38ac4-4b47-59b3-e0d4-22be3f6aca42@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 05:28:19PM +0000, Suzuki Kuruppassery Poulose wrote:
> On 15/01/2020 17:21, Greg KH wrote:
> > On Wed, Jan 15, 2020 at 04:44:29PM +0000, Suzuki Kuruppassery Poulose wrote:
> > > 
> > > Hi Greg,
> > > 
> > > On 15/01/2020 15:11, Greg KH wrote:
> > > > On Thu, Jan 09, 2020 at 02:36:17PM +0000, Suzuki Kuruppassery Poulose wrote:
> > > > > On 09/01/2020 14:35, Sasha Levin wrote:
> > > > > > On Wed, Jan 08, 2020 at 11:05:40AM +0000, Suzuki K Poulose wrote:
> > > > > > > [ Upstream commit 730766bae3280a25d40ea76a53dc6342e84e6513 ]
> > > > > > > 
> > > > > > > During a perf session we try to allocate buffers on the "node" associated
> > > > > > > with the CPU the event is bound to. If it is not bound to a CPU, we
> > > > > > > use the current CPU node, using smp_processor_id(). However this is
> > > > > > > unsafe
> > > > > > > in a pre-emptible context and could generate the splats as below :
> > > > > > > 
> > > > > > > BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
> > > > > > > 
> > > > > > > Use NUMA_NO_NODE hint instead of using the current node for events
> > > > > > > not bound to CPUs.
> > > > > > > 
> > > > > > > Fixes: 2997aa4063d97fdb39 ("coresight: etb10: implementing AUX API")
> > > > > > > Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> > > > > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > > > > Cc: stable <stable@vger.kernel.org> # v4.9 to v4.19
> > > > > > > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > > > > > > Link: https://lore.kernel.org/r/20190620221237.3536-5-mathieu.poirier@linaro.org
> > > > > > > 
> > > > > > 
> > > > > > I've queued this for 4.9-4.19. There was a simple conflict on 4.9 which
> > > > > > also had to be resolved.
> > > > > > 
> > > > > 
> > > > > 
> > > > > Thanks Sasha !
> > > > 
> > > > Note, these had to all be dropped as they broke the build :(
> > > > 
> > > > So can you please send us patches that at least build?  :)
> > > > 
> > > 
> > > Do you have a build failure log ? I did build test it before sending it
> > > over. I tried it again on 4.9, 4.14 and 4.19. I don't hit any build
> > > failures here.
> > > 
> > > Please could you share the log if you have it handy ?
> > 
> > It was in the stable -rc review emails, I don't have it handy, sorry.
> > 
> 
> I think there is a bit of confusion here. If you're referring to
> 
> https://lkml.org/lkml/2020/1/11/634
> 
> as the build failure report, this is precisely my series fixes.
> I sent this series to address the build break reported by Nathan.
> The original patches were picked up from the "Fixes" tag automatically
> which broke the build due to missing "event" parameter. This series
> fixes those build issues and for sure builds fine for the affected
> versions. Trust me ;-)

Ok, for some reason it looked like the "original" commits were added to
the tree, not your backports.  I've queued up your backports now, that
should solve the issue.

thanks,

greg k-h

