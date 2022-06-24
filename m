Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA845593C7
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiFXGzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 02:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiFXGzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 02:55:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B233E647B3;
        Thu, 23 Jun 2022 23:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656053698; x=1687589698;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tUfVqitwWT7IxzeayDpvJgY6hbjhnF7E+9OjmKkDvuQ=;
  b=mmSl9+d2R0cECE6J1bL3MsWVCCEXJwQ7EdEttenExaN3lyFREPQ5HZea
   mvErxmIUHzlRNNGCsSQUEqF8n8GOPm0RF97iOfCb5q8IecHd9uJerHjwq
   d945tzF+hplaAefjfEVDP9keXPjEvWAtPu5+FoAVDqb7nPn5xQH3DGlP6
   Fyj31x9+Z/oHFSpEz5uS2/2zXyW71QFZaHbe4PeD5oTB7njaksYCkAjpk
   7rtlIMfJ7AVz46Ku9tPM96PsUDeLFGlJ0KTOtLfHvGeXWZYh7RH43lElN
   bjYKXFUbvnDgXSSY1P9VVDo0gzjbzogZfjPAsa3rRrm3AbDuQKYi2iJ0N
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344932337"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344932337"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 23:54:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="915563576"
Received: from rwang105-mobl4.ccr.corp.intel.com (HELO [10.249.168.100]) ([10.249.168.100])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 23:54:55 -0700
Message-ID: <b8a7ab77-935d-459c-7f65-628fcf828fad@linux.intel.com>
Date:   Fri, 24 Jun 2022 14:54:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] iommu/vt-d: Fix RID2PASID setup/teardown failure
Content-Language: en-US
To:     Ethan Zhao <haifeng.zhao@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20220623065720.727849-1-baolu.lu@linux.intel.com>
 <eb2257b1-1213-1001-74bd-085af5d50dad@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <eb2257b1-1213-1001-74bd-085af5d50dad@linux.intel.com>
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

On 2022/6/24 14:02, Ethan Zhao wrote:
> 在 2022/6/23 14:57, Lu Baolu 写道:
>> The IOMMU driver shares the pasid table for PCI alias devices. When the
>> RID2PASID entry of the shared pasid table has been filled by the first
>> device, the subsequent device will encounter the "DMAR: Setup RID2PASID
>> failed" failure as the pasid entry has already been marked as present.
>> As the result, the IOMMU probing process will be aborted.
>>
>> On the contrary, when any alias device is hot-removed from the system,
>> for example, by writing to /sys/bus/pci/devices/.../remove, the shared
>> RID2PASID will be cleared without any notifications to other devices.
>> As the result, any DMAs from those rest devices are blocked.
>>
>> Sharing pasid table among PCI alias devices could save two memory pages
>> for devices underneath the PCIe-to-PCI bridges. Anyway, considering that
>> those devices are rare on modern platforms that support VT-d in scalable
>> mode and the saved memory is negligible, it's reasonable to remove this
>> part of immature code to make the driver feasible and stable.
> In my understanding, thus cleanning will make the pasid table become
> per-dev datastructure whatever the dev is pci-alias or not, and the
> pasid_pte_is_present(pte)will only check against every pci-alias' own
> private pasid table,the setup stagewouldn't break, so does the
> detach/release path, and little value to code otherreference counter
> like complex implenmataion, looks good to me !

Thanks! Can I add a Reviewd-by from you?

Best regards,
baolu
