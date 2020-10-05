Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FE6283D9D
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 19:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgJERjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 13:39:09 -0400
Received: from z5.mailgun.us ([104.130.96.5]:43552 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgJERjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 13:39:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601919548; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=eRf9jW9jS41DO7Op1A/0+/28Gl8ale7y2hjxzaxyung=; b=ix1h+RKS0uj90edN6S+ta393VUCAfQylStwd9nLdUuKFfAgkCQJP4FBodXRN8D5AlBf76YYa
 vz/9U7Jl5y8AJN6djpqB310ovDl/S7mxbCNAAeNtGQT350VW7JtZ6chvh2OqDAD/qg8Jhsum
 UwppQwxhkPxm0e+XC/MGE3Otocs=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f7b5a19bfed2afaa6152005 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 05 Oct 2020 17:38:33
 GMT
Sender: gkohli=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C79A3C433CA; Mon,  5 Oct 2020 17:38:32 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48C08C4344A;
        Mon,  5 Oct 2020 17:38:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 48C08C4344A
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
 <6ebba9b9-0add-0313-3982-01031d946f44@codeaurora.org>
 <20201005123204.46a1cfc4@gandalf.local.home>
From:   Gaurav Kohli <gkohli@codeaurora.org>
Message-ID: <a9c0c7fc-c5ca-c4b8-b91c-3bce64f0eab4@codeaurora.org>
Date:   Mon, 5 Oct 2020 23:08:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201005123204.46a1cfc4@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/5/2020 10:02 PM, Steven Rostedt wrote:
> On Mon, 5 Oct 2020 21:59:02 +0530
> Gaurav Kohli <gkohli@codeaurora.org> wrote:
> 
>> Hi Steven,
>>
>> I am using normal git send-email(never saw problem with this), Not sure
>> what is wrong. In my older mail i have kept you in to and rest in cc.
>>
>> Let me try to resent it.
> 
> The Cc is working (I got it in my LKML box), but I don't see any connection
> in my server. Note, the rostedt@goodmis.org is a server at my home.
> 
> -- Steve
> 

Thanks for update, i will verify my account settings and will send my 
patch tomorrow.
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
