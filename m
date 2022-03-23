Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADD24E5A3A
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244734AbiCWUzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244002AbiCWUzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:55:10 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A072C86E03;
        Wed, 23 Mar 2022 13:53:39 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y10so3317987edv.7;
        Wed, 23 Mar 2022 13:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KswJYkeDzz/VK2u33TT6uHd9UrUCQqzNCu2683hwwTs=;
        b=apEJqpTTFV7dEV+z1gKpXKVqKdFX5ZsQ1nOzib60axZeUtOtMNm42hTrBSa0xSXscT
         LtReXE05qRvdcbsUq/zZxnoVdIxVPPvktucme829bK2vMfqhpPAzoZJTfOWup/UTLKfw
         4ZjOL43dYhf5S7D8y+YwgIhE8I7k7H/m383faNYqpq5PfJOFam6U+1RFmmcmnsFLggbL
         5CTXJVZUk7AbqIFtz3IOQYA56LRI8Db0QSHM7WfS+SrY8ELnGVnNNRgGNiV+jgZiKno+
         5PLKGQFSeL6R2i0uwidvYeE0HwJRlCZrYA4Odb1oxU1JecIS8a01eSR7GY3ZcAth+hlN
         PSqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KswJYkeDzz/VK2u33TT6uHd9UrUCQqzNCu2683hwwTs=;
        b=QhT0He03ASS/7/U/J86UGJZm6avgj7GIn8cujJPytI9nmjeodaTBF7tXJjpuKvQacV
         xCmwzTwBGIo3accOrEMNzdr96W90DwCVsVLSGNLELjNbZdbIp/Se+PASvMZ8Gi5xHL17
         cT2HwIpJXwEyLWUmtV+w+P3SI7491cxvQ5cXF7gVTbxEmczQSmQYzoy+SjREI+hbjO2o
         hmKbPAAeezj5UeYDEXIME+nDqa6sFrWkLv85EH/plVNDrCPC9e+iGPOpx4gXhj7hMwqO
         UfYEMOfGoWg3ZJcqTzZsvTMbWkQtxEz3wrJX1CXx+OPPJyYDkL3aYMknJfg+pC4ehHFD
         BGJA==
X-Gm-Message-State: AOAM531wCdPnl/9aLWqCqdnnIlFatHfpMcdGnrCa0+sy154XpjJbus56
        vt1YOmnVJ46OOZqqAGk0oCG5YBlBG4vSyA==
X-Google-Smtp-Source: ABdhPJw7s/o+qoCLFN6GNRA2ga8Jhpw1+ASDi7e/xnTGOhNpZ7qhYUW5T6+uztLAPLTQn9Ufc+pPoA==
X-Received: by 2002:a05:6402:209:b0:416:5211:841f with SMTP id t9-20020a056402020900b004165211841fmr2615362edv.59.1648068818246;
        Wed, 23 Mar 2022 13:53:38 -0700 (PDT)
Received: from [192.168.1.114] ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id jg15-20020a170907970f00b006e0466dcc42sm353429ejc.134.2022.03.23.13.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 13:53:37 -0700 (PDT)
Message-ID: <fe48b17e-380f-7159-8c0c-d7c5208e61b2@gmail.com>
Date:   Wed, 23 Mar 2022 20:52:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL
 correctly
Content-Language: en-US
To:     Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        stable@vger.kernel.org
References: <20220323153947.142692-1-axboe@kernel.dk>
 <20220323153947.142692-2-axboe@kernel.dk>
 <64197456-87f2-e780-186d-272e06ae223b@gmail.com>
 <CAAL3td3_VFmOH1mNXiG6geFeONSm066Xba5ePqPwkMr-zxkDGg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAAL3td3_VFmOH1mNXiG6geFeONSm066Xba5ePqPwkMr-zxkDGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/22 20:45, Constantine Gavrilov wrote:
> On Wed, Mar 23, 2022 at 10:14 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 3/23/22 15:39, Jens Axboe wrote:
>>> We currently don't attempt to get the full asked for length even if
>>> MSG_WAITALL is set, if we get a partial receive. If we do see a partial
>>> receive, then just note how many bytes we did and return -EAGAIN to
>>> get it retried.
>>>
>>> The iov is advanced appropriately for the vector based case, and we
>>> manually bump the buffer and remainder for the non-vector case.
>>
>> How datagrams work with MSG_WAITALL? I highly doubt it coalesces 2+
>> packets to satisfy the length requirement (e.g. because it may move
>> the address back into the userspace). I'm mainly afraid about
>> breaking io_uring users who are using the flag just to fail links
>> when there is not enough data in a packet.
>>
>> --
>> Pavel Begunkov
> 
> Pavel:
> 
> Datagrams have message boundaries and the MSG_WAITALL flag does not
> make sense there. I believe it is ignored by receive code on daragram
> sockets. MSG_WAITALL makes sends only on stream sockets, like TCP. The
> manual page says "This flag has  no  effect  for datagram sockets.".

Missed the line this in mans, thanks, and it's exactly as expected.
The problem is on the io_uring side where with the patch it might
blindly do a second call into the network stack consuming 2+ packets.

-- 
Pavel Begunkov
