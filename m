Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10534843FE
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 07:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfHGFof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 01:44:35 -0400
Received: from verein.lst.de ([213.95.11.211]:34469 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbfHGFof (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 01:44:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 843B768B05; Wed,  7 Aug 2019 07:44:31 +0200 (CEST)
Date:   Wed, 7 Aug 2019 07:44:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.2 073/131] dma-direct: correct the physical addr in
 dma_direct_sync_sg_for_cpu/device
Message-ID: <20190807054431.GA6475@lst.de>
References: <20190805124951.453337465@linuxfoundation.org> <20190805124956.543654128@linuxfoundation.org> <20190806124143.GF17747@sasha-vm> <9dd82745-1673-afc3-5eb4-8b79ddb5824b@arm.com> <20190806220448.GN17747@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806220448.GN17747@sasha-vm>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 06:04:48PM -0400, Sasha Levin wrote:
> On Tue, Aug 06, 2019 at 01:57:56PM +0100, Robin Murphy wrote:
>> Given that the two commits touch entirely separate files I'm not sure what 
>> the imagined dependency could be :/
>
>> From the commit message of 3de433c5b38a ("drm/msm: Use the correct
> dma_sync calls in msm_gem"):
>
>    Fixes the combination of two patches:
>
>    Fixes: 0036bc73ccbe (drm/msm: stop abusing dma_map/unmap for cache)
>    Fixes: 449fa54d6815 (dma-direct: correct the physical addr in dma_direct_sync_sg_for_cpu/device)
>
>> 0036bc73ccbe is indeed not a fix (frankly I'm not convinced it's even a 
>> valid change at all) but even conceptually it bears no relation whatsoever 
>> to the genuine bug fixed by 449fa54d6815.
>
> Given that Rob Clark asked me to drop 0036bc73ccbe not because it's
> irrelevant but because it's potentially dangerous, I did not feel
> confident enough ignoring the statement in the commit message and
> dropped this patch instead.

449fa54d6815 fixes swiotlb misbehaving vs the API spec for the call,
something that real users on x86 cought.  Robs fix works around the
fact that msm is badly abusing dma API.  So even if both are genuine
bugs it is pretty clear we need to decide the match for the proper
users of the API and not the single abuser.
