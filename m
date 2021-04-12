Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADC035D175
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 21:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbhDLTtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 15:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbhDLTtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 15:49:18 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657D1C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:49:00 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id k25so14702729iob.6
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LqaUrM55rOrVTq5noqoieWzml4jKDjKEFk4bXFQ2ruc=;
        b=LkRtq6unHNfx94VvM097vys1ERhIecK0KvnsaJ2ypV+Y2ZKgKBp6SkXyXxS6Ldp8bk
         UqsyyrcOgU4H8zDsxCJiT/m1S6mCivixJ425C3TAQpgdLHwg+KoRqIoa6lVBKfBex70I
         bpfb99yK0gbR+RR7ox3udkPVm9DjGqYUFB6YQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LqaUrM55rOrVTq5noqoieWzml4jKDjKEFk4bXFQ2ruc=;
        b=S+i9cKNdruELS7FhOj150hP0HSe+tTRfFFm+tLRdifojRmWAFC1+cvpkoeFIwuPenJ
         Kosv0DaowpTukHOCN4y/fFPK3Q7+zTtuSBgIQxJrcouCIbFXvu0FZEOmVkLXJIzjdug5
         lS17yKdkCwo1qpXlD0dNo6PcTnBzqfli154Bwhyy8I7RRcV+XwmNTfKWmHjZsCU4hVSB
         Exle7JGhG6z0bNvmntDi3UNkFQ+k02f76Gdsh2ltRr4AXz3MH+KL1Hqs+9OHbAbjwWA4
         HCDgd4HTVZxHFimCzkdH2ajdP3+Nvoz1TT8ssFRXZ5REKkE8eUerc69BEsgBFiPDtP9u
         ++qQ==
X-Gm-Message-State: AOAM533M+IFMO6RN/Zivn0MQN1uuJD1zd63hs+3qdOVtl7il2jULq+vO
        488Y4vu+al6jzZSkcQTmr7wcrg==
X-Google-Smtp-Source: ABdhPJy5ghC3p0bjfCXKH1xrtcKPAry4uyoEk1R65Fu1YQ985J/xVUacyFRcqM/LPaHBQrDSSa4iuw==
X-Received: by 2002:a05:6638:3826:: with SMTP id i38mr7209551jav.141.1618256939491;
        Mon, 12 Apr 2021 12:48:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o13sm5795811iob.17.2021.04.12.12.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:48:59 -0700 (PDT)
Subject: Re: [PATCH] usbip: fix vudc usbip_sockfd_store races leading to gpf
To:     tseewald@gmail.com
Cc:     syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        6f17ac98-5b23-3068-b6ec-4911273fe093@linuxfoundation.org
References: <20210410004930.17411-1-tseewald@gmail.com>
 <3e8c8b04-c558-b7ca-5433-6e2a57ebff27@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7669c42d-5b1f-867f-9a1c-3e5a1077f232@linuxfoundation.org>
Date:   Mon, 12 Apr 2021 13:48:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <3e8c8b04-c558-b7ca-5433-6e2a57ebff27@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 1:33 PM, Shuah Khan wrote:
> On 4/9/21 6:49 PM, Tom Seewald wrote:
>> [backport of mainline commit 46613c9dfa96 ("usbip: fix vudc
>> usbip_sockfd_store races leading to gpf") to 4.9 and 4.14]
>>
>> usbip_sockfd_store() is invoked when user requests attach (import)
>> detach (unimport) usb gadget device from usbip host. vhci_hcd sends
>> import request and usbip_sockfd_store() exports the device if it is
>> free for export.
>>
>> Export and unexport are governed by local state and shared state
>> - Shared state (usbip device status, sockfd) - sockfd and Device
>>    status are used to determine if stub should be brought up or shut
>>    down. Device status is shared between host and client.
>> - Local state (tcp_socket, rx and tx thread task_struct ptrs)
>>    A valid tcp_socket controls rx and tx thread operations while the
>>    device is in exported state.
>> - While the device is exported, device status is marked used and socket,
>>    sockfd, and thread pointers are valid.
>>
>> Export sequence (stub-up) includes validating the socket and creating
>> receive (rx) and transmit (tx) threads to talk to the client to provide
>> access to the exported device. rx and tx threads depends on local and
>> shared state to be correct and in sync.
>>
>> Unexport (stub-down) sequence shuts the socket down and stops the rx and
>> tx threads. Stub-down sequence relies on local and shared states to be
>> in sync.
>>
>> There are races in updating the local and shared status in the current
>> stub-up sequence resulting in crashes. These stem from starting rx and
>> tx threads before local and global state is updated correctly to be in
>> sync.
>>
>> 1. Doesn't handle kthread_create() error and saves invalid ptr in local
>>     state that drives rx and tx threads.
>> 2. Updates tcp_socket and sockfd,  starts stub_rx and stub_tx threads
>>     before updating usbip_device status to SDEV_ST_USED. This opens up a
>>     race condition between the threads and usbip_sockfd_store() stub up
>>     and down handling.
>>
>> Fix the above problems:
>> - Stop using kthread_get_run() macro to create/start threads.
>> - Create threads and get task struct reference.
>> - Add kthread_create() failure handling and bail out.
>> - Hold usbip_device lock to update local and shared states after
>>    creating rx and tx threads.
>> - Update usbip_device status to SDEV_ST_USED.
>> - Update usbip_device tcp_socket, sockfd, tcp_rx, and tcp_tx
>> - Start threads after usbip_device (tcp_socket, sockfd, tcp_rx, tcp_tx,
>>    and status) is complete.
>>
>> Credit goes to syzbot and Tetsuo Handa for finding and root-causing the
>> kthread_get_run() improper error handling problem and others. This is a
>> hard problem to find and debug since the races aren't seen in a normal
>> case. Fuzzing forces the race window to be small enough for the
>> kthread_get_run() error path bug and starting threads before updating the
>> local and shared state bug in the stub-up sequence.
>>
>> Reported-by: syzbot 
>> <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
>> Reported-by: syzbot 
>> <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
>> Reported-by: syzbot 
>> <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
>> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
>> Cc: stable@vger.kernel.org
> 
> Thanks for helping with this backport.
> 
> Please add the stables it fixes here:
> Cc: stable@vger.kernel.org # 4.14.x # # 4.9.x
> 
> Combine this patch and the fix for this in the same.
> 
> 9858af27e69247c5d04c3b093190a93ca365f33d
> usbip: Fix incorrect double assignment to udc->ud.tcp_rx
> 

Please ignore the suggestion to combine. Greg already pulled
this patch. Sorry for the noise.

thanks,
-- Shuah
