Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC82668DF95
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjBGSGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjBGSGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:06:41 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF3F35270;
        Tue,  7 Feb 2023 10:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675793200; x=1707329200;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xDjuXN0TEpLUiTCKgfDV9zMBVrWk8Dod+hRD9kikPuw=;
  b=HB80R1s7+0b7nIewlI5TrBKFWpLtL/lxOYzqDimLnH8o3pHKCJueqO2y
   95gI9vFn8L6zjFTxG0bUf/4w3lzqVbk/wC/Nokf/oaWCZeMAmlAiYWDws
   fFqMx/Vh8Sr+Kooaj4MMe8qN9nkJUmzhGPgRBwbC7OQVTq5PeZf5CR+Jv
   yX8yHQnSk60ZQCdb5lvA7ACl4Qi3KKB18RE2YWYW41YmHFWfngGgnuyk1
   Zkavo4Rs2uR3LP+oF6JuWHdqiIPYH7NKUVL8OvM8kydhcz/P45ymWIMnK
   XaBWXUe3C96TdVgoQtvM9LXuVP7PZ7D0n2bi5d4g8b7m04668iCR4Eemn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="415799742"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="415799742"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 10:05:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="790886387"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="790886387"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 10:05:41 -0800
Date:   Tue, 7 Feb 2023 10:09:18 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH] iommu/vt-d: Fix PASID directory pointer coherency
Message-ID: <20230207100918.73df2f32@jacob-builder>
In-Reply-To: <BN9PR11MB52762264B58BA63D81F50F3E8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230203220714.1283383-1-jacob.jun.pan@linux.intel.com>
        <de4d0617-ceef-efca-69f1-a095ce91588e@linux.intel.com>
        <20230206092527.670f7ef7@jacob-builder>
        <BN9PR11MB52762264B58BA63D81F50F3E8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Tue, 7 Feb 2023 00:41:16 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Tuesday, February 7, 2023 1:25 AM
> >   
> > > > @@ -1976,6 +1976,12 @@ static int  
> > domain_context_mapping_one(struct  
> > > > dmar_domain *domain, pds = context_get_sm_pds(table);
> > > >   		context->lo = (u64)virt_to_phys(table->table) |
> > > >   				context_pdts(pds);
> > > > +		/*
> > > > +		 * Scalable-mode PASID directory pointer is not
> > > > snooped if the
> > > > +		 * coherent bit is not set.
> > > > +		 */
> > > > +		if (!ecap_coherent(iommu->ecap))
> > > > +			clflush_cache_range(table->table,
> > > > sizeof(void *));  
> > >
> > > This isn't comprehensive. The clflush should be called whenever the
> > > pasid directory table is allocated or updated.
> > >  
> > allocate a pasid table does not mean it gets used by iommu hw, not
> > until it is programmed into context entry.
> >   
> 
> this is insufficient.
> 
> Even after this point the PASID directory entry could be changed when
> a new PASID table is allocated, e.g. in intel_pasid_get_entry().
> 
you are right, will include updates in v2.

Thanks,

Jacob
