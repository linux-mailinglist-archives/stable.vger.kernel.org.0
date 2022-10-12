Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094905FCD61
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJLVkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 17:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJLVkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 17:40:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3B046D89;
        Wed, 12 Oct 2022 14:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665610816; x=1697146816;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1LTMA3/XHH00E7Eh5BDx5GqsoMAtA/guNRF3xzFYot4=;
  b=hpZ1lsCT5oose1DVJlM4k+HZ/Rj5R7xa4RgsZK2boELo/4brSzSOQAQR
   0tPSjRPgou9dQMfXy8SDm5sPYN5xcFsSSOn4/Q+dLKXZ2shQscI3Mg5vH
   IFPlYAF7FIqiHehJAXlWdIl4PKxrmRWejx+zDXeENTxG2Wz7DXbHusouo
   pzdAgpJHeP7UDVGM781SnX1+NmmpoFy2nWzEXiFiNNa49HqzBTUKA2m98
   98fRLrLU/yK3Ps5v2t2aM8I0tk4E5egVm8gXAKg+ZkcsLe4nBbBgzxtX9
   1ErtGOYe8vVxTpiPWYe+jXRBgEB7pQG17lGK+iLLZtwbHQ0Ngk3Q8+3R2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="366914758"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="366914758"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 14:40:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="577981465"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="577981465"
Received: from mpatter1-mobl.amr.corp.intel.com (HELO [10.209.53.34]) ([10.209.53.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 14:40:14 -0700
Message-ID: <9e967bb2-ac46-fc1c-ac3a-ed527c6a4cb5@intel.com>
Date:   Wed, 12 Oct 2022 14:40:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] dmaengine: idxd: Do not enable user type Work Queue
 without Shared Virtual Addressing
Content-Language: en-US
To:     Fenghua Yu <fenghua.yu@intel.com>, Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     dmaengine@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20221012201418.3883096-1-fenghua.yu@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20221012201418.3883096-1-fenghua.yu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/22 13:14, Fenghua Yu wrote:
> Userspace can directly access physical address through user type
> Work Queue (WQ) in two scenarios: no IOMMU or IOMMU Passthrough
> without Shared Virtual Addressing (SVA). In these two cases, user type WQ
> allows userspace to issue DMA physical address access without virtual
> to physical translation.
> 
> This is inconsistent with the security goals of a good kernel API.
> 
> Plus there is no usage for user type WQ without SVA.
> 
> So enable user type WQ only when SVA is enabled (i.e. user PASID is
> enabled).

I'm not sure the changelog here is great.

The whole "user Work Queue" thing is an entire *DRIVER*.  So, this
really has zero to do with the type of workqueue and everything to do
with the kind of drivers we allow to be loaded and drive the hardware.

Basically, the *hardware* allows pretty arbitrary direct access to
physical memory.  The 'idxd_user_drv' driver code (including
idxd_user_drv_probe()) gives low-level, direct access to the hardware,
which is bad news.

Plus, even if userspace got access to the device via this driver, they
have to feel physical addresses to it, which is generally not easy from
userspace.

That's as close as I can get to rephrasing the above TLA soup in plain
old English.

I also detest the "There is no usage case for the WQ without SVA."
language.  Those words lack meaning.  There has to be a *REASON* there
is no use case.  Please think about what those words *mean*, then delete
them and write what they mean.
