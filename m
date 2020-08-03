Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326B123AA7E
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 18:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgHCQat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 12:30:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:37810 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHCQan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 12:30:43 -0400
IronPort-SDR: LNdul57aNmsS3qGMSdNFid03EFRDdcc09O3UDUNxPypsw9rN0SP9l/2rcv19YeuTx0JmrdejvG
 PpGwQ4J3doHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="149587769"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="149587769"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 09:30:42 -0700
IronPort-SDR: aPqtZPAbukrGaO0VjBpclcqc6FoDcQQVprCkGldxPYo3FkJW5044mbUsE2KR0jSU2sROR4ItC9
 /BjGdYdaHMTA==
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="274054350"
Received: from ksramesh-mobl.amr.corp.intel.com (HELO [10.252.128.191]) ([10.252.128.191])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 09:30:41 -0700
Subject: Re: [PATCH] Revert "ALSA: hda: call runtime_allow() for all hda
 controllers"
To:     Hui Wang <hui.wang@canonical.com>, alsa-devel@alsa-project.org,
        tiwai@suse.de
Cc:     stable@vger.kernel.org
References: <20200803064638.6139-1-hui.wang@canonical.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <0db4f5fe-7895-2d00-8ce3-96f1245000ab@linux.intel.com>
Date:   Mon, 3 Aug 2020 10:27:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803064638.6139-1-hui.wang@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/3/20 1:46 AM, Hui Wang wrote:
> This reverts commit 9a6418487b56 ("ALSA: hda: call runtime_allow()
> for all hda controllers").
> 
> The reverted patch already introduced some regressions on some
> machines:
>   - on gemini-lake machines, the error of "azx_get_response timeout"
>     happens in the hda driver.
>   - on the machines with alc662 codec, the audio jack detection doesn't
>     work anymore.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208511
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>   sound/pci/hda/hda_intel.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index e699873c8293..e34a4d5d047c 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -2352,7 +2352,6 @@ static int azx_probe_continue(struct azx *chip)
>   
>   	if (azx_has_pm_runtime(chip)) {
>   		pm_runtime_use_autosuspend(&pci->dev);
> -		pm_runtime_allow(&pci->dev);
>   		pm_runtime_put_autosuspend(&pci->dev);
>   	}

Do I get this right that this permanently disables pm_runtime on all 
Intel HDaudio controllers?

