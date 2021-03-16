Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1A733D64D
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 16:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhCPPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 11:00:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:47942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhCPPA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 11:00:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D5C5AC24;
        Tue, 16 Mar 2021 15:00:28 +0000 (UTC)
Date:   Tue, 16 Mar 2021 16:00:26 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Huang Rui <ray.huang@amd.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iommu/amd: Fix iommu remap panic while amd_iommu is set
 to disable
Message-ID: <YFDICtszzhFzX8cH@suse.de>
References: <20210311142807.705080-1-ray.huang@amd.com>
 <YFCvsort3oZGfDBy@suse.de>
 <20210316133602.GB2497230@hr-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316133602.GB2497230@hr-amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 09:36:02PM +0800, Huang Rui wrote:
> Thanks for the comments. Could you please elaborate this?
> 
> Do you mean while amd_iommu=off, we won't prepare the IVRS, and even
> needn't get all ACPI talbes. Because they are never be used and the next
> state will always goes into IOMMU_CMDLINE_DISABLED, am I right?

The first problem was that amd_iommu_irq_remap is never set back to
false when irq-remapping initialization fails in amd_iommu_prepare().

But there are other problems, like that even when the IOMMU is set to
disabled on the command line with amd_iommu=off, the code still sets up
all IOMMUs and registers IRQ domains for them.

Later the code checks wheter the IOMMU should stay disabled and tears
everything down, except for the IRQ domains, which stay in the global
list.

The APIs do not really support tearing down IRQ domains well, so its not
so easy to add this to the tear-down path. Now that the IRQ domains stay
in the list, the ACPI code will come along later and calls the
->select() call-back for every IRQ domain, which gets execution to
irq_remapping_select(), depite IOMMU being disabled and
amd_iommu_rlookup_table already de-allocated. But since
amd_iommu_irq_remap is still true the NULL pointer is dereferenced,
causing the crash.

When the IRQ domains would not be around, this would also not happen. So
my patches also change the initializtion to not do all the setup work
when amd_iommu=off was passed on the command line.

Regards,

	Joerg
