Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F036B1C88CA
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 13:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgEGLs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 07:48:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:64619 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgEGLs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 07:48:26 -0400
IronPort-SDR: 0WDD4SYlelv/CMqDGbsa+Qd1M0WI661zriOKiJ/LvooJuDx2HTCleMYzxo4s8Xh6kVqvsU8E99
 JqfAMf+jr5cw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 04:48:24 -0700
IronPort-SDR: i8kWrQpgWn75L4Fe2QfqwBPYtA7TVrOdZfwcIB8+RUtpWKVTAnVGtzTQxXUsavF0TyDLC53E6+
 81IX49BuWPHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,363,1583222400"; 
   d="scan'208";a="339328430"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.157]) ([10.237.72.157])
  by orsmga001.jf.intel.com with ESMTP; 07 May 2020 04:48:21 -0700
Subject: Re: [PATCH V1 2/2] mmc: core: Fix recursive locking issue in CQE
 recovery path
To:     Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        ulf.hansson@linaro.org
Cc:     stummala@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Sarthak Garg <sartgarg@codeaurora.org>, stable@vger.kernel.org,
        Baolin Wang <baolin.wang@linaro.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andreas Koop <andreas.koop@zf.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1588775643-18037-1-git-send-email-vbadigan@codeaurora.org>
 <1588775643-18037-3-git-send-email-vbadigan@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <b4a01f2c-479a-2a23-58b7-64f16cbc17a2@intel.com>
Date:   Thu, 7 May 2020 14:48:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588775643-18037-3-git-send-email-vbadigan@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/05/20 5:34 pm, Veerabhadrarao Badiganti wrote:
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
> Cc: <stable@vger.kernel.org> # v4.19+
> Suggested-by: Sahitya Tummala <stummala@codeaurora.org>
> Signed-off-by: Sarthak Garg <sartgarg@codeaurora.org>
> ---
>  drivers/mmc/core/queue.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index 25bee3d..72bef39 100644
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
> @@ -131,12 +131,13 @@ static enum blk_eh_timer_return mmc_mq_timed_out(struct request *req,
>  
>  	spin_lock_irqsave(&mq->lock, flags);
>  
> -	if (mq->recovery_needed || !mq->use_cqe || host->hsq_enabled)
> +	if (mq->recovery_needed || !mq->use_cqe || host->hsq_enabled) {
>  		ret = BLK_EH_RESET_TIMER;
> -	else
> +		spin_unlock_irqrestore(&mq->lock, flags);
> +	} else {
> +		spin_unlock_irqrestore(&mq->lock, flags);
>  		ret = mmc_cqe_timed_out(req);
> -
> -	spin_unlock_irqrestore(&mq->lock, flags);
> +	}

This looks good, but I think there needs to be another change also.  I will
send a patch for that, but in the meantime maybe you could straighten up the
code flow through the spinlock e.g.

	spin_lock_irqsave(&mq->lock, flags);
	ignore = mq->recovery_needed || !mq->use_cqe || host->hsq_enabled;
	spin_unlock_irqrestore(&mq->lock, flags);

	return ignore ? BLK_EH_RESET_TIMER : mmc_cqe_timed_out(req);

And add a fixes tag.

>  
>  	return ret;
>  }
> 

