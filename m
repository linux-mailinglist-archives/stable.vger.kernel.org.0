Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACAF26977B
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 23:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINVNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 17:13:49 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:17962 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbgINVNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 17:13:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600118028; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=eP5pSacehjP1wjfJ5o8gJEuMAiQZyIXNv/QS66PVllQ=;
 b=PqFWq9PIfhfmwh9dQ/KVceg3qYwSlYWAzN3xFxm6VIyan5I1yu5XD/LIfqsJ/Z/WDhp6ZZFp
 6dEy0avV9KWMdj60LbxnZMHJWGJL8tiLGTK0ZIcDTAXx613tryvhkXu0m6oYzWwE6avbCkMl
 MeeW8uo2SMZiTqVNEuCGEV1Pbls=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f5fdd0b9f3347551f59ab9a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 14 Sep 2020 21:13:47
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AD721C433CA; Mon, 14 Sep 2020 21:13:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rishabhb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12EFFC433CA;
        Mon, 14 Sep 2020 21:13:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 14 Sep 2020 14:13:44 -0700
From:   rishabhb@codeaurora.org
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sidgup@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: pdr: Fixup array type of get_domain_list_resp
 message
In-Reply-To: <20200914145807.1224-1-sibis@codeaurora.org>
References: <20200914145807.1224-1-sibis@codeaurora.org>
Message-ID: <cac99ba16fc3e8f84ea2770e63988770@codeaurora.org>
X-Sender: rishabhb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-14 07:58, Sibi Sankar wrote:
> The array type of get_domain_list_resp is incorrectly marked as 
> NO_ARRAY.
> Due to which the following error was observed when using pdr helpers 
> with
> the downstream proprietary pd-mapper. Fix this up by marking it as
> VAR_LEN_ARRAY instead.
> 
> Err logs:
> qmi_decode_struct_elem: Fault in decoding: dl(2), db(27), tl(160), 
> i(1), el(1)
> failed to decode incoming message
> PDR: tms/servreg get domain list txn wait failed: -14
> PDR: service lookup for tms/servreg failed: -14
> 
> Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart 
> helpers")
> Reported-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> ---
>  drivers/soc/qcom/pdr_internal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/qcom/pdr_internal.h 
> b/drivers/soc/qcom/pdr_internal.h
> index 15b5002e4127b..ab9ae8cdfa54c 100644
> --- a/drivers/soc/qcom/pdr_internal.h
> +++ b/drivers/soc/qcom/pdr_internal.h
> @@ -185,7 +185,7 @@ struct qmi_elem_info 
> servreg_get_domain_list_resp_ei[] = {
>  		.data_type      = QMI_STRUCT,
>  		.elem_len       = SERVREG_DOMAIN_LIST_LENGTH,
>  		.elem_size      = sizeof(struct servreg_location_entry),
> -		.array_type	= NO_ARRAY,
> +		.array_type	= VAR_LEN_ARRAY,
>  		.tlv_type       = 0x12,
>  		.offset         = offsetof(struct servreg_get_domain_list_resp,
>  					   domain_list),
Tested-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
