Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315214BD40B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 03:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344053AbiBUCqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 21:46:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344037AbiBUCqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 21:46:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26813443E7
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 18:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645411576; x=1676947576;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uz8E+xxDJjeZD5vPZzoxNAUPHJZRua/avHFTeYZFUi4=;
  b=FRnvZCyYtJopXkCPaYoupZZLKZxivxMrR4YM1vwAco86xrdNDH3b0SI1
   R8+pxCSHBz8tfpu+Ofoo+Ic86ab+moeCPQQC+zZ8nA6agr4WFR9FP0ulK
   IqEAEBHBWQEqaPAb74uac/poDtyS00EGczz5f8E/XHRC969cMX2xxOyBs
   mEp7eUniJpk4HTqAsRXqzTYNzm0kp+ZdKpMIq4UJT4RKze/IGOQh7RHE/
   AgnSbuNmWiHQvp6ehWhFrVFonfkQwR5/YRYNC6JikaA8XnSTcSHdSIvWX
   5pXCFwLuhMoKStZREMxVSwPaMt8xA7hhLB7FBFs8BgJ/Dblg879KseCFE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="249004299"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="249004299"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 18:46:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="683067471"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2022 18:46:13 -0800
Message-ID: <b762903c-adf9-67a0-df6d-a1212e12670e@linux.intel.com>
Date:   Mon, 21 Feb 2022 10:44:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org,
        Kevin Tian <kevin.tian@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Nirmal Patel <nirmal.patel@linux.intel.com>,
        Jonathan Derrick <jonathan.derrick@linux.dev>,
        stable@vger.kernel.org, Adrian Huang <ahuang12@lenovo.com>
Subject: Re: [PATCH v2 1/1] iommu/vt-d: Fix list_add double add when enabling
 VMD and scalable mode
Content-Language: en-US
To:     Huang Adrian <adrianhuang0701@gmail.com>
References: <20220216091307.703-1-adrianhuang0701@gmail.com>
 <989cf124-13d7-5601-a942-e515c81a72a9@linux.intel.com>
 <CAHKZfL0dx8HuuB1AqN3fkcHjPZDJMTfPqRgW4XnuFVE8Cw4iFQ@mail.gmail.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <CAHKZfL0dx8HuuB1AqN3fkcHjPZDJMTfPqRgW4XnuFVE8Cw4iFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/22 4:21 PM, Huang Adrian wrote:
>> Another thing I am still concerned is about the context entry setup.
>> What does the context entries look like for both VMD and subdevices
>> after domain_context_mapping() being called?
> pasid_table in struct device_domain_info is NULL because the field
> pasid_table is configured in intel_pasid_alloc_table().
> 
> The following statement in domain_context_mapping_one() is true for
> subdevices because the context is configured by the real VMD device
> 0000:59:00.5. So, domain_context_mapping() does nothing for
> subdevices.
>                  if (context_present(context))
>                                goto out_unlock;
> 
> Here is the log for your reference with pr_debug() enabled.
> 
> [   19.063445] pci 0000:59:00.5: Adding to iommu group 42
> ...
> [   22.673502] DMAR: Set context mapping for 59:00.5
> ..
> [   32.089696] vmd 0000:59:00.5: PCI host bridge to bus 10000:80
> [   32.119452] pci 10000:80:01.0: [8086:352a] type 01 class 0x060400
> [   32.126302] pci 10000:80:01.0: reg 0x10: [mem 0x00000000-0x0001ffff 64bit]
> [   32.134023] pci 10000:80:01.0: enabling Extended Tags
> [   32.139730] pci 10000:80:01.0: PME# supported from D0 D3hot D3cold
> [   32.160526] DMAR: Set context mapping for 59:00.5
> [   32.171090] pci 10000:80:01.0: Adding to iommu group 42
> ...

That's clear to me now. Thank you very much!

Best regards,
baolu
