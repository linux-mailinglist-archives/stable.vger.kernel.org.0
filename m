Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32F6364D3B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 23:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhDSVmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 17:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhDSVmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 17:42:39 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9783BC06174A
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 14:42:08 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id g9-20020a4ad3090000b02901ec6daba49aso1255360oos.6
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 14:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m0OqRlvNiEY/zXZRAt+l2/ZGIP7YrBXvHqjuguqGmio=;
        b=MB/udQoiWkac4AbkzgnDICtv/NNgru/bX4cp7JWMX/fBYEbfHnz/05CeCN7tWvsP/4
         Jo37q28JxhmI+6sr9qBeBRD8s7kx9+KjS9tKBDV+dXBMIFERlY+nPF5aT/GYdDvlwZ07
         p3Y3ta3Q66zMklr5cZYOVL+Si9uRqnYJjDty0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m0OqRlvNiEY/zXZRAt+l2/ZGIP7YrBXvHqjuguqGmio=;
        b=W9d5E4HJuKqKVBY80bDFuSo2wFT+hvkSDygGNHr4/KPplb7m/hoAk67C5IcQBwYAHO
         w+L1YGp79SbQFMHg9oA4r4+Snsdvha/rHaRsneICoV7O9HKiKRpRJ1GUwlSXtTezVK48
         PdijwLh5XbnmqBx0/g5OpUP7R/2vMI/Nb+sdS3+l2oYszo6l0q3OnvOFIReBhrmGGDAi
         8JOaPUdUsbxOcwTAB/qe7/NiY6KUP42vOh6Xxs31WOO7zlSd3UdGGjewzg8wbOr7qA0t
         uqbo2pnxpT8803rb5BILjXBC6Wuf9rIgphRj6qTMwJ5EoWi5KnGQBmwVij4j8N8vFoZh
         vPUw==
X-Gm-Message-State: AOAM532wGIEPD9tTlQQG4H9NcxDgBZVOiNttCij87qu0lqx9pSfHuJJe
        qlqhioCVPB4ky7YURWp8rsHwTA==
X-Google-Smtp-Source: ABdhPJyE7p5GOKoTREVaXsQoQ8F/ja64ZRGpxYd0T5frUG/QzkfRiTfTDkzv1e65ty2f0VDy6fmtIw==
X-Received: by 2002:a4a:e386:: with SMTP id l6mr589714oov.81.1618868527958;
        Mon, 19 Apr 2021 14:42:07 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w84sm3532890oig.20.2021.04.19.14.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 14:42:07 -0700 (PDT)
Subject: Re: [PATCH 1/4] usbip: add sysfs_lock to synchronize sysfs code paths
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tom Seewald <tseewald@gmail.com>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210416205319.14075-1-tseewald@gmail.com>
 <ea81015d-79f3-f22e-0b96-e0ae58acfc14@linuxfoundation.org>
 <YH12XjHqkH66HgdC@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9b401378-1acd-fd5b-a7b9-4ec6a1ee777f@linuxfoundation.org>
Date:   Mon, 19 Apr 2021 15:42:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YH12XjHqkH66HgdC@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/21 6:23 AM, Greg Kroah-Hartman wrote:
> On Fri, Apr 16, 2021 at 03:43:45PM -0600, Shuah Khan wrote:
>> On 4/16/21 2:53 PM, Tom Seewald wrote:
>>> From: Shuah Khan <skhan@linuxfoundation.org>
>>>
>>> commit 4e9c93af7279b059faf5bb1897ee90512b258a12 upstream.
>>>
>>> Fuzzing uncovered race condition between sysfs code paths in usbip
>>> drivers. Device connect/disconnect code paths initiated through
>>> sysfs interface are prone to races if disconnect happens during
>>> connect and vice versa.
>>>
>>> This problem is common to all drivers while it can be reproduced easily
>>> in vhci_hcd. Add a sysfs_lock to usbip_device struct to protect the paths.
>>>
>>> Use this in vhci_hcd to protect sysfs paths. For a complete fix, usip_host
>>> and usip-vudc drivers and the event handler will have to use this lock to
>>> protect the paths. These changes will be done in subsequent patches.
>>>
>>> Cc: stable@vger.kernel.org # 4.9.x
>>> Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>> Link: https://lore.kernel.org/r/b6568f7beae702bbc236a545d3c020106ca75eac.1616807117.git.skhan@linuxfoundation.org
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Signed-off-by: Tom Seewald <tseewald@gmail.com>
>>> ---
>>>    drivers/usb/usbip/usbip_common.h |  3 +++
>>>    drivers/usb/usbip/vhci_hcd.c     |  1 +
>>>    drivers/usb/usbip/vhci_sysfs.c   | 30 +++++++++++++++++++++++++-----
>>>    3 files changed, 29 insertions(+), 5 deletions(-)
>>>
>>
>> Thank you for the backport.
>>
>> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>> Greg, please pick this up for 4.9.x
> 
> Also for 4.14.y, right?
> 

It made it into 4.14 already. We are good with 4.14.y

5f2a149564ee2b41ab09e90add21153bd5be64d3

thanks,
-- Shuah




