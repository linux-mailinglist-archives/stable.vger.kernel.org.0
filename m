Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE945540DA
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 05:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355869AbiFVDWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 23:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiFVDWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 23:22:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A87A3135E;
        Tue, 21 Jun 2022 20:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655868156; x=1687404156;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wvz1BbOPL5rCLg5gmfrFRw44k7kfAr8LSKwM5LsaZGE=;
  b=aPWQDnx3IgEQaUVj6hk7MOfGD2c/+X6gFalHjXLlJLZ8CbI0fFgrBPX5
   PxB+wo2LKAUrJlC/CUupo6A5uFAH4KZh5BpDTcCQalKZX/A2pp9+rGNu5
   9Zq+vr2lOvNc+jU8L6mrUDzwaw35Vzow58maq5ppomEti49aLowkgyRtl
   S0I3XCsiDBzzczM6xLsibZ1hg1xAxlmvSwRxextz71q2oFVCOeNmN0G54
   Wjdd71yKdrkt2ybuo+n0J0fDo0qz2UArPqk4a7n+7kGuTMF/s4PwZ5n18
   pPqhLf/QvcatkRutIK2NxoT+eveYnBuK/SiLGiftfJ/CDNc3+KggY58HV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="269019197"
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="269019197"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 20:22:35 -0700
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="833881083"
Received: from xzhan99-mobl1.ccr.corp.intel.com (HELO [10.249.172.26]) ([10.249.172.26])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 20:22:33 -0700
Message-ID: <809824df-bb33-a878-0652-02f7eb135fa4@linux.intel.com>
Date:   Wed, 22 Jun 2022 11:22:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Content-Language: en-US
To:     Ethan Zhao <haifeng.zhao@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
 <30d27b02-0fec-d595-75a0-155eee1c84d6@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <30d27b02-0fec-d595-75a0-155eee1c84d6@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/22 10:56, Ethan Zhao wrote:
> 在 2022/6/20 16:17, Lu Baolu 写道:
>> The IOMMU driver shares the pasid table for PCI alias devices. When the
>> RID2PASID entry of the shared pasid table has been filled by the first
>> device, the subsequent devices will encounter the "DMAR: Setup RID2PASID
>> failed" failure as the pasid entry has already been marke as present. As
>> the result, the IOMMU probing process will be aborted.
>>
>> This fixes it by skipping RID2PASID setting if the pasid entry has been
>> populated. This works because the IOMMU core ensures that only the same
>> IOMMU domain can be attached to all PCI alias devices at the same time.
>> Therefore the subsequent devices just try to setup the RID2PASID entry
>> with the same domain, which is negligible.
>      We have two customers reported the issue "DMAR: Setup RID2PASID 
> failed",
> 
> Two ASPEED devices locate behind one PCIe-PCI bridge and iommu SM, PT 
> mode is enabled.  Most
> 
> Interesting thing is the second device is only used by BIOS, and BIOS 
> left it to OS without shutting down,
> 
> and it is useless for OS.

This sounds odd. Isn't this a bug?


> Is there practical case multi devices behind 
> PCIe-PCI bridge share the same
> 
> PASID entry without any security concern ? these two customer's case is 
> not.

The devices underneath the PCIe-PCI bridge are alias devices of the
bridge. PCI alias devices always sit in the same group (the minimal unit
that IOMMU guarantees isolation) and can only be attached with a same
domain (managed I/O address space). Hence, there's no security concern
if they further share the pasid table.

Best regards,
baolu
