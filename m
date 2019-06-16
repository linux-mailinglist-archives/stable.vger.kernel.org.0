Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAB0476AD
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 22:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfFPUHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 16:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727211AbfFPUHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 16:07:01 -0400
Received: from brain-police (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA50A20657;
        Sun, 16 Jun 2019 20:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560715620;
        bh=72sUR+zaF0lp/W7gPOXpIbJyNHZInIS+zl5zPvRRTyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXVLM2odnLWn2xQ7HlLNHoeT6EmZYNTNEcC48TZ/c0joF3uU2Xa5P2l6R70ZinWRB
         5TSfaEE0GrziuACtOKGOWWIJSMqSmscjLbxBznOgFCz82gZ/h0BnyJPWudkAq/Ms5r
         fSreDrTAk3jaUFOas3Va0c5ZoDNJaeQpcs19ZIcY=
Date:   Sun, 16 Jun 2019 21:06:55 +0100
From:   Will Deacon <will@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/118] iommu/arm-smmu-v3: Dont disable SMMU in
 kdump kernel
Message-ID: <20190616200654.GA13018@brain-police>
References: <20190613075643.642092651@linuxfoundation.org>
 <20190613075647.892923884@linuxfoundation.org>
 <20190616194236.GB6676@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616194236.GB6676@amd>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[FYI: This was in my spam folder. I'll reserve judgement on whether that's
the right decision.]

On Sun, Jun 16, 2019 at 09:42:36PM +0200, Pavel Machek wrote:
> > [ Upstream commit 3f54c447df34ff9efac7809a4a80fd3208efc619 ]
> > 
> > Disabling the SMMU when probing from within a kdump kernel so that all
> > incoming transactions are terminated can prevent the core of the crashed
> > kernel from being transferred off the machine if all I/O devices are
> > behind the SMMU.
> > 
> > Instead, continue to probe the SMMU after it is disabled so that we can
> > reinitialise it entirely and re-attach the DMA masters as they are reset.
> > Since the kdump kernel may not have drivers for all of the active DMA
> > masters, we suppress fault reporting to avoid spamming the console and
> > swamping the IRQ threads.
> 
> > +++ b/drivers/iommu/arm-smmu-v3.c
> > @@ -2414,13 +2414,9 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
> >  	/* Clear CR0 and sync (disables SMMU and queue processing) */
> >  	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
> >  	if (reg & CR0_SMMUEN) {
> > -		if (is_kdump_kernel()) {
> > -			arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
> > -			arm_smmu_device_disable(smmu);
> > -			return -EBUSY;
> > -		}
> > -
> >  		dev_warn(smmu->dev, "SMMU currently enabled! Resetting...\n");
> > +		WARN_ON(is_kdump_kernel() && !disable_bypass);
> > +		arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
> >  	}
> >
> 
> This changes behaviour in !is_kdump_kernel() case. Is that
> ok/intended?

Yes, that's intentional. If we find the SMMU in an enabled state, it's
probably a good idea to configure it to abort all transactions before
disabling it, otherwise virtual addresses suddenly become physical addresses
and we could corrupt random memory. However, I don't think I've ever seen
this happen outside of kdump so it's admittedly a bit of a theoretical
scenario.

Regardless, patches to -stable should probably match their upstream
counterparts so even if this was an issue, I don't think this is the right
place to discuss it.

Will
