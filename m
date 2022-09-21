Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7DE5BFFB3
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 16:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiIUOPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 10:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUOPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 10:15:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5BA50184;
        Wed, 21 Sep 2022 07:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663769719; x=1695305719;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kV8SvwzQDpNaPqI8Ad9CXg1aOsjOIFy6gAewf2bsPso=;
  b=C+IDKMZZZu1HqM28naUEdwm6iKYjg6M2I0BFK/eueceo80ajSuQmGnDD
   6JvD5p5edjGfCCZZf+hjWYx42OZrAPurzAlvSMxe1xNU7fHG9C1KgVre0
   oXpXuqMh74At8GSbRa6VHGAluRQfYfLgo2Ads+vmVN5Ci5Yu89yeNhBHi
   QVzVzcYMmvSkp0CdFMW6rl1XIDsD1Ex01gycpFYBkbbURqfgw3IlRelqD
   NsL4WwHcEaoUrfTzZx7WjamUCjo3pxrVBXPWaL2QnNhv1OEQlmb/7Xh5W
   6lP7phEA8sOEJxuI3Q/dAnJor2TAVQWU0IV03WWo71CfnlpD+K43EHpNn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="299999188"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="299999188"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 07:15:08 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="687890947"
Received: from ryero-mobl.amr.corp.intel.com (HELO [10.209.89.231]) ([10.209.89.231])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 07:15:07 -0700
Message-ID: <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com>
Date:   Wed, 21 Sep 2022 07:15:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     rafael@kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, dave.hansen@linux.intel.com,
        bp@alien8.de, tglx@linutronix.de, andi@lisas.de, puwen@hygon.cn,
        mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220921063638.2489-1-kprateek.nayak@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/22 23:36, K Prateek Nayak wrote:
> +	/*
> +	 * No delay is needed if we are in guest or on a processor
> +	 * based on the Zen microarchitecture.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) || boot_cpu_has(X86_FEATURE_ZEN))
>  		return;

In the end, the delay is because of buggy, circa 2006 chipsets?  So, we
use a CPU vendor specific check to approximate that the chipset is
recent and not affected by the bug?  If so, is there no better way to
check for a newer chipset than this?

Do X86_FEATURE_ZEN CPUs just have unusually painful
inl(acpi_fadt.xpm_tmr_blk.address) implementations?  Is that why we
noticed all of a sudden?

