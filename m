Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836E811A042
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 01:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfLKAzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 19:55:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:28187 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfLKAzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 19:55:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 16:55:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="225336040"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 10 Dec 2019 16:55:05 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <jroedel@suse.de>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH] iommu: set group default domain before creating direct
 mappings
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20191210185606.11329-1-jsnitsel@redhat.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <49bca506-1f6a-ab2d-fac0-302073737af7@linux.intel.com>
Date:   Wed, 11 Dec 2019 08:54:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191210185606.11329-1-jsnitsel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/11/19 2:56 AM, Jerry Snitselaar wrote:
> iommu_group_create_direct_mappings uses group->default_domain, but
> right after it is called, request_default_domain_for_dev calls
> iommu_domain_free for the default domain, and sets the group default
> domain to a different domain. Move the
> iommu_group_create_direct_mappings call to after the group default
> domain is set, so the direct mappings get associated with that domain.
> 
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>

This fix looks good to me.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

> Cc: iommu@lists.linux-foundation.org
> Cc: stable@vger.kernel.org
> Fixes: 7423e01741dd ("iommu: Add API to request DMA domain for device")
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> ---
>   drivers/iommu/iommu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index db7bfd4f2d20..fa908179b80b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2282,13 +2282,13 @@ request_default_domain_for_dev(struct device *dev, unsigned long type)
>   		goto out;
>   	}
>   
> -	iommu_group_create_direct_mappings(group, dev);
> -
>   	/* Make the domain the default for this group */
>   	if (group->default_domain)
>   		iommu_domain_free(group->default_domain);
>   	group->default_domain = domain;
>   
> +	iommu_group_create_direct_mappings(group, dev);
> +
>   	dev_info(dev, "Using iommu %s mapping\n",
>   		 type == IOMMU_DOMAIN_DMA ? "dma" : "direct");
>   
> 
