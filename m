Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5D21853B
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 08:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfEIGQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 02:16:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:26831 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfEIGQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 02:16:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 23:16:16 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga001.fm.intel.com with ESMTP; 08 May 2019 23:16:12 -0700
Subject: Re: [PATCH v2 2/2] mmc: sdhci-iproc: Set NO_HISPD bit to fix HS50
 data hold time problem
To:     Scott Branden <scott.branden@broadcom.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc:     BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Trac Hoang <trac.hoang@broadcom.com>,
        stable@vger.kernel.org
References: <20190508164044.22451-1-scott.branden@broadcom.com>
 <20190508164044.22451-3-scott.branden@broadcom.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <b6c3a860-0406-9e5b-3e1b-37b5dee6b5d5@intel.com>
Date:   Thu, 9 May 2019 09:16:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508164044.22451-3-scott.branden@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/05/19 7:40 PM, Scott Branden wrote:
> From: Trac Hoang <trac.hoang@broadcom.com>
> 
> The iproc host eMMC/SD controller hold time does not meet the
> specification in the HS50 mode.  This problem can be mitigated
> by disabling the HISPD bit; thus forcing the controller output
> data to be driven on the falling clock edges rather than the
> rising clock edges.

You should add your stable comments as well i.e.

Scott chose this tag (v4.12+) to assist stable kernel maintainers so that
the change does not produce merge conflicts backporting to older kernel
versions. In reality, the timing bug existed since the driver was first
introduced but there is no need for this driver to be supported in kernel
versions that old.

> 
> Cc: stable@vger.kernel.org # v4.12+
> Signed-off-by: Trac Hoang <trac.hoang@broadcom.com>
> Signed-off-by: Scott Branden <scott.branden@broadcom.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/sdhci-iproc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
> index 9d4071c41c94..2feb4ef32035 100644
> --- a/drivers/mmc/host/sdhci-iproc.c
> +++ b/drivers/mmc/host/sdhci-iproc.c
> @@ -220,7 +220,8 @@ static const struct sdhci_iproc_data iproc_cygnus_data = {
>  
>  static const struct sdhci_pltfm_data sdhci_iproc_pltfm_data = {
>  	.quirks = SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
> -		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
> +		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
> +		  SDHCI_QUIRK_NO_HISPD_BIT,
>  	.quirks2 = SDHCI_QUIRK2_ACMD23_BROKEN,
>  	.ops = &sdhci_iproc_ops,
>  };
> 

