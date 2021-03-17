Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E15533F287
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 15:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhCQOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 10:25:05 -0400
Received: from 8bytes.org ([81.169.241.247]:59472 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231786AbhCQOYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 10:24:49 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B857A3A4; Wed, 17 Mar 2021 15:24:47 +0100 (CET)
Date:   Wed, 17 Mar 2021 15:24:46 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] iommu/amd: Don't call early_amd_iommu_init() when
 AMD IOMMU is disabled
Message-ID: <YFIRLh3PPiW1hCQZ@8bytes.org>
References: <20210317091037.31374-1-joro@8bytes.org>
 <20210317091037.31374-3-joro@8bytes.org>
 <449d4a2d192d23eb504e43b13c35c326f2d0309a.camel@infradead.org>
 <YFIE8xnr/HWqxm4p@8bytes.org>
 <3014DA56-84D8-474B-94FE-6FDBB6241F9F@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3014DA56-84D8-474B-94FE-6FDBB6241F9F@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 01:37:16PM +0000, David Woodhouse wrote:
> If we can get to the point where we don't even need to check
> amd_iommu_irq_remap in the ...select() function because the IRQ domain
> is never even registered in the case where the flag ends up false, all
> the better :)

This should already be achieved with this patch :)

But the check is still needed if something goes wrong during IOMMU
initialization. In this case the IOMMUs are teared down and the memory
is freed. But the IRQ domains stay registered for now, mostly because
the upper-level APIs to register them lack a deregister function.

I havn't looked into the details yet whether it is suffient to call
irq_domain_remove() on a domain created with
arch_create_remap_msi_irq_domain() for example. This needs more research
on my side :)

Regards,

	Joerg
