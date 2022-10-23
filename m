Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282C06094E1
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 18:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiJWQsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 12:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiJWQsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 12:48:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E25157248;
        Sun, 23 Oct 2022 09:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666543681; x=1698079681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pihOqS9DlSiDCMJeWRTq6Td+hQptLQqym3qr78Y6YlY=;
  b=nmFONdRB7rF3VZp1AbLoGvKPBJ+loPDhensGnrggQGZZcybgl6xNjLKj
   xlge3PwhRHUp7HF0dy783b1ydyCsv7wrf2GxCNHZ2k0NyOahN03ukg8oQ
   IJzXYbGFJx5mKZHKCgGte4q9xXAQi+kCBcpVm30APENZ0bGXulF1WE6xY
   mCK4R6jJAxKQJAnetGGU0xcsGdv0t3jHez85GnNz7M1Pbek9njDSMbxXZ
   rnFaFtD4dGqn+eIDRuXOsyOIkbi/cPfmcwl1+rYmvW3728CQr4PMHr7kX
   u+61M9YZnHui58HbnpfMGj7kLPL72HbfFJJtdTvJNxUBlqbeRNdvVHAWP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369349196"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="369349196"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2022 09:48:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="582191296"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="582191296"
Received: from etyuvae-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.44.32])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2022 09:47:55 -0700
Message-ID: <eb0ca8d1-cf00-ae9f-5f35-79bb81da171b@intel.com>
Date:   Sun, 23 Oct 2022 19:47:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH v2 2/7] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for
 CQHCI
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Faiz Abbas <faiz_abbas@ti.com>, linux-mmc@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Al Cooper <alcooperx@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
References: <20221019215440.277643-1-briannorris@chromium.org>
 <20221019145246.v2.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
 <14efb3e6-96cf-f42e-16aa-c45001ec632e@gmail.com>
 <Y1B36AnqJtolGQEP@google.com>
 <5f1adbf7-b477-914e-0a07-5c76532e85cd@intel.com>
 <9fe9c826-9b1a-0471-e30c-7fa949d2b08e@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <9fe9c826-9b1a-0471-e30c-7fa949d2b08e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/10/22 20:45, Florian Fainelli wrote:
> On 10/19/22 23:29, Adrian Hunter wrote:
>> On 20/10/22 01:19, Brian Norris wrote:
>>> On Wed, Oct 19, 2022 at 02:59:39PM -0700, Florian Fainelli wrote:
>>>> On 10/19/22 14:54, Brian Norris wrote:
>>>>> The same bug was already found and fixed for two other drivers, in v5.7
>>>>> and v5.9:
>>>>>
>>>>> 5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset
>>>>> df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers
>>>>>
>>>>> The latter is especially prescient, saying "other drivers using CQHCI
>>>>> might benefit from a similar change, if they also have CQHCI reset by
>>>>> SDHCI_RESET_ALL."
>>>
>>>>> --- a/drivers/mmc/host/sdhci-of-arasan.c
>>>>> +++ b/drivers/mmc/host/sdhci-of-arasan.c
>>>>> @@ -366,6 +366,9 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
>>>>>        struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>>>>>        struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
>>>>> +    if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL))
>>>>> +        cqhci_deactivate(host->mmc);
>>>>> +
>>>>>        sdhci_reset(host, mask);
>>>>
>>>> Cannot this be absorbed by sdhci_reset() that all of these drivers appear to
>>>> be utilizing since you have access to the host and the mask to make that
>>>> decision?
>>>
>>> It potentially could.
>>>
>>> I don't know if this is a specified SDHCI behavior that really belongs
>>> in the common helper, or if this is just a commonly-shared behavior. Per
>>> the comments I quote above ("if they also have CQHCI reset by
>>> SDHCI_RESET_ALL"), I chose to leave that as an implementation-specific
>>> behavior.
>>>
>>> I suppose it's not all that harmful to do this even if some SDHCI
>>> controller doesn't have the same behavior/quirk.
>>>
>>> I guess I also don't know if any SDHCI controllers will support command
>>> queueing (MMC_CAP2_CQE) via somethings *besides* CQHCI. I see
>>> CQE support in sdhci-sprd.c without CQHCI, although that driver doesn't
>>> set MMC_CAP2_CQE.
>>
>> SDHCI and CQHCI are separate modules and are not dependent, so they cannot
>> call into each other directly (and should not).  A new CQE API would be
>> needed in mmc_cqe_ops e.g. (*cqe_notify_reset)(struct mmc_host *host),
>> and wrapped in mmc/host.h:
>>
>> static inline void mmc_cqe_notify_reset(struct mmc_host *host)
>> {
>>     if (host->cqe_ops->cqe_notify_reset)
>>         host->cqe_ops->cqe_notify_reset(host);
>> }
>>
>> Alternatively, you could make a new module for SDHCI/CQHCI helper functions,
>> although in this case there is so little code it could be static inline and
>> added in a new include file instead, say sdhci-cqhci.h e.g.
>>
>> #include "cqhci.h"
>> #include "sdhci.h"
>>
>> static inline void sdhci_cqhci_reset(struct sdhci_host *host, u8 mask)
>> {
>>     if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
>>         host->mmc->cqe_private)
>>         cqhci_deactivate(host->mmc);
>>     sdhci_reset(host, mask);
>> }
>>
> 
> I like the simplicity of the inline helper, especially towards backports. May suggest to name it sdhci_and_cqhci_reset() to illustrate that it does both, and does not apply specifically CQHCI that would be "embedded" into SDHCI, but your call here.

sdhci_and_cqhci_reset() is fine by me

