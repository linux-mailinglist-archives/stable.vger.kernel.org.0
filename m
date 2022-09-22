Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A395E6E57
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 23:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiIVVVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 17:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiIVVVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 17:21:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66033110B33;
        Thu, 22 Sep 2022 14:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663881694; x=1695417694;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=65P9S+8C98ViN8zBsdNHof0LZXir7wuugXfH7l4deP0=;
  b=c+2qdmVFxSiNvmTJC+4klJryHQ76jlxE0SH6OxV3H56uTU3QA14viBNL
   Aiqdr0fwUYX/0v8I9+WEZlszuECiN5WUarapklLTMy6YCBDHRMeuccSsF
   xUkRViGeWRWg6Y3OStrYvRjwTGA+YOAbM15CyJ8XeEjbjkfMB3P2yOsiK
   6/qfgOYMrQeY+bFWXSgzwqTbHMVBjMYR3jInAq/WPrnSwnr7jYOzeR4UX
   eb2Sxg0YNP5Ab0ZyZFQRPSt2axWonKXGiqU7CKfF1ZwsUFtxFbVTijtW2
   eieuDPRX7uKVQKMVlzVFT77/SzFSYkwOs3nYQr3W3neUawCPPIYmv4vhv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="283528373"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="283528373"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 14:21:33 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="723860570"
Received: from sponnura-mobl1.amr.corp.intel.com (HELO [10.209.58.200]) ([10.209.58.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 14:21:32 -0700
Message-ID: <4d61b9c0-ee00-c5f6-bef1-622b80c79714@intel.com>
Date:   Thu, 22 Sep 2022 14:21:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     Andreas Mohr <andi@lisas.de>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
 <Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de>
 <YyzBLc+OFIN2BMz5@rhlx01.hs-esslingen.de>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <YyzBLc+OFIN2BMz5@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/22 13:10, Andreas Mohr wrote:
>   (- but then what about other more modern chipsets?)
> 
> --> we need to achieve (hopefully sufficiently precisely) a solution which
> takes into account Zen3 STPCLK# improvements while
> preserving "accepted" behaviour/requirements on *all* STPCLK#-hampered chipsets
> ("STPCLK# I/O wait is default/traditional handling"?).

Ideally, sure.  But, we're talking about theoretically regressing the
idle behavior of some indeterminate set of old systems, the majority of
which are sitting in a puddle of capacitor goo at the bottom of a
landfill right now.  This is far from an ideal situation.

FWIW, I'd much rather do something like

	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
	    (boot_cpu_data.x86_model >= 0xF))
		return;

	inl(slow_whatever);

than a Zen check.  AMD has, as far as I know, been a lot more sequential
and sane about model numbers than Intel, and there are some AMD model
number range checks in the codebase today.

A check like this would also be _relatively_ future-proof in the case
that X86_FEATURE_ZEN stops getting set on future AMD CPUs.  That's a lot
more likely than AMD going and reusing a <0xF model.
