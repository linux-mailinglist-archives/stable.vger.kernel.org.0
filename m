Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26364E59B4
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbiCWUQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344593AbiCWUQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:16:40 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF81389CEE
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:15:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p22so3109705iod.2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wedBhqcJdcVu7p/0RWF2zGAwkaQF6GJr0zGSEaeA+ig=;
        b=h4h0OyuF9A+hiMm5SvxpEMrOmlN9DQWTOMpfh4qfozWOj7Wbx4x+K6AA8pRjbtlQC6
         YDohkBTWoazVtIbTR2G3ic2LiyYRZRhUUbM0pwiiWB00dNw9o2jbRAIhOtfoPfsurtAd
         Ea1gCZ1HncncqrDYRCq+B9jSrUZGA99W+i/6nonod4XQxUXuqKKfOte55UZq3mzrLIsk
         TepDrfEHqhYobsZRJNTRLZGEWZvlWtb9ojJ/wSDkAd+kMm6lc6FhbPhrUyioqZPPD3Ye
         MCLceBRD685qXneMHmo955LkpfoS9dDvb41I0Ckdg73mbGhRzEfr5fJCk6jXYjBV3fAv
         qNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wedBhqcJdcVu7p/0RWF2zGAwkaQF6GJr0zGSEaeA+ig=;
        b=bQHuZLvK9wNPx3zXWq3oitAv0M/Py5sgQw+bb+HlOVUjXYfHY8k15//ihRxB7b3d8l
         8iN7c05qPxRpgPGY4dgGrbfuMh4KCFWT+m9L6T/jjEprMhOM7XwZl785FWN0dF4+K5G0
         hPFHjY0hCzQnIPfcoJ+Pvekla+o+oGSujBAlxMqgp3zJEjphqlvfqNSdxSu54/xBTAXF
         SW53B3tmwwou5RrmArtSyQCxF1ATHi72RwmSzkg2XCXxhOq8m6G/lGR4f9ppW+NBXklM
         tfL8ixKlBYXZMLUeyn2LkAhAUgjK1NOI//907eJOR46Vh/oG0jZKhlFNaSY7Tea8lhGg
         GwUg==
X-Gm-Message-State: AOAM532RVb8Rol6Hu0LxHyNekAcKZ9SmTchBTE5q1RaNQEdc74MMZWHU
        tcaVv4MPbivTeS9nxYLXAWZi4g==
X-Google-Smtp-Source: ABdhPJyqa4+kKlVxrJFtMd0TthrLcrlQaUkaM0jlCcx6i7quUIAIJZ38RrCrJIr8k087uEucxwXnEQ==
X-Received: by 2002:a05:6638:1249:b0:321:2e10:c276 with SMTP id o9-20020a056638124900b003212e10c276mr905988jas.304.1648066509122;
        Wed, 23 Mar 2022 13:15:09 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d8-20020a056e02214800b002c7bea34e3dsm480442ilv.46.2022.03.23.13.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 13:15:08 -0700 (PDT)
Message-ID: <c7e9520b-aeff-7592-8897-4c323f37f93b@kernel.dk>
Date:   Wed, 23 Mar 2022 14:15:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL
 correctly
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, stable@vger.kernel.org
References: <20220323153947.142692-1-axboe@kernel.dk>
 <20220323153947.142692-2-axboe@kernel.dk>
 <64197456-87f2-e780-186d-272e06ae223b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <64197456-87f2-e780-186d-272e06ae223b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/22 2:13 PM, Pavel Begunkov wrote:
> On 3/23/22 15:39, Jens Axboe wrote:
>> We currently don't attempt to get the full asked for length even if
>> MSG_WAITALL is set, if we get a partial receive. If we do see a partial
>> receive, then just note how many bytes we did and return -EAGAIN to
>> get it retried.
>>
>> The iov is advanced appropriately for the vector based case, and we
>> manually bump the buffer and remainder for the non-vector case.
> 
> How datagrams work with MSG_WAITALL? I highly doubt it coalesces 2+
> packets to satisfy the length requirement (e.g. because it may move
> the address back into the userspace). I'm mainly afraid about
> breaking io_uring users who are using the flag just to fail links
> when there is not enough data in a packet.

Yes was thinking that too, nothing is final yet.. Need to write a
SOCK_STREAM test case.

-- 
Jens Axboe

