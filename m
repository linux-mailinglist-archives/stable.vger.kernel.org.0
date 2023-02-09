Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D739690F5B
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 18:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjBIRjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 12:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIRjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 12:39:54 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7175B744;
        Thu,  9 Feb 2023 09:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675964393; x=1707500393;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+cpCRNK3m2eAdE04EZsrrPRCT4Hr8oF27Jp5Ga1PTms=;
  b=nPSGjB0BxA1HKgLlSF0Xzm7P6994YEs6mMt5OleTOVV+anL0HDsL5065
   I21yqKgAetu/AIilSuUpCAxiZHiD0290N3jsPBLIpShNWyn0tPoNV9Sgf
   973zRczxu9/H71I/imIKbgKT6E1B+kVB2IOOO7i7gD8+AISw8cbvhIRxS
   jGPfjApb5ugT7n7FoB4Honxq8qkubtRoTIRacfcZrDD9a6qUnh0166pkf
   3GbCJIqko4RkBrliVubBC/4SSa7A5aX3ctCWlNfVnas+veVwluosRSNCF
   sOxt3dLZRxTNm7Ewei8XmJ0PPQIfCE6VIG//O+6AwXTSad40OKgXt9MYs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="328821815"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="328821815"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:39:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="736439370"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="736439370"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:39:52 -0800
Date:   Thu, 9 Feb 2023 09:43:30 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy
 mode
Message-ID: <20230209094330.12a94139@jacob-builder>
In-Reply-To: <BN9PR11MB5276A911FAAE4C2F6B670E638CD99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230208181834.1601211-1-jacob.jun.pan@linux.intel.com>
        <BN9PR11MB5276A911FAAE4C2F6B670E638CD99@BN9PR11MB5276.namprd11.prod.outlook.com>
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

Hi Kevin,

On Thu, 9 Feb 2023 02:09:47 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Thursday, February 9, 2023 2:19 AM
> > 
> > -	iommu_iotlb_gather_add_page(domain, gather, iova, size);
> > +	/*
> > +	 * We do not use page-selective IOTLB invalidation in flush
> > queue,
> > +	 * There is no need to track page and sync iotlb.
> > Domain-selective or  
> 
> "in flush queue, so there is ..."
> 
> > +	 * PASID-selective validation are used in the flush queue.  
> 
> the last sentence can be removed. same meaning as the first one.
> 
sounds good.
> > +	 */
> > +	if (!iommu_iotlb_gather_queued(gather))
> > +		iommu_iotlb_gather_add_page(domain, gather, iova,
> > size); 
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 


Thanks,

Jacob
