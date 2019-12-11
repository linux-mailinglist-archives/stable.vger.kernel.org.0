Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB81311B8EA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfLKQfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:35:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52247 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729858AbfLKQfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576082137;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=G2ZB3omzRfSfFMjDrR0LBqamRCs0vWgnzAtR96DPAFU=;
        b=TBZmtIH8PN8dWdMGlZxjiDmI9JZx/31WBjsVncYt2fLHWhEEOCaPzzEfsnDqKubXVrCWBn
        wOWmrhwOmN1FDQZLsXpAa55dm9KHfRHQReVOQwoq/UtAQLIjycdCiHHW5gOBr6I7CYCbO5
        djJIYcQzl86cmCB/h/ZFHMj2lft6Fjw=
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-YEjQQ2KPMq-LnvxTOsV9eA-1; Wed, 11 Dec 2019 11:35:35 -0500
X-MC-Unique: YEjQQ2KPMq-LnvxTOsV9eA-1
Received: by mail-yw1-f69.google.com with SMTP id z22so2893943ywd.21
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 08:35:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=G2ZB3omzRfSfFMjDrR0LBqamRCs0vWgnzAtR96DPAFU=;
        b=K1c8l1TSYcm+wEwYW5Ysk79KGf80Vlgm1mGyXV63yYN3nDGLtH5zS4tlKQgBjn4pgj
         +5nJfP2em5Bnwbg0eq26qK6/D8oWRDe8UJVXBm2vrjRyEuQVVvmTlr4cgeFt1CgtDNSe
         u9d1N79zeeTCvjCLiRAqHsJ2KVD1L+edMPJk/QGaAZI9/GYBDB9MxphbrxkJYn7uTyR+
         +Gh1oywi9+Kl/nSthla3i+N2vQMCo71Tbe30OgLfo6pMI1Lbza27aR8gJQ5LcU6fTeVG
         V5lcR33LdvCx3wSyKsc2g1aDzP+drmZwuH2c2HH+X130lR19eQbHcPb3SSy4HUvEXGoS
         1lAw==
X-Gm-Message-State: APjAAAWGGDDLHMonXccRLooJU/dD6Jl/5cwHKf5YyhJ5WJE1OrGbodAX
        hmqzDhohswHqJ/k8BYbDo9akTE1DpgtIIzAr9h2SFbXplDq4UFkzuQPMO/7Dtd9LEfZzeRPuZtl
        sdx4Rk18+wsig1571
X-Received: by 2002:a81:de03:: with SMTP id k3mr496986ywj.504.1576082135412;
        Wed, 11 Dec 2019 08:35:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQSheQ86BeD+t6fYx16LhovjTZbO/zkP9rZdQVuw6RgshPVg8mCAb+RC0yN7OH2NIGsZ9xUg==
X-Received: by 2002:a81:de03:: with SMTP id k3mr496966ywj.504.1576082135136;
        Wed, 11 Dec 2019 08:35:35 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id l74sm1168529ywc.45.2019.12.11.08.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 08:35:34 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:35:11 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix dmar pte read access not set error
Message-ID: <20191211163511.gjju2s3yy4sus44w@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191211014015.7898-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20191211014015.7898-1-baolu.lu@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed Dec 11 19, Lu Baolu wrote:
>If the default DMA domain of a group doesn't fit a device, it
>will still sit in the group but use a private identity domain.
>When map/unmap/iova_to_phys come through iommu API, the driver
>should still serve them, otherwise, other devices in the same
>group will be impacted. Since identity domain has been mapped
>with the whole available memory space and RMRRs, we don't need
>to worry about the impact on it.
>

Does this pose any potential issues with the reverse case where the
group has a default identity domain, and the first device fits that,
but a later device in the group needs dma and gets a private dma
domain?

>Link: https://www.spinics.net/lists/iommu/msg40416.html
>Cc: Jerry Snitselaar <jsnitsel@redhat.com>
>Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
>Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains replaced with private")
>Cc: stable@vger.kernel.org # v5.3+
>Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>---
> drivers/iommu/intel-iommu.c | 8 --------
> 1 file changed, 8 deletions(-)
>
>diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>index 0c8d81f56a30..b73bebea9148 100644
>--- a/drivers/iommu/intel-iommu.c
>+++ b/drivers/iommu/intel-iommu.c
>@@ -5478,9 +5478,6 @@ static int intel_iommu_map(struct iommu_domain *domain,
> 	int prot = 0;
> 	int ret;
>
>-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>-		return -EINVAL;
>-
> 	if (iommu_prot & IOMMU_READ)
> 		prot |= DMA_PTE_READ;
> 	if (iommu_prot & IOMMU_WRITE)
>@@ -5523,8 +5520,6 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
> 	/* Cope with horrid API which requires us to unmap more than the
> 	   size argument if it happens to be a large-page mapping. */
> 	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level));
>-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>-		return 0;
>
> 	if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
> 		size = VTD_PAGE_SIZE << level_to_offset_bits(level);
>@@ -5556,9 +5551,6 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
> 	int level = 0;
> 	u64 phys = 0;
>
>-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>-		return 0;
>-
> 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
> 	if (pte)
> 		phys = dma_pte_addr(pte);
>-- 
>2.17.1
>

