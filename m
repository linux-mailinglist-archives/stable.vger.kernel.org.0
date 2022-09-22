Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512685E6A85
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 20:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiIVSSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 14:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiIVSSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 14:18:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86D910912A;
        Thu, 22 Sep 2022 11:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870703; x=1695406703;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=irvpxRGJNiroM1fXkhuMmUhHwaH1jS9Bj7zSfZHS2YY=;
  b=anQvo6aPXHB1/aXMtMyd2JhzZviW6g3lc23KwKyZHqzdKSdTEPKTQGyc
   /QUrg3MVohEdIgsoUSxWACnfkHD24Tjr3jYOLCSmGPf65zsiMD2kRZFZb
   UywDvHf0/Ed+U2S2QM5zsc2VWBTi8K7qHDmblp08c0InFBL5AlrkwVDyy
   9Ndx6C6EQkgq+eWaspsmTNj0sWts8YfG08UGd3lP5o1bp7mU5igLiPqvz
   IFzo5c18+js1u1+oaB7LtQJf7LaE5qhz/0orqiUcsjd5sCwecoxcjX2Pl
   9fmAms5qGgHCCPoTsJi7qaMUAL3TnwGEpvNg4f/2STOLDzoydUuLmOH4R
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="300371015"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="300371015"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:17:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="682328889"
Received: from sponnura-mobl1.amr.corp.intel.com (HELO [10.209.58.200]) ([10.209.58.200])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:17:53 -0700
Message-ID: <9d3d3424-a6d4-4076-87ff-a1c216de79c6@intel.com>
Date:   Thu, 22 Sep 2022 11:17:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "Nayak, K Prateek" <KPrateek.Nayak@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "rafael@kernel.org" <rafael@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andi@lisas.de" <andi@lisas.de>, "puwen@hygon.cn" <puwen@hygon.cn>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Narayan, Ananth" <Ananth.Narayan@amd.com>,
        "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>,
        "Ong, Calvin" <Calvin.Ong@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
 <MN0PR12MB610110D90985366A4B952CCCE24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <MN0PR12MB610110D90985366A4B952CCCE24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/22 10:48, Limonciello, Mario wrote:
> 
> 2) The title says to limit it to old intel systems, but nothing about this actually enforces that.
> It actually is limited to all Intel systems, but effectively won't be used on anything but new
> ones because of intel_idle.
> 
> As an idea for #2 you could check for CONFIG_INTEL_IDLE in the Intel case and
> if it's not defined show a pr_notice_once() type of message trying to tell people to use
> Intel Idle instead for better performance.

What does that have to do with *this* patch, though?

If you've got CONFIG_INTEL_IDLE disabled, you'll be slow before this
patch.  You'll also be slow after this patch.  It's entirely orthogonal.

I can add a "Practically" to the subject so folks don't confuse it with
some hard limit that is being enforced:

	ACPI: processor idle: Practically limit "Dummy wait" workaround to old
Intel systems

BTW, is there seriously a strong technical reason that AMD systems are
still using this code?  Or is it pure inertia?
