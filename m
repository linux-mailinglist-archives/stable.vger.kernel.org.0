Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E659362A8B
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 23:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244605AbhDPVqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 17:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244999AbhDPVqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 17:46:13 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33394C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:45:48 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id a21so16214814oib.10
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1YHh7U8wc7ySKZsKh9AlRP2v/SqTpovhR3D9kMn9/X4=;
        b=YzyOyTtbrYnGkN7p/9o6umk6pvHYqsWUaalKUyFq37t2YTZVcW5i73ANjgL84rze37
         Os8xdKq6yu/pkG8vbivhc2Q4M2uYEPUdc48cRiBJrEgWhiFbRKno0+I08wbVGzRIjYhh
         /mGFJyfl2At4sqe+0+zUAMuWZnI/3kH8txYv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1YHh7U8wc7ySKZsKh9AlRP2v/SqTpovhR3D9kMn9/X4=;
        b=HESxczVMSIkSeyB+QI1L/CYJ/kRl+v5b4g7/b50WH59PzQzdTi1+Px/xWBUGDOTWfr
         XlDw9vGKtO1jzkEVl6nWYUZ9TmgrYphQEQEIAob+6zg4ujx2IUIrro+1PbB3aq3P+7w7
         aVLQsC4zeqSfKFjL50nx1l/y2k/YJ/DpKRnY6tI6JAkExvaKI32nvnCxCGI3sCBJIBPy
         jEWfGaZs0jZCuD6w9YUKPk7GpT0XQci0evaWQJK5Eb6KMnJeWAdiGjn84OIS05QdlRcF
         i/9ha8BuAQirMoNKlq2F/X+/QabW60Egj2Bj8LL2buROYxYaqebY1iSLR4Ul8O/rSOtp
         kG0w==
X-Gm-Message-State: AOAM5326fcd57K0larmviKB0UMqqDj7NiqTTSnU3DdC4j0KY1FhR/wjr
        /d8zINRrGHwyZP+An1J0R6vkIA==
X-Google-Smtp-Source: ABdhPJy15FhD+EKJbGGsKHCJeKawdrGmV+iepZkbUlCBSo+30P/KHU7Iz/gHfyGkjdb6pvzt1R7N5w==
X-Received: by 2002:aca:ad52:: with SMTP id w79mr7921076oie.148.1618609547637;
        Fri, 16 Apr 2021 14:45:47 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 38sm1641300oth.14.2021.04.16.14.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 14:45:47 -0700 (PDT)
Subject: Re: [PATCH 4/4] usbip: synchronize event handler with sysfs code
 paths
To:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210416205319.14075-1-tseewald@gmail.com>
 <20210416205319.14075-4-tseewald@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a2609fc2-2435-f948-668c-1da10e544c10@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 15:45:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210416205319.14075-4-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/21 2:53 PM, Tom Seewald wrote:
> From: Shuah Khan <skhan@linuxfoundation.org>
> 
> commit 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814 upstream.
> 
> Fuzzing uncovered race condition between sysfs code paths in usbip
> drivers. Device connect/disconnect code paths initiated through
> sysfs interface are prone to races if disconnect happens during
> connect and vice versa.
> 
> Use sysfs_lock to synchronize event handler with sysfs paths
> in usbip drivers.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Link: https://lore.kernel.org/r/c5c8723d3f29dfe3d759cfaafa7dd16b0dfe2918.1616807117.git.skhan@linuxfoundation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>   drivers/usb/usbip/usbip_event.c | 2 ++
>   1 file changed, 2 insertions(+)
> 

Thank you for the backport.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

Greg, please pick this up for 4.9.x

thanks,
-- Shuah
