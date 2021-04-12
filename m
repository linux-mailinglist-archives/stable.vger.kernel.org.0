Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED67235D11C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 21:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhDLTdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 15:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbhDLTdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 15:33:51 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291E4C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:33:33 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e14so737954ils.12
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HQINS80bHOCF7k5V4smlEz+II2WDETUJMN796G+XL/w=;
        b=MFFpyq24X/ewoxcRFTQvO6Ex0cqiaL8WwVTuMJYCqYrvViC1q0cmN1mwnw0vnT23Eh
         wwoqU2eAUI8mioPXMdotBLk4j0iNnj2XpLDA0tlniLZhy+ItQqVZYKVztO0giDQYgN48
         ql+2F8PtSOx2Bb6RLLNv0zCXj4EgArvLj45jk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HQINS80bHOCF7k5V4smlEz+II2WDETUJMN796G+XL/w=;
        b=dAlous3uumCHXBplfa1Rtiv/EGwEGecAz0dlCXsvecD3PDaNxMj62692uOCmRFw9/O
         eKAP48YgdHX8MiyfBcm1sOl2EzVD3I9O4YwH8d3Mk68TRtDnj9bjIVOm2ds8OMcrKW2A
         o6nSFbCc05Nno8EcL0daXOj8qT9rH4xn3CtAmMP5Jg+/ys6TCb5DQAyP5NDrPEtv6t45
         NWFBL6D10nMA9LU+M5kFWrxzqQDjpwQuQiJNHI12vRnPtqh+f3ilC7vrtM4GHBZGB1VZ
         wexAs9PymyvIePUW5ErFk75Ytop9udT+wVSW7fq03ixl0Km8jjqtoN+2f1yZ/zak3Ql2
         DGiw==
X-Gm-Message-State: AOAM532BN1lwvT13w+Px4VtNXj7ZoONhwBUCuY+stNakZWEFzWP9kSpV
        hOcj2bfFc3TaVn0GoQjRpSjf9w==
X-Google-Smtp-Source: ABdhPJyuHtL08l/Hnb0vcb/7J4G7UiJRWKHwHMeRpSn/iCDkcliLDf9ztOkbsiTB60G5H8XFA/ujFA==
X-Received: by 2002:a92:da4b:: with SMTP id p11mr24175333ilq.249.1618256012637;
        Mon, 12 Apr 2021 12:33:32 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 11sm6018839ilg.53.2021.04.12.12.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:33:32 -0700 (PDT)
Subject: Re: [PATCH] usbip: fix vudc usbip_sockfd_store races leading to gpf
To:     6f17ac98-5b23-3068-b6ec-4911273fe093@linuxfoundation.org
Cc:     tseewald@gmail.com,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210410004930.17411-1-tseewald@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3e8c8b04-c558-b7ca-5433-6e2a57ebff27@linuxfoundation.org>
Date:   Mon, 12 Apr 2021 13:33:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210410004930.17411-1-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/21 6:49 PM, Tom Seewald wrote:
> [backport of mainline commit 46613c9dfa96 ("usbip: fix vudc
> usbip_sockfd_store races leading to gpf") to 4.9 and 4.14]
> 
> usbip_sockfd_store() is invoked when user requests attach (import)
> detach (unimport) usb gadget device from usbip host. vhci_hcd sends
> import request and usbip_sockfd_store() exports the device if it is
> free for export.
> 
> Export and unexport are governed by local state and shared state
> - Shared state (usbip device status, sockfd) - sockfd and Device
>    status are used to determine if stub should be brought up or shut
>    down. Device status is shared between host and client.
> - Local state (tcp_socket, rx and tx thread task_struct ptrs)
>    A valid tcp_socket controls rx and tx thread operations while the
>    device is in exported state.
> - While the device is exported, device status is marked used and socket,
>    sockfd, and thread pointers are valid.
> 
> Export sequence (stub-up) includes validating the socket and creating
> receive (rx) and transmit (tx) threads to talk to the client to provide
> access to the exported device. rx and tx threads depends on local and
> shared state to be correct and in sync.
> 
> Unexport (stub-down) sequence shuts the socket down and stops the rx and
> tx threads. Stub-down sequence relies on local and shared states to be
> in sync.
> 
> There are races in updating the local and shared status in the current
> stub-up sequence resulting in crashes. These stem from starting rx and
> tx threads before local and global state is updated correctly to be in
> sync.
> 
> 1. Doesn't handle kthread_create() error and saves invalid ptr in local
>     state that drives rx and tx threads.
> 2. Updates tcp_socket and sockfd,  starts stub_rx and stub_tx threads
>     before updating usbip_device status to SDEV_ST_USED. This opens up a
>     race condition between the threads and usbip_sockfd_store() stub up
>     and down handling.
> 
> Fix the above problems:
> - Stop using kthread_get_run() macro to create/start threads.
> - Create threads and get task struct reference.
> - Add kthread_create() failure handling and bail out.
> - Hold usbip_device lock to update local and shared states after
>    creating rx and tx threads.
> - Update usbip_device status to SDEV_ST_USED.
> - Update usbip_device tcp_socket, sockfd, tcp_rx, and tcp_tx
> - Start threads after usbip_device (tcp_socket, sockfd, tcp_rx, tcp_tx,
>    and status) is complete.
> 
> Credit goes to syzbot and Tetsuo Handa for finding and root-causing the
> kthread_get_run() improper error handling problem and others. This is a
> hard problem to find and debug since the races aren't seen in a normal
> case. Fuzzing forces the race window to be small enough for the
> kthread_get_run() error path bug and starting threads before updating the
> local and shared state bug in the stub-up sequence.
> 
> Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
> Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
> Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
> Cc: stable@vger.kernel.org

Thanks for helping with this backport.

Please add the stables it fixes here:
Cc: stable@vger.kernel.org # 4.14.x # # 4.9.x

Combine this patch and the fix for this in the same.

9858af27e69247c5d04c3b093190a93ca365f33d
usbip: Fix incorrect double assignment to udc->ud.tcp_rx

thanks,
-- Shuah

thanks,
-- Shuah
