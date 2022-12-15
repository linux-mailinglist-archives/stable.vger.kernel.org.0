Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53ADC64DC41
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 14:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLON3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 08:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLON3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 08:29:19 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A36518B1C;
        Thu, 15 Dec 2022 05:29:18 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id 0309520B92BA; Thu, 15 Dec 2022 05:29:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0309520B92BA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1671110958;
        bh=7vCuNFrK1OQpeQJVAk4kMKTCnLpf775i8aOo4DRS+9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QZnI/IyyKwaP/zHzNYXBCCMLXwZ6fWvbR3+FSmMN8vXx7vDA9nqW6jBuCd94pC8h5
         AxMEb0GPQZDrKvtVpzQGSdOOMd57S+oHh7VfYSpHkUuhy2Pznc/RAL9npCWFUU+YVH
         Zwan7XglTQRg5zjvabjEK8IJ+GIpzc9ooNPxTQRI=
Date:   Thu, 15 Dec 2022 05:29:17 -0800
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH v2] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
Message-ID: <20221215132917.GA11061@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <651349f55060767a9a51316c966c1e5daa57a644.1670919979.git.Rijo-john.Thomas@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <651349f55060767a9a51316c966c1e5daa57a644.1670919979.git.Rijo-john.Thomas@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 04:40:27PM +0530, Rijo Thomas wrote:
> For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
> ring buffer address sent by host to ASP must be a real physical
> address and the pages must be physically contiguous.
> 
> In a virtualized environment though, when the driver is running in a
> guest VM, the pages allocated by __get_free_pages() may not be
> contiguous in the host (or machine) physical address space. Guests
> will see a guest (or pseudo) physical address and not the actual host
> (or machine) physical address. The TEE running on ASP cannot decipher
> pseudo physical addresses. It needs host or machine physical address.
> 
> To resolve this problem, use DMA APIs for allocating buffers that must
> be shared with TEE. This will ensure that the pages are contiguous in
> host (or machine) address space. If the DMA handle is an IOVA,
> translate it into a physical address before sending it to ASP.
> 
> This patch also exports two APIs (one for buffer allocation and
> another to free the buffer). This API can be used by AMD-TEE driver to
> share buffers with TEE.
> 
> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
> Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
> Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> ---
> v2:
>  * Removed references to dma_buffer.
>  * If psp_init() fails, clear reference to master device.
>  * Handle gfp flags within psp_tee_alloc_buffer() instead of passing it as
>    a function argument.
>  * Added comments within psp_tee_alloc_buffer() to serve as future
>    documentation.
> 
>  drivers/crypto/ccp/psp-dev.c |  13 ++--
>  drivers/crypto/ccp/tee-dev.c | 124 +++++++++++++++++++++++------------
>  drivers/crypto/ccp/tee-dev.h |   9 +--
>  include/linux/psp-tee.h      |  49 ++++++++++++++
>  4 files changed, 142 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index c9c741ac8442..380f5caaa550 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
>  		goto e_err;
>  	}
> 
> -	ret = psp_init(psp);
> -	if (ret)
> -		goto e_irq;
> -
>  	if (sp->set_psp_master_device)
>  		sp->set_psp_master_device(sp);
> 
> +	ret = psp_init(psp);
> +	if (ret)
> +		goto e_clear;
> +
>  	/* Enable interrupt */
>  	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
> 
> @@ -175,7 +175,10 @@ int psp_dev_init(struct sp_device *sp)
> 
>  	return 0;
> 
> -e_irq:
> +e_clear:
> +	if (sp->clear_psp_master_device)
> +		sp->clear_psp_master_device(sp);
> +
>  	sp_free_psp_irq(psp->sp, psp);
>  e_err:
>  	sp->psp_data = NULL;
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 5c9d47f3be37..5c43e6e166f1 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -12,8 +12,9 @@
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/dma-direct.h>
> +#include <linux/iommu.h>
>  #include <linux/gfp.h>
> -#include <linux/psp-sev.h>
>  #include <linux/psp-tee.h>
> 
>  #include "psp-dev.h"
> @@ -21,25 +22,73 @@
> 
>  static bool psp_dead;
> 
> +struct psp_tee_buffer *psp_tee_alloc_buffer(unsigned long size)
> +{
> +	struct psp_device *psp = psp_get_master_device();
> +	struct psp_tee_buffer *buf;
> +	struct iommu_domain *dom;
> +
> +	if (!psp || !size)
> +		return NULL;
> +
> +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> +	if (!buf)
> +		return NULL;
> +
> +	/* The pages allocated for PSP Trusted OS must be physically
> +	 * contiguous in host (or machine) address space. Therefore,
> +	 * use DMA API to allocate memory.
> +	 */
> +
> +	buf->vaddr = dma_alloc_coherent(psp->dev, size, &buf->dma,
> +					GFP_KERNEL | __GFP_ZERO);

dma_alloc_coherent memory is just as contiguous as __get_free_pages, and
calling dma_alloc_coherent from a guest does not guarantee that the memory is
contiguous in host memory either. The memory would look contiguous from the
device point of view thanks to the IOMMU though (in both cases). So this is not
about being contiguous but other properties that you might rely on (dma mask
most likely, or coherent if you're not running this on x86?).

Can you confirm why this fixes things and update the comment to reflect that.

> +	if (!buf->vaddr || !buf->dma) {
> +		kfree(buf);
> +		return NULL;
> +	}
> +
> +	buf->size = size;
> +
> +	/* Check whether IOMMU is present. If present, convert IOVA to
> +	 * physical address. In the absence of IOMMU, the DMA address
> +	 * is actually the physical address.
> +	 */
> +
> +	dom = iommu_get_domain_for_dev(psp->dev);
> +	if (dom)
> +		buf->paddr = iommu_iova_to_phys(dom, buf->dma);
> +	else
> +		buf->paddr = buf->dma;

This is confusing: you're storing GPA for the guest and HPA in case of the
host, to pass to the device. Let's talk about the host case.

a) the device is behind an IOMMU. The DMA API gives you an IOVA, and the device
should be using the IOVA to access memory (because it's behind an IOMMU).
b) the device is not behind an IOMMU. The DMA API gives you a PA, the device
uses a PA.

But in case a) you're extracting the PA, which means your device can bypass the
IOMMU, in which case the system should not think that it is behind an IOMMU. So
how does this work?

Jeremi

> +
> +	return buf;
> +}
> +EXPORT_SYMBOL(psp_tee_alloc_buffer);
> +

