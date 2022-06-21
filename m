Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7A35529C7
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 05:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiFUDj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 23:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiFUDj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 23:39:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5F46259;
        Mon, 20 Jun 2022 20:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655782766; x=1687318766;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qVX3BzEHCS59pOvp34Vx2zJmoCdlA/L6qhq0aL8cy4M=;
  b=D/rn7iGiG02CfCxNBnOZqS79idGwoDc3qSGwCeWM3crDeMYekDPKglqj
   SQrIIpI/tLt5xOL7acVy2YskDR1eQLiUd8M4HIJE1pF/x0ZMrs9X/7D6l
   eMv37ITXRcaRm6DoBP/upogUpFX7I024agHHoct1qrMeTZP2Yr5C0ER3q
   9kMCiLcb5S/kDF19hNKNyNic4wgzfkUHpJ73C2nrMQiSVWv34ZX1lV5Ds
   FVdzn/U6SvwbMXEn4ya5AZBu5yoFzfssqc6r+f623QSCxdzopqrBQU6z6
   krg2PoJDEevhJCqdeN4M6hv2FFWpaOLpI46SZBURPGDOkf0qgewSW8ghm
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="260451251"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="260451251"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 20:39:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="833381018"
Received: from zequnyu-mobl1.ccr.corp.intel.com (HELO [10.255.31.162]) ([10.255.31.162])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 20:39:23 -0700
Message-ID: <5d13cab5-1f0a-51c7-78a3-fb5d3d793ab1@linux.intel.com>
Date:   Tue, 21 Jun 2022 11:39:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, "Qiang, Chenyi" <chenyi.qiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
 <BN9PR11MB52764F60972DF52EEF945D408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52764F60972DF52EEF945D408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/21 10:54, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Monday, June 20, 2022 4:17 PM
>> @@ -2564,7 +2564,7 @@ static int domain_add_dev_info(struct
>> dmar_domain *domain, struct device *dev)
>>   			ret = intel_pasid_setup_second_level(iommu,
>> domain,
>>   					dev, PASID_RID2PASID);
>>   		spin_unlock_irqrestore(&iommu->lock, flags);
>> -		if (ret) {
>> +		if (ret && ret != -EBUSY) {
>>   			dev_err(dev, "Setup RID2PASID failed\n");
>>   			dmar_remove_one_dev_info(dev);
>>   			return ret;
>> --
>> 2.25.1
> 
> It's cleaner to avoid this error at the first place, i.e. only do the
> setup when the first device is attached to the pasid table.

The logic that identifies the first device might introduce additional
unnecessary complexity. Devices that share a pasid table are rare. I
even prefer to give up sharing tables so that the code can be
simpler.:-)

--
Best regards,
baolu
