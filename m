Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF41D04E7
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 02:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbfJIAvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 20:51:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbfJIAvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 20:51:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5626160ACE; Wed,  9 Oct 2019 00:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570582266;
        bh=wMnZ8fLHDZFet4l9bJ3Rw5WAlIMaGnOLPYeJsWDcHCA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WsBkMIBO98XA9963iQk4siAlnZOgCQipbkIGYu091tX862q5oSnnWqlU5Ad2b5CR9
         M+aqdoMNn99wixGIQamzMa3QwZkJENkpVp6BbBuYuj7r+5zciZ1V/mT1TsPDaK9O7S
         yvMsMx4wmEznowFEyE7yXcl/I98H5pfmRMfr5WCk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7AD3C6070D;
        Wed,  9 Oct 2019 00:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570582265;
        bh=wMnZ8fLHDZFet4l9bJ3Rw5WAlIMaGnOLPYeJsWDcHCA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZVWG6qZ7u/O7PKUH9Fa/WFgf7mNVpxGuN3RqU3n4TmbHxTgQcUbcN6ry70ncnMNgm
         KRPNgKYHJWidgUgckaSSfPAg8flJYMT4CxvYmlELJ2M5GB1onVI6klWI03cMgjRWiw
         WTI4TDt30vegGTNGurFlxaSfYFtDdafusguo82ys=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7AD3C6070D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=clew@codeaurora.org
Subject: Re: [PATCH v2 2/6] rpmsg: glink: Fix use after free in open_ack
 TIMEOUT case
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191004222702.8632-1-bjorn.andersson@linaro.org>
 <20191004222702.8632-3-bjorn.andersson@linaro.org>
From:   Chris Lew <clew@codeaurora.org>
Message-ID: <3db040ee-6b0f-be45-0e23-ab65f16329b6@codeaurora.org>
Date:   Tue, 8 Oct 2019 17:51:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004222702.8632-3-bjorn.andersson@linaro.org>
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
> Extra channel reference put when remote sending OPEN_ACK after timeout
> causes use-after-free while handling next remote CLOSE command.
> 
> Remove extra reference put in timeout case to avoid use-after-free.
> 
> Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
> Cc: stable@vger.kernel.org
> Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---

Acked-By: Chris Lew <clew@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
