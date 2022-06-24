Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4FD55946F
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 09:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiFXH4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 03:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiFXH4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 03:56:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FBB6B8D0;
        Fri, 24 Jun 2022 00:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656057386; x=1687593386;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vztMzndG2ocVKYEbsSlsSSVXFya6CxLdUL/XzbaI5lY=;
  b=gCq+bAqgiE+nSGrsVidULHa8XJygywCwJHiIDB/1nM0/TeE2KElUmzmN
   XMF5drGZejiuYgsM1FXMm0wpxwznYppB7zGuT5W31JhYWVsJuJ7f2J5CW
   UJ+L6CGmYTug6f0q889U2fxAWK/fGpWMWapzVHwtqIJ/jlOG4WAv4e/JI
   407lOMkPJfTyiijibrt9wrt5J6R55j0PuQLMp/p/JK80DQZdQnNwk5Cpg
   J4NSc/HkbSf8hHhMf1dwFxe2GnvRBoee/4aDyiOlcU0G8T4Dk/GVXBYii
   EMk/1TdwPqpkbA+XgyL5xhLC2XzS7UEtESJkL0MTmjQ6e00Sie+fIldSK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="282031651"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="282031651"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 00:56:25 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="593114566"
Received: from zhaohaif-mobl1.ccr.corp.intel.com (HELO [10.254.209.161]) ([10.254.209.161])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 00:56:22 -0700
Message-ID: <6ef6c341-924c-57a6-154e-b804d8b0f2c7@linux.intel.com>
Date:   Fri, 24 Jun 2022 15:56:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/1] iommu/vt-d: Fix RID2PASID setup/teardown failure
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220623065720.727849-1-baolu.lu@linux.intel.com>
 <eb2257b1-1213-1001-74bd-085af5d50dad@linux.intel.com>
 <b8a7ab77-935d-459c-7f65-628fcf828fad@linux.intel.com>
From:   Ethan Zhao <haifeng.zhao@linux.intel.com>
In-Reply-To: <b8a7ab77-935d-459c-7f65-628fcf828fad@linux.intel.com>
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


在 2022/6/24 14:54, Baolu Lu 写道:
> On 2022/6/24 14:02, Ethan Zhao wrote:
>> 在 2022/6/23 14:57, Lu Baolu 写道:
>>> The IOMMU driver shares the pasid table for PCI alias devices. When the
>>> RID2PASID entry of the shared pasid table has been filled by the first
>>> device, the subsequent device will encounter the "DMAR: Setup RID2PASID
>>> failed" failure as the pasid entry has already been marked as present.
>>> As the result, the IOMMU probing process will be aborted.
>>>
>>> On the contrary, when any alias device is hot-removed from the system,
>>> for example, by writing to /sys/bus/pci/devices/.../remove, the shared
>>> RID2PASID will be cleared without any notifications to other devices.
>>> As the result, any DMAs from those rest devices are blocked.
>>>
>>> Sharing pasid table among PCI alias devices could save two memory pages
>>> for devices underneath the PCIe-to-PCI bridges. Anyway, considering 
>>> that
>>> those devices are rare on modern platforms that support VT-d in 
>>> scalable
>>> mode and the saved memory is negligible, it's reasonable to remove this
>>> part of immature code to make the driver feasible and stable.
>> In my understanding, thus cleanning will make the pasid table become
>> per-dev datastructure whatever the dev is pci-alias or not, and the
>> pasid_pte_is_present(pte)will only check against every pci-alias' own
>> private pasid table,the setup stagewouldn't break, so does the
>> detach/release path, and little value to code otherreference counter
>> like complex implenmataion, looks good to me !
>
> Thanks! Can I add a Reviewd-by from you?
Sure !
>
> Best regards,
> baolu

-- 
"firm, enduring, strong, and long-lived"

