Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45F964F09A
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 18:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiLPRsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 12:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiLPRsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 12:48:18 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ABCFCD0;
        Fri, 16 Dec 2022 09:48:16 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-142b72a728fso4148469fac.9;
        Fri, 16 Dec 2022 09:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=do3Z4/hAMQVkQodUCOYB/hJ2aATCK/w0rFJKLIUXoDU=;
        b=Tq0ybDf8GqL94RsKaMSNjCFFt5GLpFfZThhTwrf6hKpyQlLPIzpcZT9zfuXr+StWkL
         Vt6dYgvsxaMUdOXNJdHGEPTtPkUd/F6Ezpfs55HHBqe6FohLDRKVS8In3+K/GmXNeICA
         1su8JnGtvq6A6GHi1AcX2vRDU4lEHKArVskSaFvF8bcs5p1//S0YkutfA3H1b9N9Sr0a
         jU3ojtTFoVkCVOOFkHW98RWK8Wjl0wUNi8LbUxRfvsWwqTtj2RoGmk8O6uwSarllp6ai
         saUk+FkRz+7DZvJ+EGoGf0wWhXrIgfQjMDN5RRKLVj3/Px/Uvyn7uWMrKl9ip8smxIsm
         Xz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=do3Z4/hAMQVkQodUCOYB/hJ2aATCK/w0rFJKLIUXoDU=;
        b=G2Ac0RVK1Kia2e8i9e0RNWNu2B5HjmJ0uOVx57o2e5rHOVvw8Bafu+VgTZemlLUp+i
         h0WomnsvPSIwzUaYh/sseCkV7Ow+7yFSIATK1XlOpYJPD9WoIn5HROT01xn53GDVq3Pk
         zNZsVIx48s3zv+Vr6SJdOaiIcAiog45HVfYs0fcHL72prKnkGpZZhSj+8yZtmE51oosx
         sZPjNyosVSAbzva55tvlC+rWXN6wNyCqzfsGEiV56T+E7R9NNmxXITeOvz0haCMqvoCh
         XuXGiLIUzef1qI19YQ9D5+hUb5Ju6JDx0LQl9wWbzD7wAOG3T+8g9lvricKeu64fdT5E
         vNXQ==
X-Gm-Message-State: AFqh2koywZiYKQC/wfZMbIOvABia4dRzOUqHBrs0X1hkKHX3xU0+WpO9
        9wVZEfuYe9jEdgUMOYcQuvT4iESdcA6ASy390c8=
X-Google-Smtp-Source: AMrXdXvuc6R3ZTZ/oApoLGblrEpZbywtPib18Mzb9sA9w3nnKcRlXNSTHdHBj3oZ6tMkGGF1L+PuoYv9ctA0jAAKtos=
X-Received: by 2002:a05:6870:8091:b0:148:3c8f:15ab with SMTP id
 q17-20020a056870809100b001483c8f15abmr748017oab.46.1671212895993; Fri, 16 Dec
 2022 09:48:15 -0800 (PST)
MIME-Version: 1.0
References: <651349f55060767a9a51316c966c1e5daa57a644.1670919979.git.Rijo-john.Thomas@amd.com>
 <20221215132917.GA11061@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20221215132917.GA11061@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 16 Dec 2022 12:48:03 -0500
Message-ID: <CADnq5_Nd6bzgqTBKwG=zZr2YO60SL92xiE1MzH-c1MfkFKqzqQ@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        John Allen <john.allen@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linaro-mm-sig@lists.linaro.org,
        Jens Wiklander <jens.wiklander@linaro.org>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 3:20 AM Jeremi Piotrowski
