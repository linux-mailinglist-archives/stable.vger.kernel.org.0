Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E67E1C9750
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgEGRVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:21:40 -0400
Received: from mga17.intel.com ([192.55.52.151]:18693 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgEGRVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:21:40 -0400
IronPort-SDR: cM+Yedsq6jkDtKE2D9Ke1MlcyZHSD1bwfkm7JyAEpLhfFlLChWaMvmtH9yH3tzrD5BQUchRkKU
 509LU12gci4Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 10:21:40 -0700
IronPort-SDR: GK+1icHNFj19CJ+91hjNV73ayYdaExpKxnPX4/gEJDQJzbISNiD+HHK6RgHmxhcKuVCFKVYumN
 tS6M1fgmCP/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="285066680"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.157]) ([10.237.72.157])
  by fmsmga004.fm.intel.com with ESMTP; 07 May 2020 10:21:34 -0700
Subject: Re: [PATCH V2] mmc: core: Fix recursive locking issue in CQE recovery
 path
To:     Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        ulf.hansson@linaro.org
Cc:     stummala@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Sarthak Garg <sartgarg@codeaurora.org>, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1588775643-18037-3-git-send-email-vbadigan@codeaurora.org>
 <1588868135-31783-1-git-send-email-vbadigan@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <adecb267-0013-9eb2-42c3-89c660724176@intel.com>
Date:   Thu, 7 May 2020 20:21:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588868135-31783-1-git-send-email-vbadigan@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/05/20 7:15 pm, Veerabhadrarao Badiganti wrote:
> From: Sarthak Garg <sartgarg@codeaurora.org>
> 
> Consider the following stack trace
> 
> -001|raw_spin_lock_irqsave
> -002|mmc_blk_cqe_complete_rq
> -003|__blk_mq_complete_request(inline)
> -003|blk_mq_complete_request(rq)
> -004|mmc_cqe_timed_out(inline)
> -004|mmc_mq_timed_out
> 
> mmc_mq_timed_out acquires the queue_lock for the first
> time. The mmc_blk_cqe_complete_rq function also tries to acquire
> the same queue lock resulting in recursive locking where the task
> is spinning for the same lock which it has already acquired leading
> to watchdog bark.
> 
> Fix this issue with the lock only for the required critical section.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 1e8e55b67030 ("mmc: block: Add CQE support")
> Suggested-by: Sahitya Tummala <stummala@codeaurora.org>
> Signed-off-by: Sarthak Garg <sartgarg@codeaurora.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/core/queue.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index 25bee3d..b5fd3bc 100644
> --- a/drivers/mmc/core/queue.c
> +++ b/drivers/mmc/core/queue.c
> @@ -107,7 +107,7 @@ static enum blk_eh_timer_return mmc_cqe_timed_out(struct request *req)
>  	case MMC_ISSUE_DCMD:
>  		if (host->cqe_ops->cqe_timeout(host, mrq, &recovery_needed)) {
>  			if (recovery_needed)
> -				__mmc_cqe_recovery_notifier(mq);
> +				mmc_cqe_recovery_notifier(mrq);
>  			return BLK_EH_RESET_TIMER;
>  		}
>  		/* No timeout (XXX: huh? comment doesn't make much sense) */
> @@ -127,18 +127,13 @@ static enum blk_eh_timer_return mmc_mq_timed_out(struct request *req,
>  	struct mmc_card *card = mq->card;
>  	struct mmc_host *host = card->host;
>  	unsigned long flags;
> -	int ret;
> +	bool ignore_tout;
>  
>  	spin_lock_irqsave(&mq->lock, flags);
> -
> -	if (mq->recovery_needed || !mq->use_cqe || host->hsq_enabled)
> -		ret = BLK_EH_RESET_TIMER;
> -	else
> -		ret = mmc_cqe_timed_out(req);
> -
> +	ignore_tout = mq->recovery_needed || !mq->use_cqe || host->hsq_enabled;
>  	spin_unlock_irqrestore(&mq->lock, flags);
>  
> -	return ret;
> +	return ignore_tout ? BLK_EH_RESET_TIMER : mmc_cqe_timed_out(req);
>  }
>  
>  static void mmc_mq_recovery_handler(struct work_struct *work)
> 

