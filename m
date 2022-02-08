Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05A74AD1AA
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 07:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347598AbiBHGhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 01:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347556AbiBHGhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 01:37:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ED6C0401EF;
        Mon,  7 Feb 2022 22:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644302244; x=1675838244;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=DG+xa0PnRRQdvZ7t1yNYWlenZClK6CulMIOQACerRMg=;
  b=hqFa+b3lBeT4PwvSRhkviQrlp6vx6HN11nluqrdFgG0A7W1DmoepThbw
   KG9A0s5kBAFzdH+7+AFut8bj7ws0ENjjOwI95S/fcekUtnUCMzgM80f02
   anGLpSAl+iZsih31vQsGVVNM+RQg2sU1uizCq8Hi5qpePDaQdpOkWxPkf
   y+nzq946Lsa5gEbHetNPuDqwiasSs4YarOiDIHe9qvD88SA5e/JBWoXFk
   os8gYi2jsEXLj0mnuPmZPbZG3+6OVvzTKvO/tKd/MsHzYyMxIPPfULRHf
   5cedLJUGVge/ni+oJL2X5IwrXeaGGX/sOzY18DC05kl4tcLY/HZhbtR2A
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="273412483"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="273412483"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 22:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="632744902"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 07 Feb 2022 22:37:11 -0800
Subject: Re: [PATCHv2] mmc: block: fix read single on recovery logic
To:     =?UTF-8?Q?Christian_L=c3=b6hle?= <CLoehle@hyperstone.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <5e5f2e45d0a14a55a8b7a9357846114b@hyperstone.com>
 <7c4757cc707740e580c61c39f963a04d@hyperstone.com>
 <CAPDyKFr0YXCwL-8F9M7mkpNzSQpzw6gNUq2zaiJEXj1jNxUbrg@mail.gmail.com>
 <5c66833d-4b35-2c76-db54-0306e08843e5@intel.com>
 <79d44b0c54e048b0a9cc86319a24cc19@hyperstone.com>
 <bc706a6ab08c4fe2834ba0c05a804672@hyperstone.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <b047d374-c282-8c63-32c1-2135eec11fb6@intel.com>
Date:   Tue, 8 Feb 2022 08:37:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <bc706a6ab08c4fe2834ba0c05a804672@hyperstone.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/02/2022 17:11, Christian Löhle wrote:
> On reads with MMC_READ_MULTIPLE_BLOCK that fail,
> the recovery handler will use MMC_READ_SINGLE_BLOCK for
> each of the blocks, up to MMC_READ_SINGLE_RETRIES times each.
> The logic for this is fixed to never report unsuccessful reads
> as success to the block layer.
> 
> On command error with retries remaining, blk_update_request was
> called with whatever value error was set last to.
> In case it was last set to BLK_STS_OK (default), the read will be
> reported as success, even though there was no data read from the device.
> This could happen on a CRC mismatch for the response,
> a card rejecting the command (e.g. again due to a CRC mismatch).
> In case it was last set to BLK_STS_IOERR, the error is reported correctly,
> but no retries will be attempted.
> 
> Fixes: 81196976ed946c ("mmc: block: Add blk-mq support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Loehle <cloehle@hyperstone.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> v2:
>   - Do not allow data error retries
>   - Actually retry MMC_READ_SINGLE_RETRIES times instead of
>   MMC_READ_SINGLE_RETRIES-1
> 
> 
>  drivers/mmc/core/block.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index 4e61b28a002f..8d718aa56d33 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -1682,31 +1682,31 @@ static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
>  	struct mmc_card *card = mq->card;
>  	struct mmc_host *host = card->host;
>  	blk_status_t error = BLK_STS_OK;
> -	int retries = 0;
>  
>  	do {
>  		u32 status;
>  		int err;
> +		int retries = 0;
>  
> -		mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
> +		while (retries++ <= MMC_READ_SINGLE_RETRIES) {
> +			mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
>  
> -		mmc_wait_for_req(host, mrq);
> +			mmc_wait_for_req(host, mrq);
>  
> -		err = mmc_send_status(card, &status);
> -		if (err)
> -			goto error_exit;
> -
> -		if (!mmc_host_is_spi(host) &&
> -		    !mmc_ready_for_data(status)) {
> -			err = mmc_blk_fix_state(card, req);
> +			err = mmc_send_status(card, &status);
>  			if (err)
>  				goto error_exit;
> -		}
>  
> -		if (mrq->cmd->error && retries++ < MMC_READ_SINGLE_RETRIES)
> -			continue;
> +			if (!mmc_host_is_spi(host) &&
> +			    !mmc_ready_for_data(status)) {
> +				err = mmc_blk_fix_state(card, req);
> +				if (err)
> +					goto error_exit;
> +			}
>  
> -		retries = 0;
> +			if (!mrq->cmd->error)
> +				break;
> +		}
>  
>  		if (mrq->cmd->error ||
>  		    mrq->data->error ||
> 

