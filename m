Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACDE1F5115
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 11:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgFJJ1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 05:27:21 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:41569 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgFJJ1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 05:27:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591781240; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=IpS6LvB59AAFg+uXb9gY9Ph2ttT1iEsbG4T4LlRTt9U=;
 b=kKSw18rz4ubY86WDvszvf/70ghZChHiYh5hu9dsgP9mLjmFf/BMqE6Yt5Vba/2yaSuvkLmgQ
 AWZYgeD5hsb2qMDIP48HwlK6ytJGv3ufCJfjLwN/koLwXFkWEGtkusFVxHo/Bodju5GGB8Rn
 GoU0aOtbUVvwJKTsi/M2nXnZcJo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5ee0a7656f2ee827dafa4724 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Jun 2020 09:27:01
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6966EC433C6; Wed, 10 Jun 2020 09:27:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: guptap)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DD3D8C433CA;
        Wed, 10 Jun 2020 09:27:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Jun 2020 14:57:00 +0530
From:   guptap@codeaurora.org
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     joro@8bytes.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/iova: Don't BUG on invalid PFNs
In-Reply-To: <acbd2d092b42738a03a21b417ce64e27f8c91c86.1591103298.git.robin.murphy@arm.com>
References: <acbd2d092b42738a03a21b417ce64e27f8c91c86.1591103298.git.robin.murphy@arm.com>
Message-ID: <79df62c92cf61f2b5f717c28d620a283@codeaurora.org>
X-Sender: guptap@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-02 18:38, Robin Murphy wrote:
> Unlike the other instances which represent a complete loss of
> consistency within the rcache mechanism itself, or a fundamental
> and obvious misconfiguration by an IOMMU driver, the BUG_ON() in
> iova_magazine_free_pfns() can be provoked at more or less any time
> in a "spooky action-at-a-distance" manner by any old device driver
> passing nonsense to dma_unmap_*() which then propagates through to
> queue_iova().
> 
> Not only is this well outside the IOVA layer's control, it's also
> nowhere near fatal enough to justify panicking anyway - all that
> really achieves is to make debugging the offending driver more
> difficult. Let's simply WARN and otherwise ignore bogus PFNs.
> 
> Reported-by: Prakash Gupta <guptap@codeaurora.org>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  drivers/iommu/iova.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Copying stable@vger.kernel.org

You can add
Reviewed-by: Prakash Gupta <guptap@codeaurora.org>

> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index 0e6a9536eca6..612cbf668adf 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -811,7 +811,9 @@ iova_magazine_free_pfns(struct iova_magazine *mag,
> struct iova_domain *iovad)
>  	for (i = 0 ; i < mag->size; ++i) {
>  		struct iova *iova = private_find_iova(iovad, mag->pfns[i]);
> 
> -		BUG_ON(!iova);
> +		if (WARN_ON(!iova))
> +			continue;
> +
>  		private_free_iova(iovad, iova);
>  	}
