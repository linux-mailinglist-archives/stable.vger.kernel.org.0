Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA73B20AE
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFWS66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 14:58:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41054 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFWS65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 14:58:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624474600; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=raM5yy7Fixm9SBjgzY+GjFB9SPnrp4+WIjv/dKrKXH8=; b=N7YvZbyvKf25IkbWUZRCaicQo8k64OcXNWRFXH4APJ+WmGGBN+FIlaboA46kh2Obs3wv1C63
 o0HBCw+alEXc753OxcFrsxmBh/KTZuHUVXQEhiqSA/WrXD6u82Q3xLJhvqqEY1gKu2M5zh9d
 9h1WWBwgbQCAbcjUAA3D+jutSlY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60d383df638039e9976a6a49 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 18:56:31
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3EC04C43217; Wed, 23 Jun 2021 18:56:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [192.168.1.10] (cpe-75-83-25-192.socal.res.rr.com [75.83.25.192])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81904C433D3;
        Wed, 23 Jun 2021 18:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81904C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
Subject: Re: [PATCH v3 1/4] remoteproc: core: Move cdev add before device add
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
References: <1623723671-5517-1-git-send-email-sidgup@codeaurora.org>
 <1623723671-5517-2-git-send-email-sidgup@codeaurora.org>
 <YMgy7eg3wde0eVfe@kroah.com>
 <0a196786-f624-d9bb-8ef9-55c04ed57497@codeaurora.org>
 <YMmTGD6hAKbpGWMp@kroah.com>
 <f81acd52-fe59-a296-b221-febbf8281606@codeaurora.org>
 <YNLibU0/kMfZ3Hio@kroah.com>
From:   Siddharth Gupta <sidgup@codeaurora.org>
Message-ID: <7e8ee1c3-e11e-52fc-068d-34fe036e132f@codeaurora.org>
Date:   Wed, 23 Jun 2021 11:56:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNLibU0/kMfZ3Hio@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 6/23/2021 12:27 AM, Greg KH wrote:
> On Wed, Jun 16, 2021 at 11:47:01AM -0700, Siddharth Gupta wrote:
>> On 6/15/2021 10:58 PM, Greg KH wrote:
>>> On Tue, Jun 15, 2021 at 12:03:26PM -0700, Siddharth Gupta wrote:
>>>> On 6/14/2021 9:56 PM, Greg KH wrote:
>>>>> On Mon, Jun 14, 2021 at 07:21:08PM -0700, Siddharth Gupta wrote:
>>>>>> When cdev_add is called after device_add has been called there is no
>>>>>> way for the userspace to know about the addition of a cdev as cdev_add
>>>>>> itself doesn't trigger a uevent notification, or for the kernel to
>>>>>> know about the change to devt. This results in two problems:
>>>>>>     - mknod is never called for the cdev and hence no cdev appears on
>>>>>>       devtmpfs.
>>>>>>     - sysfs links to the new cdev are not established.
>>>>>>
>>>>>> The cdev needs to be added and devt assigned before device_add() is
>>>>>> called in order for the relevant sysfs and devtmpfs entries to be
>>>>>> created and the uevent to be properly populated.
>>>>> So this means no one ever ran this code on a system that used devtmpfs?
>>>>>
>>>>> How was it ever tested?
>>>> My testing was done with toybox + Android's ueventd ramdisk.
>>>> As I mentioned in the discussion, the race became evident
>>>> recently. I will make sure to test all such changes without
>>>> systemd/ueventd in the future.
>>> It isn't an issue of systemd/ueventd, those do not control /dev on a
>>> normal system, that is what devtmpfs is for.
>> I am not fully aware of when devtmpfs is enabled or not, but in
>> case it is not - systemd/ueventd will create these files with
>> mknod, right?
> No, systemd does not create device nodes, and neither does udev.  Hasn't
> done so for well over 10 years now.
Oh okay. I thought ueventd does it because it allows setting
the node permissions through ueventd.rc:
https://android.googlesource.com/platform/system/core/+/master/rootdir/ueventd.rc
>
>> I was even manually able to call mknod from the
>> terminal when some of the remoteproc character device entries
>> showed up (using major number from there, and minor number being
>> the remoteproc id), and that allowed me to boot up the
>> remoteprocs as well.
> Yes, that is fine, but that also means that this was not working from
> the very beginning :(
Right. To clarify, I did this after we started seeing the problem
on our devices, which led me to believe there was a race between
ueventd and cdev_add(). Not sure anymore if that is not the case.
>
>>> And devtmpfs nodes are only created if you create a struct device
>>> somewhere with a proper major/minor, which you were not doing here, so
>>> you must have had a static /dev on your test systems, right?
>> I am not sure of what you mean by a static /dev? Could you
>> explain? In case you mean the character device would be
>> non-functional, that is not the case. They have been working
>> for us since the beginning.
> /dev on modern systems is managed by devtmpfs, which knows to create the
> device nodes when you properly register the device with the driver core.
> A "static" /dev is managed by mknod from userspace, like you did "by
> hand", and that is usually only done by older systems.
Thanks for the explanation! As I mentioned earlier - I was under
the impression that ueventd does it. I will go through our older
builds where this was working (without this patch) and try to see
how the dev nodes were being populated.

Thanks,
Sid
> thanks,
>
> greg k-h
