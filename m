Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA17301AF7
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 10:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbhAXJ6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 04:58:54 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:21071 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbhAXJ6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 04:58:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611482307; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=ilR4s/TWNpVfP7W8T3hQ754m0bkh6+hMKCZTuAVkBPw=; b=Ortk5SBFuDMfJr6Hsk/qKLWBQGSp+xDVJp27OJriaB7bwVXwHr6nFe3LzO9TJJ1jvSsrJKuL
 HKE+f3SXHPZ2b6fj0cg0N63W/8JGsxEQlIWkiMV514EvUbztQKV9ARlD5Wog2KoO4tvcy2yO
 pXzLz4sZdjiKUwScg1KwDbWeeeU=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 600d44a9beacd1a252177576 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 24 Jan 2021 09:58:01
 GMT
Sender: gkohli=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1AE50C43461; Sun, 24 Jan 2021 09:58:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [136.185.226.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: gkohli)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC412C433ED;
        Sun, 24 Jan 2021 09:57:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC412C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=gkohli@codeaurora.org
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Denis Efremov <efremov@linux.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>
References: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
 <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
 <20210121140951.2a554a5e@gandalf.local.home>
 <021b1b38-47ce-bc8b-3867-99160cc85523@linux.com>
 <20210121153732.43d7b96b@gandalf.local.home> <YAqwD/ivTgVJ7aap@kroah.com>
 <8e17ad41-b62b-5d39-82ef-3ee6ea9f4278@codeaurora.org>
 <20210122093758.320bb4f9@gandalf.local.home>
 <5959315a-507a-00df-031a-e60d45c1f7ab@linux.com>
 <46d1f82b-1eb4-a828-c79c-e6556eccf9d5@codeaurora.org>
 <20210123222147.1e2d5626@oasis.local.home>
From:   Gaurav Kohli <gkohli@codeaurora.org>
Message-ID: <76f4c576-0b34-6c52-0a93-c1d863052a80@codeaurora.org>
Date:   Sun, 24 Jan 2021 15:27:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210123222147.1e2d5626@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/24/2021 8:51 AM, Steven Rostedt wrote:
> On Sat, 23 Jan 2021 22:03:27 +0530
> Gaurav Kohli <gkohli@codeaurora.org> wrote:
> 
> 
>> Sure I will do, I have never posted on backport branches. Let me check
>> and post it.
>>
> 
> Basically you take your original patch that was in mainline (as the
> subject and commit message), and make it work as if you were doing the
> same exact fix for the stable release.
> 
> Send it to me (and Cc everyone else), and I'll give it a test too.

Thanks for the guidance.
Just sent and tested it for 5.4 kernel, please review it once.

> Thanks!
> 
> -- Steve
> 

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
