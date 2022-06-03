Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB8B53C6C8
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 10:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbiFCIM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 04:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiFCIM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 04:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B1E20F50;
        Fri,  3 Jun 2022 01:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CADA9B8222E;
        Fri,  3 Jun 2022 08:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C474C3411E;
        Fri,  3 Jun 2022 08:12:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BvS+UY8S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654243967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cp+q50RJ/J+jLT5bCGZYImfbQiAwy6ER+VrGCgIzXt4=;
        b=BvS+UY8SsHnwMpRt/Q8qSLybCqZSXLVnUYSNkC8VbJE629AsVMNQJhZA/tVmzZYef30DZr
        rpbtUYqbf/dSjGC/Zqyfi0617q7TeaxzYGgbtaHuQzvLSNWyfXz11CNZdIUshYTukfNk/r
        vzXCk8tBITSiophTSQ4EREVcy7Osz4s=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d9895c2e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 3 Jun 2022 08:12:47 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id i11so12442461ybq.9;
        Fri, 03 Jun 2022 01:12:46 -0700 (PDT)
X-Gm-Message-State: AOAM533qRLSD7e8tZXzO8fDllkjhIIfLd/OTnUYOcVrjcFCE3Iqwp0Ja
        wcjCOoVBwu1+anXPTMLmp3PqMz7o15YkHDowY7Q=
X-Google-Smtp-Source: ABdhPJzrhSCz7gBuCt8q4wzGb2/GphetcVIRLQlUxYaxaV1KkfGj7tdAWfj4OJmq0nWvT7bHOPKUFMHeDRRHBwHJHYs=
X-Received: by 2002:a5b:dcf:0:b0:64a:6923:bbba with SMTP id
 t15-20020a5b0dcf000000b0064a6923bbbamr10037670ybr.398.1654243965027; Fri, 03
 Jun 2022 01:12:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:6407:b0:181:6914:78f6 with HTTP; Fri, 3 Jun 2022
 01:12:44 -0700 (PDT)
In-Reply-To: <CAMj1kXFJ2d-8aEV0-NNzXeL5qQO1JHdhqEDN+84DkA=8+jpoKg@mail.gmail.com>
References: <20220602212234.344394-1-Jason@zx2c4.com> <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
 <CAHmME9otJN__Hq87JBiy7C_O6ZaFFFpBteuypML10BOAoZPBYw@mail.gmail.com> <CAMj1kXFJ2d-8aEV0-NNzXeL5qQO1JHdhqEDN+84DkA=8+jpoKg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 3 Jun 2022 10:12:44 +0200
X-Gmail-Original-Message-ID: <CAHmME9o0+qC+qrCBoWp=FLcVABYrO+Bcihu_oWWaGJ3XuthseA@mail.gmail.com>
Message-ID: <CAHmME9o0+qC+qrCBoWp=FLcVABYrO+Bcihu_oWWaGJ3XuthseA@mail.gmail.com>
Subject: Re: [PATCH] ARM: initialize jump labels before setup_machine_fdt()
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        "# 3.4.x" <stable@vger.kernel.org>
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

Hi Ard,

On 6/3/22, Ard Biesheuvel <ardb@kernel.org> wrote:
> The problem is that your original patch

You remain extremely unpleasant to communicate with. Can we keep
things on topic please?

> As far as I can tell, the early patching code on ARM does not rely on
> the early fixmap code. Did you try just moving jump_label_init()
> earlier in the function?
>
> Also, how did you test this change?

Just booting a few configs in QEMU. I don't have access to real
hardware right now unfortunately.

Let me give a try to just moving the jump_label_init() function alone.
That'd certainly make this patch a lot more basic, which would be a
good thing, and might assuage your well justified concerns that too
much boot order churn will break something subtle. I was just afraid
of complicated intermingling with the other stuff after I saw that
arm64 did things in the other order. But maybe that's silly.

I'll send a v2 if that works, and send an update here if it doesn't.
Thanks for the suggestion.

Jason
