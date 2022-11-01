Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3488061447D
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 07:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKAGIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 02:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiKAGIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 02:08:24 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBDD13DC6
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 23:08:23 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id e2so6430177vkd.13
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 23:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ua5FVDFuWA4ML+Z6FKPFIkiRw5Q+9HqcyoXzwLEIt/M=;
        b=NegiWdsaynG96JcQSCQWjoqfqptXQ6RnsLRZ1Q2JmZXTKyJmBHCoSDH4rBzd2YgB6v
         4BMg2ZkiHQzBSFPsK3gRnWUbByE9UNFnKMjBD8BwLhiy4ohuyAas2x2lfkfmSnlTebWy
         iIbnaeF72gWQFQUI+I+qBLvxrNN4r2FqXzv1TjAosJ1MnIH9peEpEVsndU9UWQwPEe4n
         gUJefDPAoFU6pQTG7CsZG76C5uWKm5VhAHr8onoPEHB//2sfKfzWTbRwMiWzxN4Sihbn
         F5SwJybP3Xz2ai+GSvRtWHk09IgF9ssjNiAgPTd8X5GyLbLMvXpZRcLvey41u2RXxlFy
         h3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ua5FVDFuWA4ML+Z6FKPFIkiRw5Q+9HqcyoXzwLEIt/M=;
        b=S5Sm5HLdBuLSCj0eLmYD19eTBBLDJEw1aZga/4ecQpif148PCd48KHCKmlgH5jPvkv
         k/HvGykhhxq3Z+DL46qlBdLcIPhTtpX4LkfBQwxHnl5fcmePOORDuftsAQFHS1a1r3Su
         VXrMgucBRxKAuWmSCZBccN6qW34iwK+p2276KkKIMDzqPlHq9Kvy2XE0f65TFPX5adiZ
         TvQlWnlg0+CWLzA+RrFYNCP440rzj7u1wB7iOTRCYwwcAgINlKXg1Xl3RdRmPGrFyP8+
         2Q4nMCLL0DE0YgXESigaH4lyx5pAJc2uK78EyLdkWl93Ch2n1JyzQwB3+1iSmAxA8LpT
         Z2jA==
X-Gm-Message-State: ACrzQf3hZW7YlsdUY88gmAG2EipStuRECqolo7fNHawBUwfxUdjlZdDZ
        RsSkBQxk0a8TJ1UETJhXpkw3RCGQZ//voyRrXZBAmg==
X-Google-Smtp-Source: AMsMyM4EFV3ZLhsnVZMdqtDuxzf3/qJzItgirzInUNsCEQpERRym5uvAWBuY2oPaIphZWLBUR0rSt56nQMuyME4GMEE=
X-Received: by 2002:ac5:c213:0:b0:3b2:52ab:123f with SMTP id
 m19-20020ac5c213000000b003b252ab123fmr6715032vkk.13.1667282902832; Mon, 31
 Oct 2022 23:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221024112959.085534368@linuxfoundation.org> <20221024113002.025977656@linuxfoundation.org>
In-Reply-To: <20221024113002.025977656@linuxfoundation.org>
From:   Yongqin Liu <yongqin.liu@linaro.org>
Date:   Tue, 1 Nov 2022 14:07:35 +0800
Message-ID: <CAMSo37XApZ_F5nSQYWFsSqKdMv_gBpfdKG3KN1TDB+QNXqSh0A@mail.gmail.com>
Subject: Re: [PATCH 4.19 092/229] once: add DO_ONCE_SLOW() for sleepable contexts
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Benjamin Copeland <ben.copeland@linaro.org>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

As mentioned in the thread for the 5.4 version here[1], it causes a
crash for the 4.19 kernel too.
Just paste the log here for reference:

