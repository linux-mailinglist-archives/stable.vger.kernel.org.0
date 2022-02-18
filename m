Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D134BAFBB
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 03:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiBRCaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 21:30:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiBRCas (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 21:30:48 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE7946646
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645151431; x=1676687431;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W/lLmC9Ydf9L1mo7yCL/PULM6j/JCrlXT96rJzTiRH8=;
  b=Zvcyp+m4E9BJE3RUQcdxIcHWBlf5xUfS7VOcwrVFjiJg3WmPrs9+QfYT
   3o1eoipH5koRGswN3XiJ6gKYYAe2yBU+iK43j3Pv7zei1ANCYGt+mWcN9
   KnBaRdJ+Wxp5vuNjSUr4cmff33BL+WAe7mHA0lWjtCUl35HAV5+zUpXFA
   URKnZMAD+m9xG9+CY/0q5IOMHngFhuOV+MpI+5Pn76E6Dgv4GFpbRwAe2
   IYaEPMCZGfoXPGNiF7SksUnMt8T+Kg7Fzjg0Jp5JkjbcE5xrmg+g5nj34
   oUsKvhonTA+xvt1nufE2QHvfiEx8wNWaXtThkXyfiMlYqoz/O6o5rdWme
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="248628445"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="248628445"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:30:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="682305963"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 17 Feb 2022 18:30:28 -0800
Message-ID: <989cf124-13d7-5601-a942-e515c81a72a9@linux.intel.com>
Date:   Fri, 18 Feb 2022 10:29:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
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
To:     Adrian Huang <adrianhuang0701@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <20220216091307.703-1-adrianhuang0701@gmail.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220216091307.703-1-adrianhuang0701@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/22 5:13 PM, Adrian Huang wrote:
> pci_real_dma_dev() in pci_for_each_dma_alias() gets the real dma device
> which is the VMD device 0000:59:00.5. However, pte of the VMD device
> 0000:59:00.5 has been configured during this message "pci 0000:59:00.5:
> Adding to iommu group 42". So, the status -EBUSY is returned when
> configuring pasid entry for device 10000:80:01.0.

So the VMD subdevice (pci 10000:80:01.0) is an alias device of the "pci
0000:59:00.5", and it uses the Source-ID of "pci 0000:59:00.5" for DMA
transactions. Do I understand it right? If so, it makes sense to skip
setting up pasid entry for VMD subdevices.

Another thing I am still concerned is about the context entry setup.
What does the context entries look like for both VMD and subdevices
after domain_context_mapping() being called?

Best regards,
baolu
