Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38946552DCD
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346012AbiFUJDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348746AbiFUJDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:03:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D5D2ADA;
        Tue, 21 Jun 2022 02:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655802223; x=1687338223;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4JZweCQSf+b6fCtkASZHm4F6TWH/UJu0XxFQAnCoS+g=;
  b=Vl3Q23eRLHGE1UQH+jSooMnzB5k89ZXygm13HrXoMuVvkexHiIUWYNzh
   uqt9Zjlm3BNqVtnFx80M4c3/At3o3IXobVlOai4pPSj0Vv1XJqBVqZn1n
   tQXT9WzBxcwNfCBvEmToib7ygTy0zx+JA/WovVYVtXTwQggF/zFNI/C0M
   N2Gn1Tzqe31EJdNq2inT8if9kAguALItl4U0l0YFB8pocqam2W8jYRN3C
   YUR774iCzYbXXdYmrO0CoPsItm0ziQORsYGu7bGDgnx7CeWYNWDcPToI2
   o5hwNhIIqHtZ/6jhFYaS4Yy2t1K3FbRkIYWQ4ao0wQHTE23/N066vQrNp
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="281127585"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="281127585"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 02:03:42 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="833485569"
Received: from zequnyu-mobl1.ccr.corp.intel.com (HELO [10.255.31.162]) ([10.255.31.162])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 02:03:40 -0700
Message-ID: <ff4d8dab-e409-1e5d-74c5-ddbb65c2ba03@linux.intel.com>
Date:   Tue, 21 Jun 2022 17:03:38 +0800
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
 <5d13cab5-1f0a-51c7-78a3-fb5d3d793ab1@linux.intel.com>
 <BN9PR11MB527671B3B4C1F786E40D67408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <80457871-a760-69ba-70be-5e95344182ea@linux.intel.com>
 <BN9PR11MB5276A8B4E2466BE080CA9E9B8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276A8B4E2466BE080CA9E9B8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/21 13:48, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, June 21, 2022 12:28 PM
>>
>> On 2022/6/21 11:46, Tian, Kevin wrote:
>>>> From: Baolu Lu <baolu.lu@linux.intel.com>
>>>> Sent: Tuesday, June 21, 2022 11:39 AM
>>>>
>>>> On 2022/6/21 10:54, Tian, Kevin wrote:
>>>>>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>>>>> Sent: Monday, June 20, 2022 4:17 PM
>>>>>> @@ -2564,7 +2564,7 @@ static int domain_add_dev_info(struct
>>>>>> dmar_domain *domain, struct device *dev)
>>>>>>     			ret = intel_pasid_setup_second_level(iommu,
>>>>>> domain,
>>>>>>     					dev, PASID_RID2PASID);
>>>>>>     		spin_unlock_irqrestore(&iommu->lock, flags);
>>>>>> -		if (ret) {
>>>>>> +		if (ret && ret != -EBUSY) {
>>>>>>     			dev_err(dev, "Setup RID2PASID failed\n");
>>>>>>     			dmar_remove_one_dev_info(dev);
>>>>>>     			return ret;
>>>>>> --
>>>>>> 2.25.1
>>>>>
>>>>> It's cleaner to avoid this error at the first place, i.e. only do the
>>>>> setup when the first device is attached to the pasid table.
>>>>
>>>> The logic that identifies the first device might introduce additional
>>>> unnecessary complexity. Devices that share a pasid table are rare. I
>>>> even prefer to give up sharing tables so that the code can be
>>>> simpler.:-)
>>>>
>>>
>>> It's not that complex if you simply move device_attach_pasid_table()
>>> out of intel_pasid_alloc_table(). Then do the setup if
>>> list_empty(&pasid_table->dev) and then attach device to the
>>> pasid table in domain_add_dev_info().
>>
>> The pasid table is part of the device, hence a better place to
>> allocate/free the pasid table is in the device probe/release paths.
>> Things will become more complicated if we change relationship between
>> device and it's pasid table when attaching/detaching a domain. That's
>> the reason why I thought it was additional complexity.
>>
> 
> If you do want to follow current route it’s still cleaner to check
> whether the pasid entry has pointed to the domain in the individual
> setup function instead of blindly returning -EBUSY and then ignoring
> it even if a real busy condition occurs. The setup functions can
> just return zero for this benign alias case.

Kevin, how do you like this one?

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index cb4c1d0cf25c..ecffd0129b2b 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -575,6 +575,16 @@ static inline int pasid_enable_wpe(struct 
pasid_entry *pte)
  	return 0;
  };

+/*
+ * Return true if @pasid is RID2PASID and the domain @did has already
+ * been setup to the @pte. Otherwise, return false.
+ */
+static inline bool
+rid2pasid_domain_valid(struct pasid_entry *pte, u32 pasid, u16 did)
+{
+	return pasid == PASID_RID2PASID && pasid_get_domain_id(pte) == did;
+}
+
  /*
   * Set up the scalable mode pasid table entry for first only
   * translation type.
@@ -595,9 +605,8 @@ int intel_pasid_setup_first_level(struct intel_iommu 
*iommu,
  	if (WARN_ON(!pte))
  		return -EINVAL;

-	/* Caller must ensure PASID entry is not in use. */
  	if (pasid_pte_is_present(pte))
-		return -EBUSY;
+		return rid2pasid_domain_valid(pte, pasid, did) ? 0: -EBUSY;

  	pasid_clear_entry(pte);

@@ -698,9 +707,8 @@ int intel_pasid_setup_second_level(struct 
intel_iommu *iommu,
  		return -ENODEV;
  	}

-	/* Caller must ensure PASID entry is not in use. */
  	if (pasid_pte_is_present(pte))
-		return -EBUSY;
+		return rid2pasid_domain_valid(pte, pasid, did) ? 0: -EBUSY;

  	pasid_clear_entry(pte);
  	pasid_set_domain_id(pte, did);
@@ -738,9 +746,8 @@ int intel_pasid_setup_pass_through(struct 
intel_iommu *iommu,
  		return -ENODEV;
  	}

-	/* Caller must ensure PASID entry is not in use. */
  	if (pasid_pte_is_present(pte))
-		return -EBUSY;
+		return rid2pasid_domain_valid(pte, pasid, did) ? 0: -EBUSY;

  	pasid_clear_entry(pte);
  	pasid_set_domain_id(pte, did);

--
Best regards,
baolu
