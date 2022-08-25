Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68ED95A17D3
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 19:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239959AbiHYRRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 13:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbiHYRRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 13:17:24 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABF45BC11C
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 10:17:23 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBE5DD6E;
        Thu, 25 Aug 2022 10:17:27 -0700 (PDT)
Received: from [10.57.16.12] (unknown [10.57.16.12])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 192883F93E;
        Thu, 25 Aug 2022 10:17:21 -0700 (PDT)
Message-ID: <34e10279-160f-f126-2402-6dd38b9c4f5a@arm.com>
Date:   Thu, 25 Aug 2022 18:17:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v3] iommu/virtio: Fix interaction with VFIO
Content-Language: en-GB
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>, joro@8bytes.org
Cc:     will@kernel.org, virtualization@lists.linux-foundation.org,
        iommu@lists.linux.dev, stable@vger.kernel.org
References: <20220825154622.86759-1-jean-philippe@linaro.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220825154622.86759-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-08-25 16:46, Jean-Philippe Brucker wrote:
> Commit e8ae0e140c05 ("vfio: Require that devices support DMA cache
> coherence") requires IOMMU drivers to advertise
> IOMMU_CAP_CACHE_COHERENCY, in order to be used by VFIO. Since VFIO does
> not provide to userspace the ability to maintain coherency through cache
> invalidations, it requires hardware coherency. Advertise the capability
> in order to restore VFIO support.
> 
> The meaning of IOMMU_CAP_CACHE_COHERENCY also changed from "IOMMU can
> enforce cache coherent DMA transactions" to "IOMMU_CACHE is supported".

Argh! Massive apologies, I've been totally overlooking that detail and 
forgetting that we ended up splitting out the dedicated 
enforce_cache_coherency op... I do need reminding sometimes :)

> While virtio-iommu cannot enforce coherency (of PCIe no-snoop
> transactions), it does support IOMMU_CACHE.
> 
> We can distinguish different cases of non-coherent DMA:
> 
> (1) When accesses from a hardware endpoint are not coherent. The host
>      would describe such a device using firmware methods ('dma-coherent'
>      in device-tree, '_CCA' in ACPI), since they are also needed without
>      a vIOMMU. In this case mappings are created without IOMMU_CACHE.
>      virtio-iommu doesn't need any additional support. It sends the same
>      requests as for coherent devices.
> 
> (2) When the physical IOMMU supports non-cacheable mappings. Supporting
>      those would require a new feature in virtio-iommu, new PROBE request
>      property and MAP flags. Device drivers would use a new API to
>      discover this since it depends on the architecture and the physical
>      IOMMU.
> 
> (3) When the hardware supports PCIe no-snoop. It is possible for
>      assigned PCIe devices to issue no-snoop transactions, and the
>      virtio-iommu specification is lacking any mention of this.
> 
>      Arm platforms don't necessarily support no-snoop, and those that do
>      cannot enforce coherency of no-snoop transactions. Device drivers
>      must be careful about assuming that no-snoop transactions won't end
>      up cached; see commit e02f5c1bb228 ("drm: disable uncached DMA
>      optimization for ARM and arm64"). On x86 platforms, the host may or
>      may not enforce coherency of no-snoop transactions with the physical
>      IOMMU. But according to the above commit, on x86 a driver which
>      assumes that no-snoop DMA is compatible with uncached CPU mappings
>      will also work if the host enforces coherency.
> 
>      Although these issues are not specific to virtio-iommu, it could be
>      used to facilitate discovery and configuration of no-snoop. This
>      would require a new feature bit, PROBE property and ATTACH/MAP
>      flags.

Interpreted in the *correct* context, I do think this is objectively 
less wrong than before. We can't guarantee that the underlying 
implementation will respect cacheable mappings, but it is true that we 
can do everything in our power to ask for them.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Cc: stable@vger.kernel.org
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> Since v2 [1], I tried to refine the commit message.
> This fix is needed for v5.19 and v6.0.
> 
> I can improve the check once Robin's change [2] is merged:
> capable(IOMMU_CAP_CACHE_COHERENCY) could return dev->dma_coherent for
> case (1) above.
> 
> [1] https://lore.kernel.org/linux-iommu/20220818163801.1011548-1-jean-philippe@linaro.org/
> [2] https://lore.kernel.org/linux-iommu/d8bd8777d06929ad8f49df7fc80e1b9af32a41b5.1660574547.git.robin.murphy@arm.com/
> ---
>   drivers/iommu/virtio-iommu.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index 08eeafc9529f..80151176ba12 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -1006,7 +1006,18 @@ static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
>   	return iommu_fwspec_add_ids(dev, args->args, 1);
>   }
>   
> +static bool viommu_capable(enum iommu_cap cap)
> +{
> +	switch (cap) {
> +	case IOMMU_CAP_CACHE_COHERENCY:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>   static struct iommu_ops viommu_ops = {
> +	.capable		= viommu_capable,
>   	.domain_alloc		= viommu_domain_alloc,
>   	.probe_device		= viommu_probe_device,
>   	.probe_finalize		= viommu_probe_finalize,
