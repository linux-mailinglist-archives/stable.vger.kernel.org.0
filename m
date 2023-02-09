Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D71690ED0
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 18:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjBIRDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 12:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBIRDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 12:03:51 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2672C2D67;
        Thu,  9 Feb 2023 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675962231; x=1707498231;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h7haSo2PuF074xBqzWO5BEhw94RzyZrripHwKnABad4=;
  b=ZdrhEP8ksWGpFyFx6JC364CapZ0Nr3Y6Ess//KyzKUpavtbBr2f9DBBx
   btlT+x6wmJNIHBqDdvJhXJUp1PVWm3fs0ln0eSuxogSf1VES2YfVsMDbR
   plzGxV1xjb34SIhC05qOx1cL+pKM/lSWei0+Z76Xgyd4rseWGmgDePrC8
   0W7oPczuq/ySoe4vnbW7XF/1eWaGl+DDqjqfqauWnbCqx1JH6shZ0UeIj
   vJ4Rv+58BZK/lW7Zd8bwSpu9WTGU9Gjl+BP93rtnf/5uCZRZoNsWquRbW
   sCl+gkD7SKjtqIek6HnnMga9VOEvplZEo+apO4TB8MiyTIuh/HhryUHkW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="327857627"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="327857627"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:02:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="841718905"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="841718905"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:02:26 -0800
Date:   Thu, 9 Feb 2023 09:06:03 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Message-ID: <20230209090603.37854cb9@jacob-builder>
In-Reply-To: <BN9PR11MB52760B2BBE25C23EE445B2C58CD99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230208171902.1580104-1-jacob.jun.pan@linux.intel.com>
        <BN9PR11MB52760B2BBE25C23EE445B2C58CD99@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Thu, 9 Feb 2023 02:08:23 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > @@ -1976,6 +1976,8 @@ static int domain_context_mapping_one(struct
> > dmar_domain *domain,
> >  		pds = context_get_sm_pds(table);
> >  		context->lo = (u64)virt_to_phys(table->table) |
> >  				context_pdts(pds);
> > +		if (!ecap_coherent(iommu->ecap))
> > +			clflush_cache_range(table->table,
> > sizeof(u64));  
> 
> this is not required if cache is already flushed when the table is
> allocated.
yes you're right.

Thanks,

Jacob
