Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010DA4E5A99
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 22:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiCWV0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 17:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbiCWV0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 17:26:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD27819C0E
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:24:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e6-20020a17090a77c600b001c795ee41e9so2556526pjs.4
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=of3lS3C4xyqKKbsU+moSs1ikc61qhvqtQqy+wDAMLrQ=;
        b=uWtOwvftzxEvWzoBR1YkI6UbP8cyEw9daRerFL1t3O1UJ054Z8VWIZ4DH/7so5ciEo
         OoSmA2EVdDoX3joCf5B0+Sf/qg3ijZmLrSvSkHNodw5d/cq6n4EQ8EByH+LzljzaKsWP
         d1P2FBidP3lr4zGPtYoIT1rtdzOsi7YWwsulRVvnSb8kT01xtmX4xpvuHNNf4nt6E62V
         zib91ALn4/lOMfsciR1QtcafKJpXNiD4Eec2+XftShRxvfx5XevJ3smDMhSa3jDWBnlv
         oBVJ+JIhlO1APgPrtOMl7ijKrPOIvM/RNYTN4mNC8oK6vwD1VB7LjFL1HYtnhOSfzwUW
         +FxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=of3lS3C4xyqKKbsU+moSs1ikc61qhvqtQqy+wDAMLrQ=;
        b=A7+twEvbld6LV0zRwm+pul7+lC+oO0snj+9bYuCSXlPaIVNWSFqq63S2dL/POUSFFn
         b+tJYXPL7xBY8BqRKskZUzZ3bBWBnhVsz5Kh9zLUEZiwoKBxVv/f38ImzsQh4dcDImKX
         Q5DH1dW6XMwgn1hFiu2/EPHlnhOGfDPE3Be+YSEqyW2TgobzVmMQERlH98dMNanj+Hk5
         t4h76syivyAlhjotI1skzW+X94F5/X8ReIVysDtlyvtXgaHG71/bry8PeAwaGUh57cZy
         w/BRUk7L5oM7yT8qtSadsPvhdJH4sKAB7Q0Wb84Z9vs8bkHmtoKbKwKSRPkpl1A+zVzz
         3Hng==
X-Gm-Message-State: AOAM5326V9Gyi/feNCjbF04X7VU3fpOyDIdUnODzL9oGyPHqShPYYJ3t
        FVWzymY2hvZjJjaQKl7DXE55IjdK9jGfiRNA
X-Google-Smtp-Source: ABdhPJxMoT3Z5lzX6OXWoclx16yN+dNVohLYbuDtj12rl00xmU/H1qEDtkkDt5s6wgOLfGGS7YA0MQ==
X-Received: by 2002:a17:902:ea0c:b0:154:16a6:7025 with SMTP id s12-20020a170902ea0c00b0015416a67025mr2234091plg.104.1648070687213;
        Wed, 23 Mar 2022 14:24:47 -0700 (PDT)
Received: from ?IPV6:2600:380:6c2b:64bd:fe73:9dda:6321:7703? ([2600:380:6c2b:64bd:fe73:9dda:6321:7703])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm818008pfv.24.2022.03.23.14.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 14:24:46 -0700 (PDT)
Message-ID: <77fe836c-ee0e-1465-7469-46f202ad53e6@kernel.dk>
Date:   Wed, 23 Mar 2022 15:24:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL
 correctly
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20220323153947.142692-1-axboe@kernel.dk>
 <20220323153947.142692-2-axboe@kernel.dk>
 <64197456-87f2-e780-186d-272e06ae223b@gmail.com>
 <CAAL3td3_VFmOH1mNXiG6geFeONSm066Xba5ePqPwkMr-zxkDGg@mail.gmail.com>
 <fe48b17e-380f-7159-8c0c-d7c5208e61b2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fe48b17e-380f-7159-8c0c-d7c5208e61b2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/22 2:52 PM, Pavel Begunkov wrote:
> On 3/23/22 20:45, Constantine Gavrilov wrote:
>> On Wed, Mar 23, 2022 at 10:14 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 3/23/22 15:39, Jens Axboe wrote:
>>>> We currently don't attempt to get the full asked for length even if
>>>> MSG_WAITALL is set, if we get a partial receive. If we do see a partial
>>>> receive, then just note how many bytes we did and return -EAGAIN to
>>>> get it retried.
>>>>
>>>> The iov is advanced appropriately for the vector based case, and we
>>>> manually bump the buffer and remainder for the non-vector case.
>>>
>>> How datagrams work with MSG_WAITALL? I highly doubt it coalesces 2+
>>> packets to satisfy the length requirement (e.g. because it may move
>>> the address back into the userspace). I'm mainly afraid about
>>> breaking io_uring users who are using the flag just to fail links
>>> when there is not enough data in a packet.
>>>
>>> -- 
>>> Pavel Begunkov
>>
>> Pavel:
>>
>> Datagrams have message boundaries and the MSG_WAITALL flag does not
>> make sense there. I believe it is ignored by receive code on daragram
>> sockets. MSG_WAITALL makes sends only on stream sockets, like TCP. The
>> manual page says "This flag has  no  effect  for datagram sockets.".
> 
> Missed the line this in mans, thanks, and it's exactly as expected.
> The problem is on the io_uring side where with the patch it might
> blindly do a second call into the network stack consuming 2+ packets.

Right, it should not be applied for datagrams.

-- 
Jens Axboe

