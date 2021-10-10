Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68088427E9C
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 05:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhJJDqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 23:46:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:35017 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhJJDqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 23:46:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10132"; a="225479696"
X-IronPort-AV: E=Sophos;i="5.85,361,1624345200"; 
   d="scan'208";a="225479696"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2021 20:44:14 -0700
X-IronPort-AV: E=Sophos;i="5.85,361,1624345200"; 
   d="scan'208";a="489979373"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2021 20:44:13 -0700
Date:   Sat, 9 Oct 2021 20:44:13 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v3 03/10] cxl/pci: Fix NULL vs ERR_PTR confusion
Message-ID: <20211010034413.GH3114988@iweiny-DESK2.sc.intel.com>
References: <163379783658.692348.16064992154261275220.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163379785305.692348.7804260538462033304.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163379785305.692348.7804260538462033304.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 09, 2021 at 09:44:13AM -0700, Dan Williams wrote:
> cxl_pci_map_regblock() may return an ERR_PTR(), but cxl_pci_setup_regs()
> is only prepared for NULL as the error case.
> 
> Fixes: f8a7e8c29be8 ("cxl/pci: Reserve all device regions at once")
> Cc: <stable@vger.kernel.org>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Cc: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index ccc7c2573ddc..9c178002d49e 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -317,7 +317,7 @@ static void __iomem *cxl_pci_map_regblock(struct cxl_mem *cxlm,
>  	if (pci_resource_len(pdev, bar) < offset) {
>  		dev_err(dev, "BAR%d: %pr: too small (offset: %#llx)\n", bar,
>  			&pdev->resource[bar], (unsigned long long)offset);
> -		return IOMEM_ERR_PTR(-ENXIO);
> +		return NULL;
>  	}
>  
>  	addr = pci_iomap(pdev, bar, 0);
> 
