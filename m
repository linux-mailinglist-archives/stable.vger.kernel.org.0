Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BF6508FD1
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381539AbiDTSz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 14:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381607AbiDTSz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 14:55:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3469B44A02;
        Wed, 20 Apr 2022 11:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TjBxCy4KdKHXLg8qp3eQ2l0d98HskHx6Bo4iw1+O0PM=; b=xPDZSxfLFeBIusyvmCeDsgIb3V
        q8dtaCqwY5Q7fmO3b4PQ9XrK1EzbQJUx+NJ9fwNEw13I4+Vf3AK/wns4ZR1B3rDR1O5KarOm0RoUA
        nNQ6nsJrDShfed9du/FmASyuiDBFfELS1TSoaeBu839G8irqHQXmf9JuPA7GbxCbB/GXSmiRhpR/U
        JUDsQOzNa0vT+KPOwBxm60Nma0TyfOuiODt2ueuy/9Iaa5AMQSkaWL9+RVbGNOG6rzwLxH/01DHAI
        h9ZEX+2Wwqo7eKCCx5JQFZY5jfRdVv2d/uHrjaHFOM5E+MsRYWpL9XcCOBKZeRXrH20jIKyAT08jt
        C4Td3WhQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nhFRM-00A7PN-Of; Wed, 20 Apr 2022 18:52:36 +0000
Date:   Wed, 20 Apr 2022 11:52:36 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Sasha Levin <sashal@kernel.org>, Klaus Jensen <its@irrelevant.dk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 18/18] nvme-pci: disable namespace
 identifiers for Qemu controllers
Message-ID: <YmBWdMfQ/WIACcTg@bombadil.infradead.org>
References: <20220419181353.485719-1-sashal@kernel.org>
 <20220419181353.485719-18-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419181353.485719-18-sashal@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 02:13:52PM -0400, Sasha Levin wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 66dd346b84d79fde20832ed691a54f4881eac20d ]
> 
> Qemu unconditionally reports a UUID, which depending on the qemu version
> is either all-null (which is incorrect but harmless) or contains a single
> bit set for all controllers.  In addition it can also optionally report
> a eui64 which needs to be manually set.  Disable namespace identifiers
> for Qemu controlles entirely even if in some cases they could be set
> correctly through manual intervention.
> 
> Reported-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Huh? The NVME_QUIRK_BOGUS_NID is a new define and the code which uses
this quirk is also new, and so I'm curious *how and why* the auto-sel
stuff for stable can decide to merge this and this should not even
compile? I see this was backported to v5.15  and v5.17 as well.

I didn't get Cc'd on perhaps some other patches, but this immediately
caught my attention as not applicable, unless of course the patch
"nvme: add a quirk to disable namespace identifiers" was also sent
as part of this series to stable kernels. And if that was done, well
holy crap, really?

Cc'ing Klaus on the qemu side of things so he's aware.

  Luis

> ---
>  drivers/nvme/host/pci.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 97afeb898b25..6939b03a16c5 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -3212,7 +3212,10 @@ static const struct pci_device_id nvme_id_table[] = {
>  		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
>  	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
>  		.driver_data = NVME_QUIRK_IDENTIFY_CNS |
> -				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
> +				NVME_QUIRK_DISABLE_WRITE_ZEROES |
> +				NVME_QUIRK_BOGUS_NID, },
> +	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
> +		.driver_data = NVME_QUIRK_BOGUS_NID, },
>  	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
>  		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
>  	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
> -- 
> 2.35.1
> 
