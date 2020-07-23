Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F22822A4D2
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbgGWBnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:43:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:35136 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgGWBnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 21:43:20 -0400
IronPort-SDR: vGmSKqUiAwiT79TdRlYfUEzhn+QRTigIexKiuE57WYP+IshVvcWoYnVTzDgoGbgKjQO/xC2qOB
 qeV1kVAWmHJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="211994130"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="211994130"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 18:43:20 -0700
IronPort-SDR: qzEgg29TJShS4o3Yp4JnojIJki6kfZSSgbAjaUh16Ol/Mp5LoUetM0bF3whgosZFuwAEP/+n5K
 rYuL/eygxALg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="392853121"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jul 2020 18:43:17 -0700
Cc:     baolu.lu@linux.intel.com, Ashok Raj <ashok.raj@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Koba Ko <koba.ko@canonical.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Christian Kellner <ckellner@redhat.com>
Subject: Re: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicated
 iommu
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200721001713.24282-1-baolu.lu@linux.intel.com>
 <DM6PR19MB2636D1CC549743E2113C0EAFFA780@DM6PR19MB2636.namprd19.prod.outlook.com>
 <d8548318-ee2e-ca3f-cb0a-e219ce23d471@linux.intel.com>
 <DM6PR19MB263622CA8CAA7CDA3973E0DBFA780@DM6PR19MB2636.namprd19.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <2695916e-0dfd-6c8a-d4e7-1f4da372e123@linux.intel.com>
Date:   Thu, 23 Jul 2020 09:38:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR19MB263622CA8CAA7CDA3973E0DBFA780@DM6PR19MB2636.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/22/20 7:45 AM, Limonciello, Mario wrote:
> 
> 
>> -----Original Message-----
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, July 21, 2020 6:07 PM
>> To: Limonciello, Mario; Joerg Roedel
>> Cc: baolu.lu@linux.intel.com; Ashok Raj; linux-kernel@vger.kernel.org;
>> stable@vger.kernel.org; Koba Ko; iommu@lists.linux-foundation.org
>> Subject: Re: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicated
>> iommu
>>
>>
>> [EXTERNAL EMAIL]
>>
>> Hi Limonciello,
>>
>> On 7/21/20 10:44 PM, Limonciello, Mario wrote:
>>>> -----Original Message-----
>>>> From: iommu<iommu-bounces@lists.linux-foundation.org>  On Behalf Of Lu
>>>> Baolu
>>>> Sent: Monday, July 20, 2020 7:17 PM
>>>> To: Joerg Roedel
>>>> Cc: Ashok Raj;linux-kernel@vger.kernel.org;stable@vger.kernel.org; Koba
>>>> Ko;iommu@lists.linux-foundation.org
>>>> Subject: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicated
>>>> iommu
>>>>
>>>> The VT-d spec requires (10.4.4 Global Command Register, TE field) that:
>>>>
>>>> Hardware implementations supporting DMA draining must drain any in-flight
>>>> DMA read/write requests queued within the Root-Complex before completing
>>>> the translation enable command and reflecting the status of the command
>>>> through the TES field in the Global Status register.
>>>>
>>>> Unfortunately, some integrated graphic devices fail to do so after some
>>>> kind of power state transition. As the result, the system might stuck in
>>>> iommu_disable_translation(), waiting for the completion of TE transition.
>>>>
>>>> This provides a quirk list for those devices and skips TE disabling if
>>>> the qurik hits.
>>>>
>>>> Fixes:https://bugzilla.kernel.org/show_bug.cgi?id=208363
>>> That one is for TGL.
>>>
>>> I think you also want to add this one for ICL:
>>> Fixes:https://bugzilla.kernel.org/show_bug.cgi?id=206571
>>>
>>
>> Do you mean someone have tested that this patch also fixes the problem
>> described in 206571?
>>
> 
> Yes, confusingly https://bugzilla.kernel.org/show_bug.cgi?id=208363#c31 actually
> is the XPS 9300 ICL system and issue.
> 
> I also have a private confirmation from another person that it resolves it for
> them on another ICL platform.
> 

Okay! Thank you very much! I just posted v2 with this tag added.

Best regards,
baolu