[ 1375.219830] wlan0: authenticate with 98:da:c4:4f:77:11
[ 1375.230257] wlan0: send auth to 98:da:c4:4f:77:11 (try 1/3)
[ 1375.262598] wlan0: authenticated
[ 1375.267766] wlan0: associate with 98:da:c4:4f:77:11 (try 1/3)
[ 1375.285716] wlan0: RX AssocResp from 98:da:c4:4f:77:11
(capab=0x1411 status=0 aid=1)
[ 1375.310066] wlan0: associated
[ 1375.332056] wlcore: Association completed.
[ 1376.105149] Unable to handle kernel write to read-only memory at
virtual address ffffff80092a6f18
[ 1376.114129] Mem abort info:
[ 1376.117072]   ESR = 0x9600004f
[ 1376.120138]   Exception class = DABT (current EL), IL = 32 bits
[ 1376.126091]   SET = 0, FnV = 0
[ 1376.129147]   EA = 0, S1PTW = 0
[ 1376.132301] Data abort info:
[ 1376.135176]   ISV = 0, ISS = 0x0000004f
[ 1376.139012]   CM = 0, WnR = 1
[ 1376.141997] swapper pgtable: 4k pages, 39-bit VAs, pgdp = 00000000a9880db2
[ 1376.148923] [ffffff80092a6f18] pgd=000000021fffe003,
pud=000000021fffe003, pmd=000000021fffb003, pte=00600000012a6793
[ 1376.159550] Internal error: Oops: 9600004f [#1] PREEMPT SMP
[ 1376.165119] Modules linked in:
[ 1376.168168] Process TlsVerify_100 (pid: 5454, stack limit =
0x0000000025f9c863)
[ 1376.175472] CPU: 5 PID: 5454 Comm: TlsVerify_100 Not tainted
4.19.262-g8479d939a3b0 #1
[ 1376.183381] Hardware name: HiKey960 (DT)
[ 1376.187295] pstate: 60400005 (nZCv daif +PAN -UAO)
[ 1376.192085] pc : __do_once_slow_done+0x14/0x98
[ 1376.196535] lr : __inet_hash_connect+0x480/0x484
[ 1376.201146] sp : ffffff800e203b80
[ 1376.204460] x29: ffffff800e203b80 x28: 0000000000000000
[ 1376.209768] x27: 0000000000006e48 x26: 0000000000000000
[ 1376.215071] x25: ffffff80098e6000 x24: 9b29771fbf0b881c
[ 1376.220375] x23: ffffff8009766600 x22: ffffff8009766bc0
[ 1376.225678] x21: ffffff8008c34198 x20: ffffff80098e65c0
[ 1376.230982] x19: ffffffc04cabd1c0 x18: 0000000005c65eec
[ 1376.236285] x17: 00000000175fece9 x16: 0000000071679066
[ 1376.241588] x15: 00000000467bf177 x14: 000000005f331e5c
[ 1376.246891] x13: 0000000000000014 x12: 00000000b82286ab
[ 1376.252194] x11: 0000000084c874ea x10: 00000000fdb36642
[ 1376.257497] x9 : 68962c3381a87000 x8 : 0000000000000001
[ 1376.262800] x7 : 0000000000000000 x6 : ffffffc2197c0000
[ 1376.268103] x5 : 000000008113af5d x4 : 0000000000000008
[ 1376.273406] x3 : 0000000000000030 x2 : 0000000000000000
[ 1376.278709] x1 : ffffff800976e568 x0 : ffffff80092a6f18
[ 1376.284012] Call trace:
[ 1376.286456]  __do_once_slow_done+0x14/0x98
[ 1376.290544]  __inet_hash_connect+0x480/0x484
[ 1376.294805]  inet_hash_connect+0x48/0x54
[ 1376.298720]  tcp_v4_connect+0x26c/0x3e4
[ 1376.302549]  __inet_stream_connect+0x2ac/0x308
[ 1376.306984]  inet_stream_connect+0x44/0x68
[ 1376.311072]  __sys_connect+0xb4/0x100
[ 1376.314725]  __arm64_sys_connect+0x1c/0x28
[ 1376.318816]  el0_svc_common+0xa4/0x188
[ 1376.322556]  el0_svc_handler+0x60/0x68
[ 1376.326298]  el0_svc+0x8/0x300
[ 1376.329345] Code: f9000bf5 a9024ff4 910003fd 52800028 (39000008)
[ 1376.335431] ---[ end trace 28410d3ffccfb491 ]---
[ 1376.351416] Kernel panic - not syncing: Fatal exception
[ 1376.356640] SMP: stopping secondary CPUs
[ 1376.360775] Kernel Offset: disabled
[ 1376.364257] CPU features: 0x10,20082004
[ 1376.368083] Memory Limit: none
[ 1376.382434] Rebooting in 5 seconds..

[1]: https://lore.kernel.org/lkml/20221029011211.4049810-1-ovt@google.com/

Thanks,
Yongqin Liu
