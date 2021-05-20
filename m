Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E188238B550
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 19:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhETRjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 13:39:42 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:45412 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234595AbhETRjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 13:39:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621532301; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=nLriIgWHIbCb7oQKXFd+r7F47RE5SfPuCnd0RQSTbk8=;
 b=C+nTm2eHFYPYJg+DPppfydLFDS5GPfgC03AopBrAgvjUaJFFlO/ZmrQ3zTe8t7r/AjKGQenf
 wR9TYSwgdEoemd2Hw/NDgXy+Uc6xNLo/Mil7HRgMqw7VAeVIxD1nDCGhz5y3bLhvnYoBM84m
 QBWEMVjVQBmXXdnUt57dOBaJ9LI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60a69e870d60c09896625a09 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 20 May 2021 17:38:15
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5F980C433F1; Thu, 20 May 2021 17:38:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A3CF6C433D3;
        Thu, 20 May 2021 17:38:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 May 2021 10:38:12 -0700
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, regressions@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [regressions] ath11k: v5.12.3 mhi regression
Organization: Qualcomm Innovation Center, Inc.
Reply-To: bbhatt@codeaurora.org
Mail-Reply-To: bbhatt@codeaurora.org
In-Reply-To: <87r1i1h9an.fsf@codeaurora.org>
References: <87v97dhh2u.fsf@codeaurora.org> <YKYzwBJNTy4Czd1A@kroah.com>
 <20210520104313.GA128703@thinkpad> <87r1i1h9an.fsf@codeaurora.org>
Message-ID: <3e8bac3b02e3549a55b7c9b78b699965@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-20 05:36 AM, Kalle Valo wrote:
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> 
>> On Thu, May 20, 2021 at 12:02:40PM +0200, Greg KH wrote:
>>> On Thu, May 20, 2021 at 12:47:53PM +0300, Kalle Valo wrote:
>>> > Hi,
>>> >
>>> > I got several reports that this mhi commit broke ath11k in v5.12.3:
>>> >
>>> > commit 29b9829718c5e9bd68fc1c652f5e0ba9b9a64fed
>>> > Author: Bhaumik Bhatt <bbhatt@codeaurora.org>
>>> > Date:   Wed Feb 24 15:23:04 2021 -0800
>>> >
>>> >     bus: mhi: core: Process execution environment changes serially
>>> >
>>> >     [ Upstream commit ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ]
>>> >
>>> > Here are the reports:
>>> >
>>> > https://bugzilla.kernel.org/show_bug.cgi?id=213055
>>> >
>>> > https://bugzilla.kernel.org/show_bug.cgi?id=212187
>>> >
>>> > https://bugs.archlinux.org/task/70849?project=1&string=linux
>>> >
>>> > Interestingly v5.13-rc1 seems to work fine, at least for me, though I
>>> > have not tested v5.12.3 myself. Can someone revert this commit in the
>>> > stable release so that people get their wifi working again, please?
>>> 
>>> How does the mhi bus code relate to a ath11k driver?  What bus is 
>>> that
>>> on?
>>> 
>> 
>> MHI is the transport used by the ath11k driver to work with the WLAN 
>> devices
>> over PCIe.
>> 
>> Regarding the bug, I'd suggest to wait for Bhaumik (the author of 
>> 29b9829718c5)
>> to comment on the possible commit which needs backporting from 
>> mainline.
> 
> Ok, but if a quick fix is not available I think we should just revert
> this in the stable releases. I also got a report that v5.11.21 is
> broken:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=213055#c11

Please pick [1] as the dependency to [ Upstream commit 
ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ].

That is missing in older kernels and did not get backported.
This explains why 5.13.x works.

Thanks,
Bhaumik
---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/bus/mhi/core?h=v5.13-rc2&id=4884362f6977fc05cbec736625665241c0e0732f
