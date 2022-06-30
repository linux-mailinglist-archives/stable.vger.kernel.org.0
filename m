Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C955619A5
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiF3Lyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiF3Lyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:54:43 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BEA51B16
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:54:41 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-317710edb9dso176881557b3.0
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqMu6TnDTUYo4jpRTIV9by4lQ6wUk1JDW2u8ADGiuSk=;
        b=XRd4qsmdgaUgylYoEZZgBU2ZUyafs7VD5Crjq50xKhk69VDQItcF7eLocx3JTikaZQ
         PH9HriezDmBozy9BCdXyKw611bHVLCBiX5vjR8+gYyT3vd8MkQrLQEoU0dc6fMo3dujg
         G0ehal4bjjmNYUfpXuLSDuzYTzaLNeCnQUSgLOdWMOGkDvTd4IIqPoBr0Kmc4RwYEX5H
         LCW+k4YnJP0j3FC6Ezw1p17Tlu5NXG7I45vzv32lfbzdTsgtj5xiORUSOMXGZdLlUARZ
         iVmkqVYZioBjWMIR7IC6XcbEi5SorYNFF4E7xvhn381nfH35EAS2zkHBHVUKVaMk6tfQ
         yjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqMu6TnDTUYo4jpRTIV9by4lQ6wUk1JDW2u8ADGiuSk=;
        b=p2TeO0K1FwcsWYzL3+HLwOs3wdvS7OQYEgWEkz0XUZo96IbB1mjCxxaCnjaW3rrd2O
         UDKquxDdLntIhCm/mBgCtI+3By0U+usFJW+/MXR3/+qMe32Ixk2AoGKEVLoNk7BgbJNV
         eaH59k2X/adYgbf0AwzvLfISUzEtb47d/tsqmC+bVzQ7iDfbJJziq88NCStAlaxPPEnx
         1tyoPfA7lXL5U9AHOHIcI5dt/Fib5+gyIY5xj07BhyIHM8KrTooo5wTGGOKicjRAuUUE
         t844IGmMb+ctLJHNi+Kh0ez0ABq9qAPT/S/qVrLeaKhkEDPUQp6V05XIa/9kwIQYUW/t
         Wbuw==
X-Gm-Message-State: AJIora+r4CP/BJR+Wxaty+0NuVpFUhkUPj79OjCKCcQG+d8bWOUkuwy1
        tp95hito/nixzRBTIH2Yxs6jsiSwwkIEP1Jdn/UHWw==
X-Google-Smtp-Source: AGRyM1vDyk76/xXNMtQcXvUHUZxtvCHb7eQxbWaY1e08eFJwrY+SPU2m+2mhwHRWLMDyDAObPKPysKZ5XzgRwEIwX3k=
X-Received: by 2002:a0d:e20a:0:b0:317:ce36:a3a0 with SMTP id
 l10-20020a0de20a000000b00317ce36a3a0mr10336132ywe.448.1656590080905; Thu, 30
 Jun 2022 04:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220628151258.2582737-1-ardb@kernel.org>
In-Reply-To: <20220628151258.2582737-1-ardb@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 30 Jun 2022 13:54:29 +0200
Message-ID: <CACRpkdb0SeifFeha5pASWsr=x2Ew7qPwDx4fhtkG+i72UsLMXQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: alignment: advance IT state after emulating Thumb instruction
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 5:13 PM Ard Biesheuvel <ardb@kernel.org> wrote:

> After emulating a misaligned load or store issued in Thumb mode, we have
> to advance the IT state by hand, or it will get out of sync with the
> actual instruction stream, which means we'll end up applying the wrong
> condition code to subsequent instructions. This might corrupt the
> program state rather catastrophically.
>
> So borrow the it_advance() helper from the probing code, and use it on
> CPSR if the emulated instruction is Thumb.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

A genuine piece of art to track this down. Thanks!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
