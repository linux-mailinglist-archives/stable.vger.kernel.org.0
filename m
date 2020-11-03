Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A532A4638
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgKCNYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729226AbgKCNYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:24:03 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC558C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 05:24:02 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 3339C3A5; Tue,  3 Nov 2020 14:24:00 +0100 (CET)
Date:   Tue, 3 Nov 2020 14:23:58 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu: Fix deferred domain attachment in
 iommu_probe_device()
Message-ID: <20201103132358.GG22888@8bytes.org>
References: <20201026063008.24849-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026063008.24849-1-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Baolu,

On Mon, Oct 26, 2020 at 02:30:08PM +0800, Lu Baolu wrote:
> @@ -264,7 +266,8 @@ int iommu_probe_device(struct device *dev)
>  	 */
>  	iommu_alloc_default_domain(group, dev);
>  
> -	if (group->default_domain)
> +	if (group->default_domain &&
> +	    !iommu_is_attach_deferred(group->default_domain, dev))
>  		ret = __iommu_attach_device(group->default_domain, dev);

This is the hotplug path, not used for boot-initialization. Have you
seen failures from the missing check here?

Regards,

	Joerg
