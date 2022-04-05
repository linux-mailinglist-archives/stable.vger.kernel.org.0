Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3A44F47E0
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346475AbiDEVWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572990AbiDERmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 13:42:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD0CB91A9;
        Tue,  5 Apr 2022 10:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C87B2B81EE4;
        Tue,  5 Apr 2022 17:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE80C385A5;
        Tue,  5 Apr 2022 17:40:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="l5nk+/So"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649180419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g0RO67IsWiIRaN00UqFYvLKhwvI+fUHEG0ABd2diEis=;
        b=l5nk+/SosryNFeCI8Q3/zfn/1LKLIZ8iHNi0rWYpFF9VVP95xzSuUSaCeLdoYQkJEAW0tE
        kVmXmGeXBm9MymcZj9wHJdPoluQWl0OlJ0/plpBuDm6i+bOD2Xw0QNgqAXdr7H3fH6QB/T
        ELTGJJRAbEbfoYJuQprLKzX4+XLRzWg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 06d65d9d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Apr 2022 17:40:19 +0000 (UTC)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2eb3db5b172so98410467b3.6;
        Tue, 05 Apr 2022 10:40:18 -0700 (PDT)
X-Gm-Message-State: AOAM5329HlC9en2GZtJvQeYFLDdjfNZrykRp3x2o7tlluQxm5HqFxtaO
        z1r6Sw5l0lTxaIBWZkQB0qAFMwgYYKFU1a0NDG4=
X-Google-Smtp-Source: ABdhPJxggra8RefXSrqyMfsPxHjGbqamYdiF4pGdnuRqzip50DYJhkIIVyQbHYUw3VWFO95SfIXgZtdOlibRkkfvs9I=
X-Received: by 2002:a81:f00c:0:b0:2e9:d949:c189 with SMTP id
 p12-20020a81f00c000000b002e9d949c189mr3637965ywm.2.1649180418428; Tue, 05 Apr
 2022 10:40:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:470c:b0:173:a80b:3ec5 with HTTP; Tue, 5 Apr 2022
 10:40:17 -0700 (PDT)
In-Reply-To: <202204051016.4E9DD89@keescook>
References: <CAHmME9otYi4pCzZwSGnK40dp1QMRVPxp+DBysVuLXUKkXinAxg@mail.gmail.com>
 <20220403204036.1269562-1-Jason@zx2c4.com> <202204041144.96FC64A8@keescook>
 <Ykt1cj0wPKEsHL2q@zx2c4.com> <202204041953.D7E0BA15@keescook>
 <CAHmME9rC-pmi3K=w06-bOsHP5=tPv9CS51hr69P1C5tmvHf_mA@mail.gmail.com> <202204051016.4E9DD89@keescook>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 5 Apr 2022 19:40:17 +0200
X-Gmail-Original-Message-ID: <CAHmME9pV4SdoSyMq4kax3w3Vu1nPxjO3faCZKq8d0RDo8t731g@mail.gmail.com>
Message-ID: <CAHmME9pV4SdoSyMq4kax3w3Vu1nPxjO3faCZKq8d0RDo8t731g@mail.gmail.com>
Subject: Re: [PATCH v2] gcc-plugins: latent_entropy: use /dev/urandom
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>
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

Hi Kees,

On 4/5/22, Kees Cook <keescook@chromium.org> wrote:
> v3 uses a different check for the -f option, though? Isn't that
> preferred over the v2 method?

Based on the code comments, I assume this is gcc upstream's intended
method. It strikes me as worse, though, because that variable, when
it's not set to -1, is set to: `local_tick = (unsigned) tv.tv_sec *
1000 + tv.tv_usec / 1000;` which is on occasion unlucky and hits -1
too. But maybe that's a bug in gcc that should be fixed instead? I
don't know really. But anyway that's why I'm /also/ more into that
aspect of v2.

> Also, I did some quick benchmarking, and any difference in runtime is
> completely lost in the noise, so that's good.

Oh good to hear. So my 2k buffer is fine then.

Jason
