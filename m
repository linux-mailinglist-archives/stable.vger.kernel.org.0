Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878CC6031DC
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 19:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiJRR7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 13:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJRR7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 13:59:15 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB22C62E3;
        Tue, 18 Oct 2022 10:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666115951; x=1697651951;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qG3pPWLpSbglp5R801rTaLLX0yFYxAOeAh4l6wso68g=;
  b=d+BsUjGZz8Ow/a2qjz6nqsp1b2WUj2XCbyhujrYo1wAEpzT/2sT1kA/n
   cB5qI5UmsO2tO9wTbHpGaIfalRY2Ym8zhzu1xhtxakOppk6jSv00omQ6J
   dUzc6+ChP19lVPx5Kq05dfS4R7/g5CtR0q5HIn0tKwqM3+cd/EqN8nFpI
   MurG8W8sVE5gEK5Ivdw+/+G79tPexK+Jsy/BlShfnGOaPLAh61KR+DVMZ
   Qg6mxqUD6xcBi90dObS7R795f3vQdlJbIoh40L/YV503LQiopoVy0SKir
   4m0qzJ9/u1WbaVmIEDNcGHmzk+avbMNHLF9nPOfrFCZx0mpb5eX+R/6I0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="368214487"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="368214487"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 10:58:54 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="874017001"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="874017001"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.51.208])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 10:58:49 -0700
Message-ID: <1953691e-4179-92c3-efa9-f10ccd3cad00@intel.com>
Date:   Tue, 18 Oct 2022 20:58:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH 1/5] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Al Cooper <alcooperx@gmail.com>, linux-mmc@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>, stable@vger.kernel.org
References: <20221018035724.2061127-1-briannorris@chromium.org>
 <20221017205610.1.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
 <e7816e4a-8558-0de0-e25f-d10abd0ef1c3@intel.com>
 <Y07bgNd7KbLDttsq@google.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Y07bgNd7KbLDttsq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/22 19:59, Brian Norris wrote:
> Hi Adrian,
> 
> On Tue, Oct 18, 2022 at 07:13:28PM +0300, Adrian Hunter wrote:
>> On 18/10/22 06:57, Brian Norris wrote:
>>> So like these other patches, deactivate CQHCI when resetting the
>>> controller. Also, move around the DT/caps handling, because
>>> sdhci_setup_host() performs resets before we've initialized CQHCI. This
>>> is the pattern followed in other SDHCI/CQHCI drivers.
>>
>> Did you consider just checking host->mmc->cqe_private like
>> sdhci_cqhci_reset() ?
> 
> I did not, although I am doing so now.
> 
> My first thought is that this feels a bit too private. Is the host
> driver supposed to be memorizing the details of the CQHCI layer?

Some drivers need to access CQHCI registers and get the reference
to cqhci_host from cqe_private, so that is already accepted.

> 
> But on the plus side, that would remove some contortions needed here
> (and also in sdhci-brcmstb.c).
> 
> Here's another option I previously considered: teaching
> cqhci_deactivate() to check cqe_private itself. That would have the same
> benefits, while keeping the private details in cqhci-core.c. How do you
> like that?

I don't mind either way.

> 
> (Tiny downside: cqhci-core.c got its rename in v5.12, so backporting
> this to -stable would get slightly more difficult.)
> 
> Brian

