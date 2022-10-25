Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977BA60CD07
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 15:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiJYNJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 09:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiJYNJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 09:09:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457D8ABD62;
        Tue, 25 Oct 2022 06:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666703383; x=1698239383;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0M3+MEGdR14lRpUC07BepwVn5QO57GO0AT42bgnmAqE=;
  b=ROj5dfsys67K24FUaCz1Mh/vmPRELGfdDiiEohcvySMXcE3AcyVeGeEk
   kjLn/687+Kl+uy4nM0QqY3mWjwtHpibnrCfeuGSC/hytC+ykATtk5iTAY
   kGN5VphcPhjBu01MSWoR6EyNNrRWgpftIJPuhvAlf5WYgOmVgwsGs/IyW
   AbrjMhVWpvLo+mfChTHb+auiyL/KWuwuCkOpixieU2vHURG5bJQZYmJ7W
   2lhSWEhVx86ZMQ6QGKosxO2DUATXflFqMdjf4xbNEOXVd+Bnk+btnmgY3
   ccgtj7lqt/AfzPBhZ2OESLvFtEeUpz7VQpLDjLYXJdGe5YMVJE5k8uNaO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="369734948"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="369734948"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 06:09:42 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="626415053"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="626415053"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.45.236])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 06:09:32 -0700
Message-ID: <b8f2d662-7390-a7ef-f65d-62c6897369b9@intel.com>
Date:   Tue, 25 Oct 2022 16:09:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH v3 2/7] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for
 CQHCI
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
        Jonathan Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
References: <20221024175501.2265400-1-briannorris@chromium.org>
 <20221024105229.v3.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221024105229.v3.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/10/22 20:54, Brian Norris wrote:
> SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
> tracking that properly in software. When out of sync, we may trigger
> various timeouts.
> 
> It's not typical to perform resets while CQE is enabled, but one
> particular case I hit commonly enough: mmc_suspend() -> mmc_power_off().
> Typically we will eventually deactivate CQE (cqhci_suspend() ->
> cqhci_deactivate()), but that's not guaranteed -- in particular, if
> we perform a partial (e.g., interrupted) system suspend.
> 
> The same bug was already found and fixed for two other drivers, in v5.7
> and v5.9:
> 
> 5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset

As checkpatch.pl says:

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 5cf583f1fb9c ("mmc: sdhci-msm: Deactivate CQE during SDHC reset")'


> df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers

And again

> 
> The latter is especially prescient, saying "other drivers using CQHCI
> might benefit from a similar change, if they also have CQHCI reset by
> SDHCI_RESET_ALL."
> 
> So like these other patches, deactivate CQHCI when resetting the
> controller. Do this via the new sdhci_and_cqhci_reset() helper.

For stable, this patch is dependent on "mmc: cqhci: Provide
helper for resetting both SDHCI and CQHCI".  Best point that out
here in this commit message as well.

> 
> Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Otherwise:

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes in v3:
>  - Refactor to a "SDHCI and CQHCI" helper -- sdhci_and_cqhci_reset()
> 
> Changes in v2:
>  - Rely on cqhci_deactivate() to safely handle (ignore)
>    not-yet-initialized CQE support
> 
>  drivers/mmc/host/sdhci-of-arasan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
> index 3997cad1f793..cfb891430174 100644
> --- a/drivers/mmc/host/sdhci-of-arasan.c
> +++ b/drivers/mmc/host/sdhci-of-arasan.c
> @@ -25,6 +25,7 @@
>  #include <linux/firmware/xlnx-zynqmp.h>
>  
>  #include "cqhci.h"
> +#include "sdhci-cqhci.h"
>  #include "sdhci-pltfm.h"
>  
>  #define SDHCI_ARASAN_VENDOR_REGISTER	0x78
> @@ -366,7 +367,7 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>  	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
>  
> -	sdhci_reset(host, mask);
> +	sdhci_and_cqhci_reset(host, mask);
>  
>  	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
>  		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);

