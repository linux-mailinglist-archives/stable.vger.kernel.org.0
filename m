Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7195268DF91
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjBGSFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjBGSFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:05:23 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B53137577;
        Tue,  7 Feb 2023 10:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675793122; x=1707329122;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ANDeNRsZmH3w3WfIltlmOn5XAx/Tp1OF+vVUO9znJlw=;
  b=N+ofJOBlI2hW+zuYMlMiaA0eb6FXO/Au5KHMYJM7LvpnqeEmUszMdxKh
   xDiZIycJoVwsI9z52fZ2lSFPuHKX2VAwJJqG98HPcgOQx0BFadEvMzgKK
   W1BBMUWOMWl8GM2sSpKHuITdBIubb3PFaDsmrxdKDDxZIYfNl32rnONjq
   tpJT66vxaqtcbmDgrrpN1+lke0u7bowIRcwu5Xo1TDKgKDCynWoKyVIUO
   jesP4PRIN/A4Ua9RdqG8+y9x9OIKV13sn15IdCl9RtX130a29r+rBrxTV
   oe5XEfPRpCzmtYsFtcg63yrt1sIoac7Hguvt1mnrDJcPrle+NnALqQVXc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="415799206"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="415799206"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 10:04:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="995826311"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="995826311"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 10:04:58 -0800
Date:   Tue, 7 Feb 2023 10:08:35 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        stable@vger.kernel.org, Sukumar Ghorai <sukumar.ghorai@intel.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH] iommu/vt-d: Fix PASID directory pointer coherency
Message-ID: <20230207100835.2dd3cb3b@jacob-builder>
In-Reply-To: <4a22577b-2bbc-d731-95e1-aee95d4a8c8e@linux.intel.com>
References: <20230203220714.1283383-1-jacob.jun.pan@linux.intel.com>
        <de4d0617-ceef-efca-69f1-a095ce91588e@linux.intel.com>
        <20230206092527.670f7ef7@jacob-builder>
        <4a22577b-2bbc-d731-95e1-aee95d4a8c8e@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Baolu,

On Tue, 7 Feb 2023 15:10:48 +0800, Baolu Lu <baolu.lu@linux.intel.com>
wrote:

> On 2023/2/7 1:25, Jacob Pan wrote:
> >>> ---
> >>>    drivers/iommu/intel/iommu.c | 6 ++++++
> >>>    1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> >>> index 59df7e42fd53..b4878c7ac008 100644
> >>> --- a/drivers/iommu/intel/iommu.c
> >>> +++ b/drivers/iommu/intel/iommu.c
> >>> @@ -1976,6 +1976,12 @@ static int domain_context_mapping_one(struct
> >>> dmar_domain *domain, pds = context_get_sm_pds(table);
> >>>    		context->lo = (u64)virt_to_phys(table->table) |
> >>>    				context_pdts(pds);
> >>> +		/*
> >>> +		 * Scalable-mode PASID directory pointer is not
> >>> snooped if the
> >>> +		 * coherent bit is not set.
> >>> +		 */
> >>> +		if (!ecap_coherent(iommu->ecap))
> >>> +			clflush_cache_range(table->table, sizeof(void
> >>> *));  
> >> This isn't comprehensive. The clflush should be called whenever the
> >> pasid directory table is allocated or updated.
> >>  
> > allocate a pasid table does not mean it gets used by iommu hw, not
> > until it is programmed into context entry.  
> 
> Hi Jacob,
> 
> This page is used by the device, and the device's access to this memory
> is not coherent. So after the page is allocated, any changes made by the
> CPU to this page must be written back to the real memory.
> 
> This patch only flushes the first 8 bytes of the table. That's not
> enough.
> 
make sense, thanks for the explanation.
> Be aware that page allocation also requires a clflush, because at least
> __GFP_ ZERO implies modification to page.
> 
Yes, zeroing dir page does change it but I think if we intercept every
update to the directory entry, it should be sufficient?

will send an updated version.


Thanks,

Jacob
