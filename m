Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFB7D0508
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 03:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfJIBIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 21:08:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55174 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbfJIBIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 21:08:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BD627609D1; Wed,  9 Oct 2019 01:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570583327;
        bh=bYjOELDTmiw0q27UcfMSd3+dbrYeqDhUhvNkC3AoPGo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=RZxu1lpRTYgTHOKizSOgdIt5xErmBAcmksKhD+IDtMptn2YwUlK7a0cjsTtdbSfgQ
         zMW7ft6xpVyiCqCQo++x0xOy6vWHs9AT2XnF1THdJwujfcdQSIo+LBvx/ZXBhuyOih
         UHN/3iEUg6B+yhbNacVVZAn1LPMeJr0tRq8qnNow=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from [192.168.142.6] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: clew@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D5BC960709;
        Wed,  9 Oct 2019 01:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570583327;
        bh=bYjOELDTmiw0q27UcfMSd3+dbrYeqDhUhvNkC3AoPGo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=RZxu1lpRTYgTHOKizSOgdIt5xErmBAcmksKhD+IDtMptn2YwUlK7a0cjsTtdbSfgQ
         zMW7ft6xpVyiCqCQo++x0xOy6vWHs9AT2XnF1THdJwujfcdQSIo+LBvx/ZXBhuyOih
         UHN/3iEUg6B+yhbNacVVZAn1LPMeJr0tRq8qnNow=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D5BC960709
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=clew@codeaurora.org
Subject: Re: [PATCH v2 5/6] rpmsg: glink: Don't send pending rx_done during
 remove
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191004222702.8632-1-bjorn.andersson@linaro.org>
 <20191004222702.8632-6-bjorn.andersson@linaro.org>
From:   Chris Lew <clew@codeaurora.org>
Message-ID: <3e4a7fe5-fc7a-b7d5-19bf-7fb8a26d8e55@codeaurora.org>
Date:   Tue, 8 Oct 2019 18:08:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004222702.8632-6-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/4/2019 3:27 PM, Bjorn Andersson wrote:
> Attempting to transmit rx_done messages after the GLINK instance is
> being torn down will cause use after free and memory leaks. So cancel
> the intent_work and free up the pending intents.
> 
> With this there are no concurrent accessors of the channel left during
> qcom_glink_native_remove() and there is therefor no need to hold the
> spinlock during this operation - which would prohibit the use of
> cancel_work_sync() in the release function. So remove this.
> 
> Fixes: 1d2ea36eead9 ("rpmsg: glink: Add rx done command")
> Cc: stable@vger.kernel.org
> Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---

Acked-By: Chris Lew <clew@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
