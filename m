Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD1440E2B8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbhIPQlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:23135 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244426AbhIPQi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 12:38:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631810257; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=gVEj4dzgzrzJlW1qXcUVinQb3TzvihTAGFLdLH6ovGk=;
 b=dkvCEuWaIZ7iZ3kzGTHX1tv5tSkuhp20PqStELbPhyJth8Ic1Fc44A8Cp1ANBtXiTknrGDTx
 p+Dc/DQr3r1vZMzSvusAdFtVOjU8N48jJ7SrPBzxFjIf/w2RcJ0ZZASkte9YIQVE4i0OtJ30
 5LmL3I8h0V49PylrScXEso41P3M=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 614372b4e0f78151d62b4746 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 16 Sep 2021 16:37:08
 GMT
Sender: abhinavk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7EF53C447B6; Thu, 16 Sep 2021 16:37:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: abhinavk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76447C43637;
        Thu, 16 Sep 2021 16:37:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 16 Sep 2021 09:37:05 -0700
From:   abhinavk@codeaurora.org
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Rob Clark <robdclark@gmail.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "open list:DRM DRIVER FOR MSM ADRENO GPU" 
        <freedreno@lists.freedesktop.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [Freedreno] [PATCH] drm/msm: Do not run snapshot on non-DPU
 devices
In-Reply-To: <CAOMZO5CgFFmKmKF0C_1okmu7N24=udevT3LE=0bRoZqUeDQSWg@mail.gmail.com>
References: <20210914174831.2044420-1-festevam@gmail.com>
 <96038e06b1141ad3348611a25544356e@codeaurora.org>
 <CAOMZO5BzU3_x7nb8sEF_NDeDOxYM0bQLEpbRzv39jayX=fudYg@mail.gmail.com>
 <5409ccef7ee4359d070eed3acd955590@codeaurora.org>
 <CAOMZO5CgFFmKmKF0C_1okmu7N24=udevT3LE=0bRoZqUeDQSWg@mail.gmail.com>
Message-ID: <f027fcafc30d922b64f954de213a583d@codeaurora.org>
X-Sender: abhinavk@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Fabio

Ah, I did not realize that amd compatible is present in the list and its 
quite a surprise.

/*
  * We don't know what's the best binding to link the gpu with the drm 
device.
  * Fow now, we just hunt for all the possible gpus that we support, and 
add them
  * as components.
  */
static const struct of_device_id msm_gpu_match[] = {
	{ .compatible = "qcom,adreno" },
	{ .compatible = "qcom,adreno-3xx" },
	{ .compatible = "amd,imageon" },
	{ .compatible = "qcom,kgsl-3d0" },
	{ },
};

https://github.com/torvalds/linux/commit/e6f6d63ed14c20528aa6df05a8f0707c183c6ba3

For this change itself,
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>

On 2021-09-16 09:24, Fabio Estevam wrote:
> Hi Abhinav,
> 
> On Thu, Sep 16, 2021 at 1:15 PM <abhinavk@codeaurora.org> wrote:
>> 
>> Hi Fabio
>> 
>> Thanks for confirming.
>> 
>> Although I have no issues with your change, I am curious why even msm 
>> is
>> probing and/or binding.
>> Your device tree should not be having any mdp/dpu nodes then.
> 
> The i.MX53 does have the following GPU node:
> 
> compatible = "amd,imageon-200.0", "amd,imageon";
> 
> That's why it probes the msm driver.
> 
> However, i.MX53 does not have any of the Qualcomm display controllers.
> 
> It uses the i.MX IPU display controller instead.
> 
> Hope that clarifies.
> 
> Please reply with a Reviewed-by if you are happy with my fix.
> 
> Thanks
