Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3224D3CF4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbiCIWcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238678AbiCIWco (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:32:44 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409C0121512
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 14:31:45 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u7so5213801ljk.13
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 14:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4je0unW4G5dhYAERbboQeaK3T2YDLbSq75BkxjOTCkc=;
        b=NvqzVrCnOoQt5ccdqtnDcaRXHev3N/fZfvAWcFnh1bTbxVAVYlSK/1PikemA2qT9jk
         m8Zz4PK09MV1rCbVfKku3JDVdun0GJbIht1p427qlROuJMB+VRHB8+bcQqya5vF8+bkV
         tFe/oiRBcvfRKEG/xcFzgb/UE23TJ5UDD+ovM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4je0unW4G5dhYAERbboQeaK3T2YDLbSq75BkxjOTCkc=;
        b=OEj04AiK9fNfr1O8KdYEnq0X5PnOXh5H8gc+irccc22SjsiMfS4mOszK1bLqu3+RTR
         uyb0EGpNzdRGi2DSI9bnbtC+XtQk2fPlxcmm8zCLTiJCzpQsbw1iIA0WBmwoCbkdryXZ
         7ekFwtxO1pb7jeSWZJs2L3v17c3CAQ6yjiWSa6s1nCvGhs8X5uOoZMXJvL7DxSgAO3Ne
         RvP1S7gVYLcwFPERSFBFx/XUGMb3+u5xeR21F2QWPd2a31iuncqaosqwabr4GakdHqes
         8gK/fbLWTZFbcSAKFfBJMb/p1FqTUmGsD1w0GSzUY6EwNQbRx5WeCPEX9RSH6TsHoLVh
         Asjw==
X-Gm-Message-State: AOAM532u1dTlFcX24ix7XSZ/3Yf4SifxKdUGeM8R7MoNru1RV8co5tJS
        c2vC0M2JIjzDwqf6Dk2U6a+yLb8s0X4EFEg4b2Y=
X-Google-Smtp-Source: ABdhPJweSVAmwK3esL0v4cOUJzKE4tLHcyfqcDFn/PxWkPFUo4Ve8djU1rP2NGp9MlquQfxKcil9RA==
X-Received: by 2002:a05:651c:203:b0:247:ff14:66f9 with SMTP id y3-20020a05651c020300b00247ff1466f9mr1108882ljn.393.1646865103448;
        Wed, 09 Mar 2022 14:31:43 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id m14-20020a19520e000000b0044824f72b1asm619658lfb.71.2022.03.09.14.31.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 14:31:41 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id 3so6298915lfr.7
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 14:31:41 -0800 (PST)
X-Received: by 2002:a05:6512:3049:b0:447:d55d:4798 with SMTP id
 b9-20020a056512304900b00447d55d4798mr1100238lfb.531.1646865100980; Wed, 09
 Mar 2022 14:31:40 -0800 (PST)
MIME-Version: 1.0
References: <20220309220726.1525113-1-nathan@kernel.org> <CAHk-=wi23APrArHX7bcrvKBDZYpHXbeyEW7dRsirwoSPCKgqJg@mail.gmail.com>
 <YikqFxHP+Y+lecbX@kroah.com>
In-Reply-To: <YikqFxHP+Y+lecbX@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Mar 2022 14:31:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=whAL3L9gTPp5y7-dweM1xrOA+7aCtG9BvbeQk6Gaz-1UA@mail.gmail.com>
Message-ID: <CAHk-=whAL3L9gTPp5y7-dweM1xrOA+7aCtG9BvbeQk6Gaz-1UA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Do not use NOCROSSREFS directive with ld.lld
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 2:28 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> What about this one too:
>         https://lore.kernel.org/r/20220309191633.2307110-1-nathan@kernel.org
>
> it should fix a arm64 build with clang.

Heh. That one just came as a pull from Catalin. It's now commit 52c9f93a9c48..

            Linus
