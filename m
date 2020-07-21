Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7969228C7E
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 01:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgGUXLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 19:11:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:59890 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgGUXLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 19:11:38 -0400
IronPort-SDR: e4DCA/0mtI3ZetSLuEHHreYeZVvBpvgfjguM4T44GKw7KRN2rWAgCIxibpXTc28Y6qCgD+svEN
 /7wm60dLVA6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="130326368"
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="130326368"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 16:11:37 -0700
IronPort-SDR: UkdvjQPsfhGCtfdh2igIhtlU+U1RScxgkXHZLfUkKlV9tZJ34r5zXMkIfBCKgKaTZzegujEIOO
 FFJGEm/aNdNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="462248054"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by orsmga005.jf.intel.com with ESMTP; 21 Jul 2020 16:11:34 -0700
Cc:     baolu.lu@linux.intel.com, Ashok Raj <ashok.raj@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Koba Ko <koba.ko@canonical.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicated
 iommu
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200721001713.24282-1-baolu.lu@linux.intel.com>
 <DM6PR19MB2636D1CC549743E2113C0EAFFA780@DM6PR19MB2636.namprd19.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <d8548318-ee2e-ca3f-cb0a-e219ce23d471@linux.intel.com>
Date:   Wed, 22 Jul 2020 07:06:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <DM6PR19MB2636D1CC549743E2113C0EAFFA780@DM6PR19MB2636.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Limonciello,

On 7/21/20 10:44 PM, Limonciello, Mario wrote:
>> -----Original Message-----
>> From: iommu<iommu-bounces@lists.linux-foundation.org>  On Behalf Of Lu
>> Baolu
>> Sent: Monday, July 20, 2020 7:17 PM
>> To: Joerg Roedel
>> Cc: Ashok Raj;linux-kernel@vger.kernel.org;stable@vger.kernel.org; Koba
>> Ko;iommu@lists.linux-foundation.org
>> Subject: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicated
>> iommu
>>
>> The VT-d spec requires (10.4.4 Global Command Register, TE field) that:
>>
>> Hardware implementations supporting DMA draining must drain any in-flight
>> DMA read/write requests queued within the Root-Complex before completing
>> the translation enable command and reflecting the status of the command
>> through the TES field in the Global Status register.
>>
>> Unfortunately, some integrated graphic devices fail to do so after some
>> kind of power state transition. As the result, the system might stuck in
>> iommu_disable_translation(), waiting for the completion of TE transition.
>>
>> This provides a quirk list for those devices and skips TE disabling if
>> the qurik hits.
>>
>> Fixes:https://bugzilla.kernel.org/show_bug.cgi?id=208363
> That one is for TGL.
> 
> I think you also want to add this one for ICL:
> Fixes:https://bugzilla.kernel.org/show_bug.cgi?id=206571
> 

Do you mean someone have tested that this patch also fixes the problem
described in 206571?

Best regards,
baolu
