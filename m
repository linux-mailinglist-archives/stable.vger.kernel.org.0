Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF076C99A5
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 04:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjC0CmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 22:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjC0CmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 22:42:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B5E44AF;
        Sun, 26 Mar 2023 19:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE7C8B80DA2;
        Mon, 27 Mar 2023 02:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1753C433A7;
        Mon, 27 Mar 2023 02:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679884930;
        bh=6VzDqX48Vl38IiLh2rkurFRzDn0V2PY1IZwfkVKLHBs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=le+wVaujnmigkIxLcC+BBlb+L/EMpxeO7Na5IaemZUVhnFs3HUxmNZHz7oPcctthu
         xKbTOv+VAm17PPXvskg+agwZs0QJhMklxMh7wf3BOpHkVrbgbEILQgzGLzYvOqQGUv
         e/poab9zYziebClPUO3ZyGyUhe8NMoonf9lc+0uyfnLM7t9JVXmEnuizf4bL/8xGdR
         2OxDPf0urRfD7akRCN+pa3di3mvIwCrXCnhr3DvnDUOx004YT6uAL7fifIWYlgoKVP
         Xj+euO8CwKwp5AMM/ca5VYm5y1nAOTrHQEQ4ZnqFpYT701MxbojYvK6BN3G8CgmxFs
         qK3ALWFQo7jAA==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-177ca271cb8so7837463fac.2;
        Sun, 26 Mar 2023 19:42:10 -0700 (PDT)
X-Gm-Message-State: AAQBX9cdghUpb2+P3PSNJUQs9t+NJwzO888YX/V+doubwvO+P9pzZna5
        SdFK6r75UYPDbJq9IqEVk+dESddmB4TO4g13rrw=
X-Google-Smtp-Source: AKy350bMxmeywLQZtcIhcbwfTUAlICv85a5HdlyEXx820LhBAGY0y4TcQppgHU2tLzA5NynqOEARjQGH1XU2iOfJIuY=
X-Received: by 2002:a05:6871:e86:b0:17e:d9e2:a55c with SMTP id
 vl6-20020a0568710e8600b0017ed9e2a55cmr3302021oab.11.1679884929854; Sun, 26
 Mar 2023 19:42:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230326182120.194541-1-hi@alyssa.is>
In-Reply-To: <20230326182120.194541-1-hi@alyssa.is>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 27 Mar 2023 11:41:33 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR6W9=dOwV8E=biPQ_KGF7LXcb2-6PdSevej7H0xs7EUA@mail.gmail.com>
Message-ID: <CAK7LNAR6W9=dOwV8E=biPQ_KGF7LXcb2-6PdSevej7H0xs7EUA@mail.gmail.com>
Subject: Re: [PATCH v2] purgatory: fix disabling debug info
To:     Alyssa Ross <hi@alyssa.is>
Cc:     Nick Cao <nickcao@nichi.co>, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-riscv@lists.infradead.org, Tom Rix <trix@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 27, 2023 at 3:23=E2=80=AFAM Alyssa Ross <hi@alyssa.is> wrote:
>
> Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> -Wa versions of both of those if building with Clang and GNU as.  As a
> result, debug info was being generated for the purgatory objects, even
> though the intention was that it not be.
>
> Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> Cc: stable@vger.kernel.org



Thanks, looks good to me.

I can offer to pick this up to my tree later,
but I will wait for Ack from the arch maintainers
and other comments.







> ---
>
> Difference from v2: replace each AFLAGS_REMOVE_* assignment with a
> single aflags-remove-y line, and use foreach to add the -Wa versions,
> as suggested by Masahiro Yamada.
>
>  arch/riscv/purgatory/Makefile | 7 +------
>  arch/x86/purgatory/Makefile   | 3 +--
>  2 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefil=
e
> index d16bf715a586..5730797a6b40 100644
> --- a/arch/riscv/purgatory/Makefile
> +++ b/arch/riscv/purgatory/Makefile
> @@ -84,12 +84,7 @@ CFLAGS_string.o                      +=3D $(PURGATORY_=
CFLAGS)
>  CFLAGS_REMOVE_ctype.o          +=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_ctype.o                 +=3D $(PURGATORY_CFLAGS)
>
> -AFLAGS_REMOVE_entry.o          +=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memcpy.o         +=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memset.o         +=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strcmp.o         +=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strlen.o         +=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strncmp.o                +=3D -Wa,-gdwarf-2
> +asflags-remove-y               +=3D $(foreach x, -g -gdwarf-4 -gdwarf-5,=
 $(x) -Wa,$(x))
>
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>                 $(call if_changed,ld)
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 17f09dc26381..82fec66d46d2 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -69,8 +69,7 @@ CFLAGS_sha256.o                       +=3D $(PURGATORY_=
CFLAGS)
>  CFLAGS_REMOVE_string.o         +=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_string.o                        +=3D $(PURGATORY_CFLAGS)
>
> -AFLAGS_REMOVE_setup-x86_$(BITS).o      +=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_entry64.o                        +=3D -Wa,-gdwarf-2
> +asflags-remove-y               +=3D $(foreach x, -g -gdwarf-4 -gdwarf-5,=
 $(x) -Wa,$(x))
>
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>                 $(call if_changed,ld)
>
> base-commit: da8e7da11e4ba758caf4c149cc8d8cd555aefe5f
> --
> 2.37.1
>


--=20
Best Regards
Masahiro Yamada
