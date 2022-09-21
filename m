Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA715BF610
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 08:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiIUGIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 02:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIUGIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 02:08:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08407C1CA
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 23:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663740526; x=1695276526;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6EnqeurB9knvf7hjHnRGpP20ctHeBAKLCwcD/QCEq+s=;
  b=I8r6t6a7xwqYoi9AlZiU6NdlL/2tIqFcBU8Y1LS3a/8rGiAYkuIeSDDd
   9iAPmQvOUk8e8GNI8uYaPuU/sSyaiXGAo+dQggkXY4+8shDy3sCce8148
   BQQR3eoisTZ1NM1Tnut1KcTSMp4b/DoQ6x5AKCAkQBmq/7RXtfDXBX8pP
   76qPtTRvEmcqs5/KQ6xE5rbdE5N/apny25qcxjR8688aA8VXt3y6T+0Pj
   ZH5MynVOYf62NCiNzjLRSbfhS3drYKHsiRh3fLl34OpQvf9INMOoLokBC
   JRADmepdW5oNgzF2YoJrOF+6r28NxYd3KwRP0G+oYaUYfX4fI1DzpO0wr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="298629967"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="298629967"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 23:08:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="649914489"
Received: from jzha151-mobl1.ccr.corp.intel.com (HELO [10.254.208.217]) ([10.254.208.217])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 23:08:44 -0700
Message-ID: <de65f9ae-dd74-3f70-35c7-861832a1de7b@linux.intel.com>
Date:   Wed, 21 Sep 2022 14:08:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Cc:     baolu.lu@linux.intel.com, kevin.tian@intel.com, baolu.lu@intel.com,
        raghunathan.srinivasan@intel.com, iommu@lists.linux.dev,
        joro@8bytes.org, will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/vt-d: Check correct capability for sagaw
 determination
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>
References: <20220916071212.2223869-1-yi.l.liu@intel.com>
 <20220916071212.2223869-2-yi.l.liu@intel.com>
 <a5f2141a-d819-20de-1e6c-b9e93323998a@linux.intel.com>
 <23d38de5-3aab-3fe7-2b17-cbf1ab8d6cab@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <23d38de5-3aab-3fe7-2b17-cbf1ab8d6cab@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/9/21 11:35, Yi Liu wrote:
> On 2022/9/21 10:44, Baolu Lu wrote:
>> On 9/16/22 3:12 PM, Yi Liu wrote:
>>> Check 5-level paging capability for 57 bits address width instead of
>>> checking 1GB large page capability.
>>>
>>> Fixes: 53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of 
>>> IOMMU")
>>> Cc:stable@vger.kernel.org
>>> Reported-by: Raghunathan Srinivasan<raghunathan.srinivasan@intel.com>
>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>
>> Queued for v6.0. Thank you very much!
>>
>> https://lore.kernel.org/linux-iommu/20220921024054.3570256-1-baolu.lu@linux.intel.com
> 
> grt. btw. how about below? not sure why it didn't show up in this 
> series. 🙁
> 
> https://lore.kernel.org/linux-iommu/BN9PR11MB5276F062B5C0C08F10EFB49F8C4C9@BN9PR11MB5276.namprd11.prod.outlook.com/

This is not a fix. I will queue it for v6.1-rc1 later.

Best regards,
baolu
