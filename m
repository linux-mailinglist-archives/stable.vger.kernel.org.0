Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0873D33D4B3
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 14:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhCPNQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 09:16:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:35074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhCPNQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 09:16:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 49836AC47;
        Tue, 16 Mar 2021 13:16:36 +0000 (UTC)
Date:   Tue, 16 Mar 2021 14:16:34 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Huang Rui <ray.huang@amd.com>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: Fix iommu remap panic while amd_iommu is set
 to disable
Message-ID: <YFCvsort3oZGfDBy@suse.de>
References: <20210311142807.705080-1-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311142807.705080-1-ray.huang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Huang,

On Thu, Mar 11, 2021 at 10:28:07PM +0800, Huang Rui wrote:
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index f0adbc48fd17..a08e885403b7 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3862,7 +3862,7 @@ static int irq_remapping_select(struct irq_domain *d, struct irq_fwspec *fwspec,
>  	else if (x86_fwspec_is_hpet(fwspec))
>  		devid = get_hpet_devid(fwspec->param[0]);
>  
> -	if (devid < 0)
> +	if (devid < 0 || !amd_iommu_rlookup_table)
>  		return 0;

The problem is deeper than this fix suggests. I prepared other fixes for
this particular problem. Please find them here:

	https://git.kernel.org/pub/scm/linux/kernel/git/joro/linux.git/log/?h=iommu-fixes

Regards,

	Joerg
