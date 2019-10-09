Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD2D04DE
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 02:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfJIAtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 20:49:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIAtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 20:49:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0206560ACA; Wed,  9 Oct 2019 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570582171;
        bh=H6YaNArkGuc3fuAMFOk1zbKLBbvYg8Y8HDQPakVxx04=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZdZLIS4Q8T7M7aCIdidVevKxJywkhvXp6g5dtBrNuNKwQlmDqgAnU6muc83VsK2H9
         BX9RmNBNHulMTmcxd4j7EVABSk1ff+LyGzxdVQU81Ol4POJr3f5GLBM86R/o7I+D/o
         u70siJ1WRb3dHSx3wWmSA7Oo7JdXURn9t38uff1k=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 59011602C8;
        Wed,  9 Oct 2019 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570582170;
        bh=H6YaNArkGuc3fuAMFOk1zbKLBbvYg8Y8HDQPakVxx04=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QLjzV1hlQo9QdIh7pR8i2L0CtssDRtDQaTOA+UelrN4QzEIoe3COu+w4mmMErzf9D
         UWvyzDgZ6oEOrqRyl1Tc1TQ/imfqq4V3F3fGhdX6gn3n7gUi3doi3F+5RrlOcekmR/
         khIv6Hn6IA/Vj1AIKQj/tROOXeZHhg9KJaVpGdNs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 59011602C8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=clew@codeaurora.org
Subject: Re: [PATCH v2 1/6] rpmsg: glink: Fix reuse intents memory leak issue
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191004222702.8632-1-bjorn.andersson@linaro.org>
 <20191004222702.8632-2-bjorn.andersson@linaro.org>
From:   Chris Lew <clew@codeaurora.org>
Message-ID: <22fc76bf-9d2e-f016-fb63-a481f69f0a6c@codeaurora.org>
Date:   Tue, 8 Oct 2019 17:49:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004222702.8632-2-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/4/2019 3:26 PM, Bjorn Andersson wrote:
> From: Arun Kumar Neelakantam <aneela@codeaurora.org>
> 
> Memory allocated for re-usable intents are not freed during channel
> cleanup which causes memory leak in system.
> 
> Check and free all re-usable memory to avoid memory leak.
> 
> Fixes: 933b45da5d1d ("rpmsg: glink: Add support for TX intents")
> Cc: stable@vger.kernel.org
> Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
> Reported-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---

Acked-By: Chris Lew <clew@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
