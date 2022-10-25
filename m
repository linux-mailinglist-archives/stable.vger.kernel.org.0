Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E175C60CD02
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJYNJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 09:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiJYNJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 09:09:31 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C373AEA25;
        Tue, 25 Oct 2022 06:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666703361; x=1698239361;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=88arnngAkPSJ0EwT+zIV8oFGGUQKALohpb28ESLCmmM=;
  b=VlQQpUzIbvgq0z/mUhLjaZaAivXlB+VOco2vRibB+6LdZLOwTbhP7j/B
   AtyNvMevoQn+OhjCiXCSpyf6qqpfS7iHUtGa1jS77e+S3TWG7xZ8X/eer
   9US0NXMesJbcvjqna/f0Yk7ugzO5JaO9TY6YXpFmNleOZS+B7SsCisXjl
   nURCO33wZupIh3E2EX84mleApZcnfKe/9xSenk80V7YxamhgGzqYVuH/6
   m1qksQphSMAKJky8GS8ZtABYnrQxtqVZOuEXxFgUMfBDU8Uel8q7YuiML
   6NsSKxrAW3n+1Va+VT2uflj0uKfUq2q50WrUJj0aisc0ocBZXTg1ZnPqt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="334264826"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="334264826"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 06:09:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="626414886"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="626414886"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.45.236])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 06:09:11 -0700
Message-ID: <de5186fb-e176-23df-63fc-2a436e765c14@intel.com>
Date:   Tue, 25 Oct 2022 16:09:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH v3 1/7] mmc: cqhci: Provide helper for resetting both
 SDHCI and CQHCI
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Lin <shawn.lin@rock-chips.com>, linux-mmc@vger.kernel.org,
        Al Cooper <alcooperx@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Andy Gross <agross@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Faiz Abbas <faiz_abbas@ti.com>,
        Jonathan Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org
References: <20221024175501.2265400-1-briannorris@chromium.org>
 <20221024105229.v3.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221024105229.v3.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/10/22 20:54, Brian Norris wrote:
> Several SDHCI drivers need to deactivate command queueing in their reset
> hook (see sdhci_cqhci_reset() / sdhci-pci-core.c, for example), and
> several more are coming.
> 
> Those reset implementations have some small subtleties (e.g., ordering
> of initialization of SDHCI vs. CQHCI might leave us resetting with a
> NULL ->cqe_private), and are often identical across different host
> drivers.
> 
> We also don't want to force a dependency between SDHCI and CQHCI, or
> vice versa; non-SDHCI drivers use CQHCI, and SDHCI drivers might support
> command queueing through some other means.
> 
> So, implement a small helper, to avoid repeating the same mistakes in
> different drivers. Simply stick it in a header, because it's so small it
> doesn't deserve its own module right now, and inlining to each driver is
> pretty reasonable.
> 
> This is marked for -stable, as it is an important prerequisite patch for
> several SDHCI controller bugfixes that follow.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

One cosmetic nit, otherwise:

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes in v3:
>  - New in v3 (replacing a simple 'cqe_private == NULL' patch in v2)
> 
>  drivers/mmc/host/sdhci-cqhci.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 drivers/mmc/host/sdhci-cqhci.h
> 
> diff --git a/drivers/mmc/host/sdhci-cqhci.h b/drivers/mmc/host/sdhci-cqhci.h
> new file mode 100644
> index 000000000000..270ab1f1de3c
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-cqhci.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2022 The Chromium OS Authors
> + *
> + * Support that applies to the combination of SDHCI and CQHCI, while not
> + * expressing a dependency between the two modules.
> + */
> +
> +#ifndef __MMC_HOST_SDHCI_CQHCI_H__
> +#define __MMC_HOST_SDHCI_CQHCI_H__
> +
> +#include "cqhci.h"
> +#include "sdhci.h"
> +
> +static inline void sdhci_and_cqhci_reset(struct sdhci_host *host, u8 mask)
> +{
> +	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
> +	    host->mmc->cqe_private)
> +		cqhci_deactivate(host->mmc);
> +
> +	sdhci_reset(host, mask);
> +}
> +
> +

Double blank line

> +#endif /* __MMC_HOST_SDHCI_CQHCI_H__ */

