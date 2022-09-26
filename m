Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7DD5EADDF
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiIZRQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiIZRQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:16:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C5A9C7C3;
        Mon, 26 Sep 2022 09:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69D74B80B2B;
        Mon, 26 Sep 2022 16:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6091C433C1;
        Mon, 26 Sep 2022 16:29:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="O/Tc88/d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664209785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d4DV9wTuEJjheBMG0Eg7FLwxhDuhB/eZPPw0FP4drwA=;
        b=O/Tc88/dSjfhUHWSdcQWA1ThrISRbVofbHNARKY9w+DiJDNtvrjb/23D7kCoRchmCbZK+W
        pLCnxuUjr7BoQbtxUPyvcLb4lVeALUh5yeGCuQ/OVQj9AItuvrVKXdjZoOSiuy6Y1UxppN
        UP13V6Z3BDXOKlj6W/zC4mP9zsNyym8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bdac2e94 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 26 Sep 2022 16:29:45 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id o123so7137096vsc.3;
        Mon, 26 Sep 2022 09:29:45 -0700 (PDT)
X-Gm-Message-State: ACrzQf2nqWMObSPLEmv1jH70piPMVDYFJ/2jg7NgYoXy34I+jOO/PbRP
        RKTBD6PirvEM7TGX5W+DtZtAZCcycQJT+WUTct4=
X-Google-Smtp-Source: AMsMyM418km+LhCnTSA5bmqTFR50Nvqd/ot69V5TGWYFAPax3DEPsVlaMRHbSzpzIboMdzfJ8dysAiUw2ovv5RhaJFw=
X-Received: by 2002:a05:6102:1481:b0:39a:67f5:3096 with SMTP id
 d1-20020a056102148100b0039a67f53096mr8658192vsv.70.1664209784098; Mon, 26 Sep
 2022 09:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220926160332.1473462-1-Jason@zx2c4.com> <20220926092241.64f73e7420cea6b964f1f116@linux-foundation.org>
In-Reply-To: <20220926092241.64f73e7420cea6b964f1f116@linux-foundation.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 26 Sep 2022 18:29:32 +0200
X-Gmail-Original-Message-ID: <CAHmME9oJEMwO1NJ0m-J7yWwGrh8su51TB+pC8pGFYn2uE1xB5Q@mail.gmail.com>
Message-ID: <CAHmME9oJEMwO1NJ0m-J7yWwGrh8su51TB+pC8pGFYn2uE1xB5Q@mail.gmail.com>
Subject: Re: [PATCH] random: split initialization into early arch step and
 later non-arch step
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
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

On Mon, Sep 26, 2022 at 6:22 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 26 Sep 2022 18:03:32 +0200 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>
> > The full RNG initialization relies on some timestamps, made possible
> > with general functions like time_init() and timekeeping_init(). However,
> > these are only available rather late in initialization. Meanwhile, other
> > things, such as memory allocator functions, make use of the RNG much
> > earlier.
> >
> > So split RNG initialization into two phases. We can give arch randomness
> > very early on, and then later, after timekeeping and such are available,
> > initialize the rest.
> >
> > This ensures that, for example, slabs are properly randomized if RDRAND
> > is available. Another positive consequence is that on systems with
> > RDRAND, running with CONFIG_WARN_ALL_UNSEEDED_RANDOM=y results in no
> > warnings at all.
>
> Please give a full description of the user-visible runtime effects of
> this shortcoming.

Sure. I'll expand that paragraph to read:

This ensures that, for example, slabs are properly randomized if RDRAND
is available. Without this, CONFIG_SLAB_FREELIST_RANDOM=y loses a degree
of its security, because its random seed is potentially deterministic,
since it hasn't yet incorporated RDRAND. It also makes it possible to
use a better seed in kfence, which currently relies on only the cycle
counter.
Another positive consequence is that on systems with RDRAND, running
with CONFIG_WARN_ALL_UNSEEDED_RANDOM=y results in no warnings at all.
