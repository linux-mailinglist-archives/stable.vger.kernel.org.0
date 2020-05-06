Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985421C776B
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgEFRGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 13:06:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:50199 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgEFRGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 13:06:12 -0400
IronPort-SDR: jYsr5BRAERmabnP4Ig3OiKasNuJXhnWqOt/TNzbqMfhWRMi/9zj+lTLLNlAXxrtncWfFC4o8/v
 0FIqeTHTy9Qw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 10:06:11 -0700
IronPort-SDR: GOq6sHbpWl0hAI7nnkFqSmoHpX//b2n4UHYnpCorexV8zj5K42CJn3V1ngkjLCgf8KsshSvoDw
 GY5zAWmQbzKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="284690915"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.157]) ([10.237.72.157])
  by fmsmga004.fm.intel.com with ESMTP; 06 May 2020 10:06:08 -0700
Subject: Re: [PATCH V1 1/2] mmc: core: Check request type before completing
 the request
To:     Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        ulf.hansson@linaro.org
Cc:     stummala@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <1588775643-18037-1-git-send-email-vbadigan@codeaurora.org>
 <1588775643-18037-2-git-send-email-vbadigan@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e4f7515c-e52e-f909-174a-8835d7e9e445@intel.com>
Date:   Wed, 6 May 2020 20:06:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588775643-18037-2-git-send-email-vbadigan@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/05/20 5:34 pm, Veerabhadrarao Badiganti wrote:
> In the request completion path with CQE, request type is being checked
> after the request is getting completed. This is resulting in returning
> the wrong request type and leading to the IO hang issue.
> 
> ASYNC request type is getting returned for DCMD type requests.
> Because of this mismatch, mq->cqe_busy flag is never getting cleared
> and the driver is not invoking blk_mq_hw_run_queue. So requests are not
> getting dispatched to the LLD from the block layer.
> 
> All these eventually leading to IO hang issues.
> So, get the request type before completing the request.
> 
> Cc: <stable@vger.kernel.org> # v4.19+

The fixed commit was in 4.16

> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>

Fixes: 1e8e55b67030 ("mmc: block: Add CQE support")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Thank you for finding this!

> ---
>  drivers/mmc/core/block.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index 8499b56..c5367e2 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -1370,6 +1370,7 @@ static void mmc_blk_cqe_complete_rq(struct mmc_queue *mq, struct request *req)
>  	struct mmc_request *mrq = &mqrq->brq.mrq;
>  	struct request_queue *q = req->q;
>  	struct mmc_host *host = mq->card->host;
> +	enum mmc_issue_type issue_type = mmc_issue_type(mq, req);
>  	unsigned long flags;
>  	bool put_card;
>  	int err;
> @@ -1399,7 +1400,7 @@ static void mmc_blk_cqe_complete_rq(struct mmc_queue *mq, struct request *req)
>  
>  	spin_lock_irqsave(&mq->lock, flags);
>  
> -	mq->in_flight[mmc_issue_type(mq, req)] -= 1;
> +	mq->in_flight[issue_type] -= 1;
>  
>  	put_card = (mmc_tot_in_flight(mq) == 0);
>  
> 

