Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCB368C478
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 18:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBFRVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 12:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjBFRVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 12:21:53 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB4659D2;
        Mon,  6 Feb 2023 09:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675704112; x=1707240112;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0gctpzQ14E7N77mb7AzU/PZrWJdp1++fnSUrFflVR3Y=;
  b=Fjmo0+gO5qSn+x/qTd1qKgy4VKBhKCJtHPNaTlJN/rUAHDGn9tQilD6x
   6oZrLxvtKrB5mpLzNndvznRUF2p62fMKwrzObvZm7F/eCoQSSjbCtquBD
   5w/tSaiV6Ds+lJaoFCMzz/9GV6+cFPzE/VtE67eHWTLMdHS7/+kDyQBP2
   CujguBYAE4QVo5o7IrYJMMWf+A44/gHFRIi0RAni4BCpVPMLoGqTV4ZL3
   VBoFy4PHnd1KrsP2s40QUGKNqxRGgbyGeB/z5G3/e+3EYZP2HZCzJXsAt
   l5O8vg7V5Z4kZnko6JajZDTDYCsf/ZWhD84PXsRV+tw/stsoh5znOa0HG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="327895054"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="327895054"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 09:21:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="696912022"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="696912022"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 09:21:51 -0800
Date:   Mon, 6 Feb 2023 09:25:27 -0800
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
Message-ID: <20230206092527.670f7ef7@jacob-builder>
In-Reply-To: <de4d0617-ceef-efca-69f1-a095ce91588e@linux.intel.com>
References: <20230203220714.1283383-1-jacob.jun.pan@linux.intel.com>
        <de4d0617-ceef-efca-69f1-a095ce91588e@linux.intel.com>
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

On Sat, 4 Feb 2023 11:43:01 +0800, Baolu Lu <baolu.lu@linux.intel.com>
wrote:

> On 2023/2/4 6:07, Jacob Pan wrote:
> > On platforms that do not support IOMMU Extended capability bit 0
> > Page-walk Coherency, CPU caches are not snooped when IOMMU is accessing
> > any translation structures. IOMMU access goes only directly to
> > memory. Intel IOMMU code was missing a flush for the PASID table
> > directory that resulted in the unrecoverable fault as shown below.  
> 
> Thanks for the fix.
> 
> > This patch adds a clflush when activating a PASID table directory.
> > There's no need to do clflush of the PASID directory pointer when we
> > deactivate a context entry in that IOMMU hardware will not see the old
> > PASID directory pointer after we clear the context entry.
> > 
> > [    0.555386] DMAR: DRHD: handling fault status reg 3
> > [    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault
> > addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry
> > is clear [    0.556348] DMAR: Dump dmar1 table entries for IOVA
> > 0x1026a4000 [    0.556348] DMAR: scalable mode root entry: hi
> > 0x0000000102448001, low 0x0000000101b3e001 [    0.556348] DMAR: context
> > entry: hi 0x0000000000000000, low 0x0000000101b4d401 [    0.556348]
> > DMAR: pasid dir entry: 0x0000000101b4e001 [    0.556348] DMAR: pasid
> > table entry[0]: 0x0000000000000109 [    0.556348] DMAR: pasid table
> > entry[1]: 0x0000000000000001 [    0.556348] DMAR: pasid table entry[2]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[3]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[4]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[5]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[6]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[7]:
> > 0x0000000000000000 [    0.556348] DMAR: PTE not present at level 4
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
> > Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>  
> 
> Add a Fixes tag so that people know how far this fix should be back
> ported.
> 
will do.
> > ---
> >   drivers/iommu/intel/iommu.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> > index 59df7e42fd53..b4878c7ac008 100644
> > --- a/drivers/iommu/intel/iommu.c
> > +++ b/drivers/iommu/intel/iommu.c
> > @@ -1976,6 +1976,12 @@ static int domain_context_mapping_one(struct
> > dmar_domain *domain, pds = context_get_sm_pds(table);
> >   		context->lo = (u64)virt_to_phys(table->table) |
> >   				context_pdts(pds);
> > +		/*
> > +		 * Scalable-mode PASID directory pointer is not
> > snooped if the
> > +		 * coherent bit is not set.
> > +		 */
> > +		if (!ecap_coherent(iommu->ecap))
> > +			clflush_cache_range(table->table, sizeof(void
> > *));  
> 
> This isn't comprehensive. The clflush should be called whenever the
> pasid directory table is allocated or updated.
> 
allocate a pasid table does not mean it gets used by iommu hw, not until it
is programmed into context entry.

> >   
> >   		/* Setup the RID_PASID field: */
> >   		context_set_sm_rid2pasid(context, PASID_RID2PASID);  
> 
> Best regards,
> baolu
> 


Thanks,

Jacob
