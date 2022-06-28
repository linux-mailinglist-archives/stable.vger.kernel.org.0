Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D655EDAD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 21:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiF1TPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 15:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235763AbiF1TMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 15:12:36 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DD9366AA
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:12:03 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id s14so16119640ljs.3
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nFFSUfbIlnfGEOyywbDGgiZf7UOcQCwXH88vizRPb54=;
        b=QMGSWZMtfiJD3l0VtJHwCLztNiH9/QdWHd1qMkxVRBBfxwdZXg2eMFZDZjTdTy3ECw
         C/KQlSA3z+4RLgJA7MiVQuBx0uJwo8NS6prEyRSLqpmHd9wUj9d8X3SIPLb7KDavXMGp
         HFuF+E7rFfOqJ2ahYwZAlyA4WHHcH8+eJseap1Mn9SRHjTt5y9b2fQDyq+1E3DEPiE9E
         LE5iP3WMCbHmXpceA5Pv7TtH8lVuRbjeBDn2XfJAv74YdPKWXQRCk32wQKzxtwFb5nx0
         pSje8cLaIjnZEcJzX+X+TR63VDvW78xmRnegA3OqOwdyJ3ezc4AZLcl38Vl2dV9Fofl3
         VP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFFSUfbIlnfGEOyywbDGgiZf7UOcQCwXH88vizRPb54=;
        b=y9GV1tW6meClx0XPlsdXUmQhMEdtlONiucqTI+mr0Vp7C7I1gtbeyGJzDu8xKzKI7R
         A9m00gIc3hwXPlmlUSlyulkp25JOyFlpRrHK7kzfy3qZK0xGh5rtfH2UCbflF4M1Lefg
         r1sW8l/o+siWgJR6bz5SOT0aXukXetKBY37s7escBJaAIirCLM36dVYHg6B4Ai1jS9OG
         LvTWmiZKYMN8yshranIxsXJdmB+8x28mNldcEor42DoAzB29Hh+pS/LUhdDbpRkCyoHl
         5ad1tYXaFkmf5f9VACYmr+GRaxSSbT1rEqXAff97T2qK3kKlSmmvcLCvxBa6CJEhU57c
         /CmA==
X-Gm-Message-State: AJIora925ebfpaNp3egZw+HKHX+Qf8EBVf6W5Lztq28XjELfhcQ7UOuS
        s22YYXFI6u1y59NBibk/LEkF/clhcYH2StU74Cs5AQ==
X-Google-Smtp-Source: AGRyM1tKzrCGxL2pKnCFouk/qMWj7OnMdrj1Sp+cy9DCiQ5Llnl85UhvXElzp7m4kVPeXCxDXo9KHYgFQpyxMbkAuNQ=
X-Received: by 2002:a05:651c:d4:b0:25a:91c6:d9b1 with SMTP id
 20-20020a05651c00d400b0025a91c6d9b1mr10338005ljr.400.1656443521986; Tue, 28
 Jun 2022 12:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220627111927.641837068@linuxfoundation.org> <20220627111929.368555413@linuxfoundation.org>
 <6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com>
In-Reply-To: <6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 28 Jun 2022 12:11:50 -0700
Message-ID: <CAKwvOdm8UiY8CsqNgyoq4MdC2TbBj-1+cRE+fWZ9+vVBxNZz_Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 57/60] modpost: fix section mismatch check for
 exported init/exit sections
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jessica Yu <jeyu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 10:03 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 6/27/22 04:22, Greg Kroah-Hartman wrote:
> > From: Masahiro Yamada <masahiroy@kernel.org>
> >
> > commit 28438794aba47a27e922857d27b31b74e8559143 upstream.
> >
> > Since commit f02e8a6596b7 ("module: Sort exported symbols"),
> > EXPORT_SYMBOL* is placed in the individual section ___ksymtab(_gpl)+<sym>
> > (3 leading underscores instead of 2).
> >
> > Since then, modpost cannot detect the bad combination of EXPORT_SYMBOL
> > and __init/__exit.
> >
> > Fix the .fromsec field.
> >
> > Fixes: f02e8a6596b7 ("module: Sort exported symbols")
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This commit causes the following warning to show up on my kernel builds
> used for testing 5.4 stable candidates:
>
> WARNING: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section
> mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit
> to the function .init.text:drm_fb_helper_modinit()
> The symbol drm_fb_helper_modinit is exported and annotated __init
> Fix this by removing the __init annotation of drm_fb_helper_modinit or
> drop the export.

Thanks for the report. Looks like the patch is "working as intended."

It looks like drm_fb_helper_modinit was deleted outright in
commit bf22c9ec39da ("drm: remove drm_fb_helper_modinit")
in v5.12-rc1.

Florian, can you test if that cherry-picks cleanly and resolves the
issue for you?

Maybe let's check with Christoph if it's ok to backport bf22c9ec39da
to stable 5.10 and 5.4?

>
> The kernel configuration to reproduce this is located here (this is 5.10
> but works in 5.4 as well):
>
> https://gist.github.com/2c3e8edd5ceb089c8040db724073d941
>
> Same applies to the 5.10, 5.15 and 5.18 stable queues FWIW.
> --
> Florian



-- 
Thanks,
~Nick Desaulniers