<jpiotrowski@linux.microsoft.com> wrote:
>
> On Tue, Dec 13, 2022 at 04:40:27PM +0530, Rijo Thomas wrote:
> > For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
> > ring buffer address sent by host to ASP must be a real physical
> > address and the pages must be physically contiguous.
> >
> > In a virtualized environment though, when the driver is running in a
> > guest VM, the pages allocated by __get_free_pages() may not be
> > contiguous in the host (or machine) physical address space. Guests
> > will see a guest (or pseudo) physical address and not the actual host
> > (or machine) physical address. The TEE running on ASP cannot decipher
> > pseudo physical addresses. It needs host or machine physical address.
> >
> > To resolve this problem, use DMA APIs for allocating buffers that must
> > be shared with TEE. This will ensure that the pages are contiguous in
> > host (or machine) address space. If the DMA handle is an IOVA,
> > translate it into a physical address before sending it to ASP.
> >
> > This patch also exports two APIs (one for buffer allocation and
> > another to free the buffer). This API can be used by AMD-TEE driver to
> > share buffers with TEE.
> >
> > Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> > Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
> > Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
> > Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> > ---
> > v2:
> >  * Removed references to dma_buffer.
> >  * If psp_init() fails, clear reference to master device.
> >  * Handle gfp flags within psp_tee_alloc_buffer() instead of passing it as
> >    a function argument.
> >  * Added comments within psp_tee_alloc_buffer() to serve as future
> >    documentation.
> >
> >  drivers/crypto/ccp/psp-dev.c |  13 ++--
> >  drivers/crypto/ccp/tee-dev.c | 124 +++++++++++++++++++++++------------
> >  drivers/crypto/ccp/tee-dev.h |   9 +--
> >  include/linux/psp-tee.h      |  49 ++++++++++++++
> >  4 files changed, 142 insertions(+), 53 deletions(-)
> >
> > diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> > index c9c741ac8442..380f5caaa550 100644
> > --- a/drivers/crypto/ccp/psp-dev.c
> > +++ b/drivers/crypto/ccp/psp-dev.c
> > @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
> >               goto e_err;
> >       }
> >
> > -     ret = psp_init(psp);
> > -     if (ret)
> > -             goto e_irq;
> > -
> >       if (sp->set_psp_master_device)
> >               sp->set_psp_master_device(sp);
> >
> > +     ret = psp_init(psp);
> > +     if (ret)
> > +             goto e_clear;
> > +
> >       /* Enable interrupt */
> >       iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
> >
> > @@ -175,7 +175,10 @@ int psp_dev_init(struct sp_device *sp)
> >
> >       return 0;
> >
> > -e_irq:
> > +e_clear:
> > +     if (sp->clear_psp_master_device)
> > +             sp->clear_psp_master_device(sp);
> > +
> >       sp_free_psp_irq(psp->sp, psp);
> >  e_err:
> >       sp->psp_data = NULL;
> > diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> > index 5c9d47f3be37..5c43e6e166f1 100644
> > --- a/drivers/crypto/ccp/tee-dev.c
> > +++ b/drivers/crypto/ccp/tee-dev.c
> > @@ -12,8 +12,9 @@
> >  #include <linux/mutex.h>
> >  #include <linux/delay.h>
> >  #include <linux/slab.h>
> > +#include <linux/dma-direct.h>
> > +#include <linux/iommu.h>
> >  #include <linux/gfp.h>
> > -#include <linux/psp-sev.h>
> >  #include <linux/psp-tee.h>
> >
> >  #include "psp-dev.h"
> > @@ -21,25 +22,73 @@
> >
> >  static bool psp_dead;
> >
> > +struct psp_tee_buffer *psp_tee_alloc_buffer(unsigned long size)
> > +{
> > +     struct psp_device *psp = psp_get_master_device();
> > +     struct psp_tee_buffer *buf;
> > +     struct iommu_domain *dom;
> > +
> > +     if (!psp || !size)
> > +             return NULL;
> > +
> > +     buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> > +     if (!buf)
> > +             return NULL;
> > +
> > +     /* The pages allocated for PSP Trusted OS must be physically
> > +      * contiguous in host (or machine) address space. Therefore,
> > +      * use DMA API to allocate memory.
> > +      */
> > +
> > +     buf->vaddr = dma_alloc_coherent(psp->dev, size, &buf->dma,
> > +                                     GFP_KERNEL | __GFP_ZERO);
>
> dma_alloc_coherent memory is just as contiguous as __get_free_pages, and
> calling dma_alloc_coherent from a guest does not guarantee that the memory is
> contiguous in host memory either. The memory would look contiguous from the
> device point of view thanks to the IOMMU though (in both cases). So this is not
> about being contiguous but other properties that you might rely on (dma mask
> most likely, or coherent if you're not running this on x86?).
>
> Can you confirm why this fixes things and update the comment to reflect that.
>
> > +     if (!buf->vaddr || !buf->dma) {
> > +             kfree(buf);
> > +             return NULL;
> > +     }
> > +
> > +     buf->size = size;
> > +
> > +     /* Check whether IOMMU is present. If present, convert IOVA to
> > +      * physical address. In the absence of IOMMU, the DMA address
> > +      * is actually the physical address.
> > +      */
> > +
> > +     dom = iommu_get_domain_for_dev(psp->dev);
> > +     if (dom)
> > +             buf->paddr = iommu_iova_to_phys(dom, buf->dma);
> > +     else
> > +             buf->paddr = buf->dma;
>
> This is confusing: you're storing GPA for the guest and HPA in case of the
> host, to pass to the device. Let's talk about the host case.
>
> a) the device is behind an IOMMU. The DMA API gives you an IOVA, and the device
> should be using the IOVA to access memory (because it's behind an IOMMU).
> b) the device is not behind an IOMMU. The DMA API gives you a PA, the device
> uses a PA.
>
> But in case a) you're extracting the PA, which means your device can bypass the
> IOMMU, in which case the system should not think that it is behind an IOMMU. So
> how does this work?

IIRC, as per the AMD IOMMU spec[1], there is an ACPI IVRS table which
details the devices on the platform and whether or not they
participate with IOMMU.  This should carry through to the DMA API.  If
the ACPI tables do not reflect this correctly we should add a quirk to
the AMD IOMMU to properly handle the device.

Alex

[1] - https://www.amd.com/en/support/tech-docs/amd-io-virtualization-technology-iommu-specification

Alex

>
> Jeremi
>
> > +
> > +     return buf;
> > +}
> > +EXPORT_SYMBOL(psp_tee_alloc_buffer);
> > +
>
