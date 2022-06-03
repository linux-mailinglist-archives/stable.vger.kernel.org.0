Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B146153C6D2
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 10:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbiFCIRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 04:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiFCIRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 04:17:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9A91A3B6;
        Fri,  3 Jun 2022 01:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF3C1B82234;
        Fri,  3 Jun 2022 08:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0682C3411D;
        Fri,  3 Jun 2022 08:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654244267;
        bh=2qMPynZBosM10jO+yr/XLmcutWReS833WJBFW+WSiSo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g+8mYsocJRaKLYKShIYNDcySxhDG6hVYEqVhPVReyrqOMPQl5Zc7MuJQeBF7bBQ+x
         qQHzuKynIu+iHB7bFdSnJw0WlRrceXx1rTLDCFxZjTCRQ1AgTKdMlc242+G+/LIZdk
         uSciLXRGUj0TMMbzGccj0u6WJwQcKvwd3lyCRvRvsnFaq6L8SM7qObVnzKzZSMF1v5
         nJwM4qlFYyBzvwvY9WyS+E4bIfzrhY0PSUYyinMbj6OJAuNEiT4yAipQgDHh0VsKSP
         1eOBhefys6sfZo/vwG445Zkd5DKZ5MWrtG+uOu1/hqzeJSqJY5bjh5JaE4RXu1rFYh
         67sC8696/AF1w==
Received: by mail-oi1-f174.google.com with SMTP id s8so4285398oib.6;
        Fri, 03 Jun 2022 01:17:47 -0700 (PDT)
X-Gm-Message-State: AOAM533nMh5Ma7XO16iO+PdmwGZnOnJgk/1Ku6e1IZK0XpJBSpzVUJ8n
        DmCaGsIUkU1qgirvt72/Xe/m125huxaMlcCk9ZM=
X-Google-Smtp-Source: ABdhPJwrCo6AYGBI5AaR5v7gdia5kksMGs9NF1LFmT9bsHAhkXtG+9NUnLKDGQ8wg4DXlVbgSBD6zMtz6e/oPJhE3Yg=
X-Received: by 2002:a05:6808:300e:b0:32c:425e:df34 with SMTP id
 ay14-20020a056808300e00b0032c425edf34mr4775606oib.126.1654244266813; Fri, 03
 Jun 2022 01:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220602212234.344394-1-Jason@zx2c4.com> <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
 <CAHmME9otJN__Hq87JBiy7C_O6ZaFFFpBteuypML10BOAoZPBYw@mail.gmail.com>
 <CAMj1kXFJ2d-8aEV0-NNzXeL5qQO1JHdhqEDN+84DkA=8+jpoKg@mail.gmail.com> <CAHmME9o0+qC+qrCBoWp=FLcVABYrO+Bcihu_oWWaGJ3XuthseA@mail.gmail.com>
In-Reply-To: <CAHmME9o0+qC+qrCBoWp=FLcVABYrO+Bcihu_oWWaGJ3XuthseA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 3 Jun 2022 10:17:35 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGAf2twVczdxOCnYVPefnekT9U4J08+-5=GygAd7htDXg@mail.gmail.com>
Message-ID: <CAMj1kXGAf2twVczdxOCnYVPefnekT9U4J08+-5=GygAd7htDXg@mail.gmail.com>
Subject: Re: [PATCH] ARM: initialize jump labels before setup_machine_fdt()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Jun 2022 at 10:12, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Ard,
>
> On 6/3/22, Ard Biesheuvel <ardb@kernel.org> wrote:
> > The problem is that your original patch
>
> You remain extremely unpleasant to communicate with.

Noted.

> Can we keep
> things on topic please?
>

Sure. Are you saying the original patch is off-topic? Isn't that the
patch that caused the regression to begin with?

> > As far as I can tell, the early patching code on ARM does not rely on
> > the early fixmap code. Did you try just moving jump_label_init()
> > earlier in the function?
> >
> > Also, how did you test this change?
>
> Just booting a few configs in QEMU. I don't have access to real
> hardware right now unfortunately.
>
> Let me give a try to just moving the jump_label_init() function alone.
> That'd certainly make this patch a lot more basic, which would be a
> good thing, and might assuage your well justified concerns that too
> much boot order churn will break something subtle. I was just afraid
> of complicated intermingling with the other stuff after I saw that
> arm64 did things in the other order. But maybe that's silly.
>
> I'll send a v2 if that works, and send an update here if it doesn't.
> Thanks for the suggestion.
>
> Jason
