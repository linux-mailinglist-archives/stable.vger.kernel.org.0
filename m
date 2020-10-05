Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F735283C80
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 18:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgJEQ3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 12:29:42 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:29584 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbgJEQ3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 12:29:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601915381; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=H+2buxQSuVdWgYRyXWL2uJVH9fMAxkpKRLylSNxAjUs=; b=sJfSa2MZwzQUdty2tMnBgrLD8BeDx/rzSu1hFC0m4Q8ZUmjkg6w0KUCdUQ/4cWDrQgApn2YB
 l7ZlPTq+TmbZlXH/JdSF2gcHeVOid+mMSjEBUE/LCoognnYVMyvEs64B/u/v31kYaBDbsoe9
 XXvr2B5OF5zB+LxGJ531UP7n8MY=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f7b49d3d6d00c7a9ec5f02f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 05 Oct 2020 16:29:07
 GMT
Sender: gkohli=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6FB64C433CA; Mon,  5 Oct 2020 16:29:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [192.168.1.4] (unknown [122.183.41.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: gkohli)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1801C433CA;
        Mon,  5 Oct 2020 16:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1801C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=gkohli@codeaurora.org
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
References: <1600955705-27382-1-git-send-email-gkohli@codeaurora.org>
 <71b8fe4c-7be2-fe51-cd84-890320c98cda@codeaurora.org>
 <20201005102515.07859ddf@gandalf.local.home>
 <20201005102745.2e49bc42@gandalf.local.home>
From:   Gaurav Kohli <gkohli@codeaurora.org>
Message-ID: <6ebba9b9-0add-0313-3982-01031d946f44@codeaurora.org>
Date:   Mon, 5 Oct 2020 21:59:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201005102745.2e49bc42@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/5/2020 7:57 PM, Steven Rostedt wrote:
> On Mon, 5 Oct 2020 10:25:15 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Mon, 5 Oct 2020 10:09:34 +0530
>> Gaurav Kohli <gkohli@codeaurora.org> wrote:
>>
>>> Hi Steven,
>>>
>>> please let us know, if below looks good to you or need modifications.
>>
>> Strange, I don't have your original email in my inbox. I do have it in my
>> LKML folder, but that's way too big for me to read. I checked my server
>> logs. I found where I received this from LKML, but there's no log that I
>> received this directly.
>>
>> How are you sending out your patches? If it doesn't land in my inbox, I'll
>> never see it.
>>
> 
> BTW, this is the second time this has happened to me. The first time I
> assumed it may have been me accidentally deleting it. Now I'm thinking it's
> on your end.
> 
> I have yet to received a patch from you directly. Last time I had to pull
> it from my LKML folder after you replied to me (letting me know you sent
> it).
> 

> -- Steve
> 

Hi Steven,

I am using normal git send-email(never saw problem with this), Not sure 
what is wrong. In my older mail i have kept you in to and rest in cc.

Let me try to resent it.

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
