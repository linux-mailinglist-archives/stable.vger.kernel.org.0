Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004D7552AE0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 08:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345202AbiFUGPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 02:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343662AbiFUGPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 02:15:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A5415FFE;
        Mon, 20 Jun 2022 23:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655792115; x=1687328115;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zNh6pUo3+c2mfFlvlWk9GP/Xel6H0s4DqcuTRAGy/N8=;
  b=JFWYIp4+SMfB4wyhLPdbhb7dybXrokpA1h6y5WTNP+ybZZxVGiGACKqk
   Eo4yiPDPHX3HVXTQg01hLbrhQJv+DD1E22HKvyukfUlbOTDErz3NxWHWU
   VlnvuWTbJd9wgsdEJmA6jP48pYPr1RjBr8ybfN6X5A99dZf8QxbHsF4kF
   i3sTv/rtTaHPPMCcwBDp+0x3lP9IqVf8VksMXE4VirHOnUpGA2sIxFXHN
   dx8ceoC5xZi97mu9Jn1+AXqpeuOWtIpl4bMRDozPcnfYMKHHC//7XrThu
   ahYia1bHbQZ0U3jOTaWi53zwGJwD5iqYiN4CXLKcu66nQlTmWRJ8t2A5d
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="305475553"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="305475553"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 23:15:15 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="833426034"
Received: from zequnyu-mobl1.ccr.corp.intel.com (HELO [10.255.31.162]) ([10.255.31.162])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 23:15:13 -0700
Message-ID: <88295461-7cba-7c30-6b9e-63ee77e90295@linux.intel.com>
Date:   Tue, 21 Jun 2022 14:15:11 +0800
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
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Fair enough. Let me improve it.

--
Best regards,
baolu
