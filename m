Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21F5BD234
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 18:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiISQ2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 12:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiISQ2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 12:28:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52903B955;
        Mon, 19 Sep 2022 09:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B37CB8092F;
        Mon, 19 Sep 2022 16:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE64C433D6;
        Mon, 19 Sep 2022 16:28:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LmjwV6P5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663604888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mzIuO+PPHAJODhYz0UIsdnwQnh/lTMcw4ADjrjKbYRQ=;
        b=LmjwV6P5ln/Ta8aryqqnTZQ+pdl7pz/qmVuTUbqx9VB/GJf8hy+yjvH9ZiVnV4dPXvQJRN
        FbMQit2/JYAs9oN1ByiEB7DTGsmocp9F4KBTp+AaJ/B6Jg0BdAD9kAUyfkdJ0N1oauRiX1
        z8E04Ll5pZHEBKLTNyzXNFU60HNdQ+0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 39144411 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 19 Sep 2022 16:28:08 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id a129so188323vsc.0;
        Mon, 19 Sep 2022 09:28:08 -0700 (PDT)
X-Gm-Message-State: ACrzQf0QiJIXb1JjG1qnLTLd56u4JvNnJ4ZwekMJMwEgpjToQymZi7Ca
        vURBRZZga1NmgNGucagH+f/f2qPSjmBP1KSTQ1g=
X-Google-Smtp-Source: AMsMyM4SnOpCSj+c5nOtMeOdRxyImNPudt8HErqP0QjJgqG0kpDuRNDeIZ8a7NuyoViKF6iRD6QCE8uChclZyE93xEQ=
X-Received: by 2002:a67:e401:0:b0:398:89f1:492f with SMTP id
 d1-20020a67e401000000b0039889f1492fmr7137283vsf.21.1663604887392; Mon, 19 Sep
 2022 09:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220919160931.2945427-1-ardb@kernel.org> <20220919160931.2945427-2-ardb@kernel.org>
In-Reply-To: <20220919160931.2945427-2-ardb@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 19 Sep 2022 18:27:56 +0200
X-Gmail-Original-Message-ID: <CAHmME9rqcTUHt8Z2Ad_SenH_QMnsA4vSroRsh1YPm+FKgWC2yA@mail.gmail.com>
Message-ID: <CAHmME9rqcTUHt8Z2Ad_SenH_QMnsA4vSroRsh1YPm+FKgWC2yA@mail.gmail.com>
Subject: Re: [PATCH 1/3] efi: random: reduce seed size to 32 bytes
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 19, 2022 at 6:09 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> We no longer need at least 64 bytes of random seed to permit the early
> crng init to complete. The RNG is now based on Blake2s, so reduce the
> EFI seed size to the Blake2s hash size, which is sufficient for our
> purposes.
>
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
