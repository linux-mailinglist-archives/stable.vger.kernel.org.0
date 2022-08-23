Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FC059D141
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 08:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbiHWGYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 02:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbiHWGYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 02:24:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8071F3F1CF;
        Mon, 22 Aug 2022 23:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661235845; x=1692771845;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=So4u55pm93jKnWf9wayBaxQcyua1SoUZ3g3nOT8rlsI=;
  b=HCuaJouIDbUM6qTh9+n17EMYXX7N74jfjbWUtIwcOAhMlhCPJqK6y3No
   q8VWrGXPj1W2N5ek53iaxyeIeG+drRZ1NSCZJzlLbFNaSsHMJ1QGU3flJ
   woc2cM6Qrr6bsR/QpmaGqaIZfRMvlR9UEks1ej5VQRVMyJ3N5gahwnCoI
   ffPd5x5Zs8z01npkYJ5VXUWOdOkfOBzSVx4sp5v73QijjBpiGMuCq1CNn
   5wqwBqtXjTw3A3+YXQgT8NyVk1GqElvcjRbSptdhMWcdOAmLLhMEpDRmX
   kASO/CNw57vD0ZKHruDeJ1pmHnvfBtg6U4de2en7SSZr9UKtO1MFbbfad
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="379893254"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="379893254"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 23:24:05 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="642323745"
Received: from xujinlon-mobl.ccr.corp.intel.com (HELO [10.254.211.102]) ([10.254.211.102])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 23:24:01 -0700
Message-ID: <8f1c7e64-efdc-eff5-8dea-470f4ada5f73@linux.intel.com>
Date:   Tue, 23 Aug 2022 14:23:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Wen Jin <wen.jin@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Content-Language: en-US
To:     iommu@lists.linux.dev
References: <20220817011035.3250131-1-baolu.lu@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220817011035.3250131-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/8/17 09:10, Lu Baolu wrote:
> The translation table copying code for kdump kernels is currently based
> on the extended root/context entry formats of ECS mode defined in older
> VT-d v2.5, and doesn't handle the scalable mode formats. This causes
> the kexec capture kernel boot failure with DMAR faults if the IOMMU was
> enabled in scalable mode by the previous kernel.
> 
> The ECS mode has already been deprecated by the VT-d spec since v3.0 and
> Intel IOMMU driver doesn't support this mode as there's no real hardware
> implementation. Hence this converts ECS checking in copying table code
> into scalable mode.
> 
> The existing copying code consumes a bit in the context entry as a mark
> of copied entry. This marker needs to work for the old format as well as
> for extended context entries. It's hard to find such a bit for both
> legacy and scalable mode context entries. This replaces it with a per-
> IOMMU bitmap.
> 
> Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
> Cc:stable@vger.kernel.org
> Reported-by: Jerry Snitselaar<jsnitsel@redhat.com>
> Tested-by: Wen Jin<wen.jin@intel.com>
> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>

This patch has been queued:

https://lore.kernel.org/linux-iommu/20220823061557.1631056-1-baolu.lu@linux.intel.com/

Best regards,
baolu
