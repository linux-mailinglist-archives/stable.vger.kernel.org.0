Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAC060574E
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 08:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJTG3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 02:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJTG3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 02:29:24 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CD223E;
        Wed, 19 Oct 2022 23:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666247360; x=1697783360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZCZxqxkxlhv4qXWNtnj/k+0pRzItxdl7yKBQyZzESDw=;
  b=dE9qVrQdeA7rs/O8hwJyzshJpOCh/NcAUUnUOM+hpBfgjQpJ3f/VYonj
   3/ryuiiGXzj8WAw6LSF3cd/fmfZGrCTKhzf5dGZvdrzWDFOq1InLpdKsQ
   ex25cJ8oB1jRtAoBZ64VE0gtJKBE+QpIBzklZ2lazbItt2YGDhIGXTf03
   XjcycY0MG3yHAuiMZYVHjDAsPROr/X8GT1Jx0VVUawvSTTPTYgD6e+L2V
   +Amy4L8+PkFZcVjwuiR25cJSzUrU/Ypbgwi9G4oCqo2/o1V91poFDHjWU
   1PZkE9bo0t+50TtEjxIGgXlYozvoi75Yw+lYuyHhv+An2ePn5K5kd/Tdb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="370831246"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="370831246"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 23:29:19 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="607479841"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="607479841"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.53.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 23:29:14 -0700
Message-ID: <5f1adbf7-b477-914e-0a07-5c76532e85cd@intel.com>
Date:   Thu, 20 Oct 2022 09:29:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH v2 2/7] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for
 CQHCI
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Y1B36AnqJtolGQEP@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/10/22 01:19, Brian Norris wrote:
> On Wed, Oct 19, 2022 at 02:59:39PM -0700, Florian Fainelli wrote:
>> On 10/19/22 14:54, Brian Norris wrote:
>>> The same bug was already found and fixed for two other drivers, in v5.7
>>> and v5.9:
>>>
>>> 5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset
>>> df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers
>>>
>>> The latter is especially prescient, saying "other drivers using CQHCI
>>> might benefit from a similar change, if they also have CQHCI reset by
>>> SDHCI_RESET_ALL."
> 
>>> --- a/drivers/mmc/host/sdhci-of-arasan.c
>>> +++ b/drivers/mmc/host/sdhci-of-arasan.c
>>> @@ -366,6 +366,9 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
>>>   	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>>>   	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
>>> +	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL))
>>> +		cqhci_deactivate(host->mmc);
>>> +
>>>   	sdhci_reset(host, mask);
>>
>> Cannot this be absorbed by sdhci_reset() that all of these drivers appear to
>> be utilizing since you have access to the host and the mask to make that
>> decision?
> 
> It potentially could.
> 
> I don't know if this is a specified SDHCI behavior that really belongs
> in the common helper, or if this is just a commonly-shared behavior. Per
> the comments I quote above ("if they also have CQHCI reset by
> SDHCI_RESET_ALL"), I chose to leave that as an implementation-specific
> behavior.
> 
> I suppose it's not all that harmful to do this even if some SDHCI
> controller doesn't have the same behavior/quirk.
> 
> I guess I also don't know if any SDHCI controllers will support command
> queueing (MMC_CAP2_CQE) via somethings *besides* CQHCI. I see
> CQE support in sdhci-sprd.c without CQHCI, although that driver doesn't
> set MMC_CAP2_CQE.

SDHCI and CQHCI are separate modules and are not dependent, so they cannot
call into each other directly (and should not).  A new CQE API would be
needed in mmc_cqe_ops e.g. (*cqe_notify_reset)(struct mmc_host *host),
and wrapped in mmc/host.h:

static inline void mmc_cqe_notify_reset(struct mmc_host *host)
{
	if (host->cqe_ops->cqe_notify_reset)
		host->cqe_ops->cqe_notify_reset(host);
}

Alternatively, you could make a new module for SDHCI/CQHCI helper functions,
although in this case there is so little code it could be static inline and
added in a new include file instead, say sdhci-cqhci.h e.g.

#include "cqhci.h"
#include "sdhci.h"

static inline void sdhci_cqhci_reset(struct sdhci_host *host, u8 mask)
{
	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
	    host->mmc->cqe_private)
		cqhci_deactivate(host->mmc);
	sdhci_reset(host, mask);
}

