Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C874F362A81
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 23:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhDPVoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 17:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344525AbhDPVoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 17:44:12 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF68AC061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:43:46 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id i22so19586099ila.11
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MrvrCoukec2mikf7lxR3UC4kwK1l61Bdi8hFf84mons=;
        b=A4qUCrpOAgfxd6iPWyfejm38TI6W/c2v4wJWcdmlhGHr5lUjWiX53XGQb5SZRUP3km
         N69DCSvnU0wAAjeAOVMirvd1oeiAwQIWvQ+zWFWOAHp4Q+3zrmiOSbSUw05iQsKwy/z2
         0fvFJ4p3vC4xEyjUbVI7lsS5Fb2Sd9xTMsAMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MrvrCoukec2mikf7lxR3UC4kwK1l61Bdi8hFf84mons=;
        b=n2YiRjdfFAkxZXbCeORCzTYwB45HKMdrQT30RfGK78Pd+KwEDWJnLszWh4QaXxSsGk
         f0fTWewoIBaqZCoMyhKm6aSrmHsrdL2ykf+AVRHgF8egLtCEOnt16ZGpC0LQ5awktWvq
         e2esZT+rMFrZBVGNntLC1k2BTVu1+f1V9b0TGER+v9vjBtDhmLf8F0wC2qy4iOKKP/Vt
         1G0xos8/wXOdlCtQ59cdEjJdAITK1IzcmPDzeNZ8gcUwxIlmn76Rrx8UZjObdAxnEDpg
         Dr8KduL5vcWePh2q2A35Ajsf6vvY+xrMwl7vt7NwZDoMSvRwkkgbmmWipUqI7dZZsUJZ
         jINg==
X-Gm-Message-State: AOAM533n3aGlGLEh220JRfM9X1MKlPHuvhF7gMLj5BwpUOTtTSkuD8XK
        u4uVHW2Yjljp3ybTHXEw/SUTb6TQBKpugg==
X-Google-Smtp-Source: ABdhPJxn2NzTzg6kwbCOO+YdM7NNPI/V7gK9gd0b9vZcTaoG+sQaMJUQME4TS7mTIr/j2qusP2SZ3A==
X-Received: by 2002:a05:6e02:1ba5:: with SMTP id n5mr8336166ili.45.1618609426063;
        Fri, 16 Apr 2021 14:43:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l2sm3212692ilq.70.2021.04.16.14.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 14:43:45 -0700 (PDT)
Subject: Re: [PATCH 1/4] usbip: add sysfs_lock to synchronize sysfs code paths
To:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
References: <20210416205319.14075-1-tseewald@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ea81015d-79f3-f22e-0b96-e0ae58acfc14@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 15:43:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210416205319.14075-1-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/21 2:53 PM, Tom Seewald wrote:
> From: Shuah Khan <skhan@linuxfoundation.org>
> 
> commit 4e9c93af7279b059faf5bb1897ee90512b258a12 upstream.
> 
> Fuzzing uncovered race condition between sysfs code paths in usbip
> drivers. Device connect/disconnect code paths initiated through
> sysfs interface are prone to races if disconnect happens during
> connect and vice versa.
> 
> This problem is common to all drivers while it can be reproduced easily
> in vhci_hcd. Add a sysfs_lock to usbip_device struct to protect the paths.
> 
> Use this in vhci_hcd to protect sysfs paths. For a complete fix, usip_host
> and usip-vudc drivers and the event handler will have to use this lock to
> protect the paths. These changes will be done in subsequent patches.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Link: https://lore.kernel.org/r/b6568f7beae702bbc236a545d3c020106ca75eac.1616807117.git.skhan@linuxfoundation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>   drivers/usb/usbip/usbip_common.h |  3 +++
>   drivers/usb/usbip/vhci_hcd.c     |  1 +
>   drivers/usb/usbip/vhci_sysfs.c   | 30 +++++++++++++++++++++++++-----
>   3 files changed, 29 insertions(+), 5 deletions(-)
> 

Thank you for the backport.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

Greg, please pick this up for 4.9.x

thanks,
-- Shuah

