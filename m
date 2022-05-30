Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD1A53761E
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbiE3H4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 03:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiE3Hyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:54:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C461874DCC;
        Mon, 30 May 2022 00:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F5DCB80ABD;
        Mon, 30 May 2022 07:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E60C36AE5;
        Mon, 30 May 2022 07:54:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TRON//3W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653897270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kso+7cLff27bYNHkoanOeWCHCmy79ih2oiGLYCkUq1A=;
        b=TRON//3WYVNzRGi9O+v50V2LzrLDkFOXaO2aXucmslWQUAUmPaeYD9ulhLS9+OMD86mTpI
        QkqvLdVtN4IE9xN3jNd11y7CQSAK1wrPQLIUGlmeMbWE2VGXYKsqhEQATYXwYEaU67ua/J
        YeW8q9hT9jKlAJdVNdRy3iNdSLV3yGQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 72c78cc4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 30 May 2022 07:54:30 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id g4so4084139ybf.12;
        Mon, 30 May 2022 00:54:29 -0700 (PDT)
X-Gm-Message-State: AOAM530shtdXQjCBGYsyBbRWFNGkysaEoXjiEfUf0qdrzIIUCrLwLd4b
        T1aQMMhkqz1Jube2Dzvs0ONvaTsANuz4ckyYwTk=
X-Google-Smtp-Source: ABdhPJx7dVUM5BfHRcDWsIIwQ9vGrnY4/N6aGErCyIIhdwLPMk7vMBOqprO+vcobxdnL24gg016zccie6oVkdhur//k=
X-Received: by 2002:a25:890b:0:b0:659:b9d6:a134 with SMTP id
 e11-20020a25890b000000b00659b9d6a134mr15609765ybl.235.1653897269362; Mon, 30
 May 2022 00:54:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:6403:b0:17b:2ce3:1329 with HTTP; Mon, 30 May 2022
 00:54:28 -0700 (PDT)
In-Reply-To: <7719057c0de047ebacea46ab9588da44@AcuMS.aculab.com>
References: <YpCGQvpirQWaAiRF@zx2c4.com> <20220527081106.63227-1-Jason@zx2c4.com>
 <YpGeIT1KHv9QwF4X@sol.localdomain> <YpHx7arH4lLaZuhm@zx2c4.com>
 <YpJZqJd9j1gEOdTe@sol.localdomain> <7719057c0de047ebacea46ab9588da44@AcuMS.aculab.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 30 May 2022 09:54:28 +0200
X-Gmail-Original-Message-ID: <CAHmME9r5Fr4Zm585tLjv562kzB58iHjNjnRH8+YJ-3cY6b4WZg@mail.gmail.com>
Message-ID: <CAHmME9r5Fr4Zm585tLjv562kzB58iHjNjnRH8+YJ-3cY6b4WZg@mail.gmail.com>
Subject: Re: [PATCH crypto v2] crypto: blake2s - remove shash module
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        gaochao <gaochao49@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/22, David Laight <David.Laight@aculab.com> wrote:
> From: Eric Biggers
>> Sent: 28 May 2022 18:20
>>
>> On Sat, May 28, 2022 at 11:57:01AM +0200, Jason A. Donenfeld wrote:
>> > > Also, the wrong value is being passed for the 'inc' argument.
>> >
>> > Are you sure? Not sure I'm seeing what you are on first glance.
>>
>> Yes, 'inc' is the increment amount per block.  It needs to always be
>> BLAKE2S_BLOCK_SIZE unless a partial block is being processed.
>
> IIRC it isn't used for partial blocks.
> Which rather begs the question as to why it is a parameter at all.

Again, with blake2s, please send a patch if you think there's an
improvement to be made.

In this case, I don't think you're right. See blake2s_final.

Jason
