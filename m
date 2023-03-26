Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829C26C96DC
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 18:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCZQev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 12:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCZQeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 12:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F0B2D58;
        Sun, 26 Mar 2023 09:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A923B80D19;
        Sun, 26 Mar 2023 16:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FDFC433A1;
        Sun, 26 Mar 2023 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679848486;
        bh=lniLhjzAVP4A7/HZzVY4+OrTbNpVJm/gYIDl+oQterE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JK3Yveqek/OJHInqxbDUOO4UWY67DeXaOjY5IknYOWk+oxY5lR1xHuR77gsb143FU
         kvRAzHEad2ehIHdRTM/RHydR6QCWR+uuhY2J1gbT/HI6YtlqiOtUG61VBQaQ/b+xyZ
         rwVEB5LxxQmV/hMzeKVGhmu/o9OQwsJx++9XdX8Cvp968Tr73FxM0epsJ+ujdcAI61
         sC1IH1WNzp3+89nKTG1XA2dkn899Qjt5NeBSq8LSIpbRRiRYTCMY830+VCSPdL3GEb
         0Kwt03VBvIyqBKN0pjk4satvfryw7CSOwgFwMqsRaIqI9J08PZ3ev/1ZxRwvSSUhu4
         dFX7zy5UTOvAQ==
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-17aceccdcf6so6905658fac.9;
        Sun, 26 Mar 2023 09:34:46 -0700 (PDT)
X-Gm-Message-State: AO0yUKWKYzAiH1hw2KQQJLLGXhTFdFh8VJeJ0ivM6oM8DM8av7DPPIXe
        IwHqHAGHVk2rH1AznUTh5n9/k3PM78KoWvhYvSM=
X-Google-Smtp-Source: AKy350ZKevNh0OIe4jwck411MTacKfhxDKD4eEX6xDTuM7GhMe3UsweBg/WHTc/a+KMwbk0nCqKHqiBgIpefvnGdVjA=
X-Received: by 2002:a05:6870:a2a:b0:177:aff1:a393 with SMTP id
 bf42-20020a0568700a2a00b00177aff1a393mr2203464oac.11.1679848485974; Sun, 26
 Mar 2023 09:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230326153412.63128-1-hi@alyssa.is>
In-Reply-To: <20230326153412.63128-1-hi@alyssa.is>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 27 Mar 2023 01:34:09 +0900
X-Gmail-Original-Message-ID: <CAK7LNARyn3R3BRxJ0Wdd_djTNQQR3Qh56jXAhR+gzgTsPY7Xew@mail.gmail.com>
Message-ID: <CAK7LNARyn3R3BRxJ0Wdd_djTNQQR3Qh56jXAhR+gzgTsPY7Xew@mail.gmail.com>
Subject: Re: [PATCH] purgatory: fix disabling debug info
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
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 27, 2023 at 12:35=E2=80=AFAM Alyssa Ross <hi@alyssa.is> wrote:
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
> ---
>  arch/riscv/purgatory/Makefile | 12 ++++++------
>  arch/x86/purgatory/Makefile   |  4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefil=
e
> index d16bf715a586..97001798fa19 100644
> --- a/arch/riscv/purgatory/Makefile
> +++ b/arch/riscv/purgatory/Makefile
> @@ -84,12 +84,12 @@ CFLAGS_string.o                     +=3D $(PURGATORY_=
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
> +AFLAGS_REMOVE_entry.o          +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-g=
dwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_memcpy.o         +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-g=
dwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_memset.o         +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-g=
dwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_strcmp.o         +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-g=
dwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_strlen.o         +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-g=
dwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_strncmp.o                +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-=
g -Wa,-gdwarf4 -Wa,-gdwarf-5


You can merge these into a single line:

 asflags-remove-y +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwa=
rf-5


Or, a slightly shorter but tricky way is:

 asflags-remove-y +=3D $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))


>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>                 $(call if_changed,ld)
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 17f09dc26381..f1b1ef6c4cbf 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -69,8 +69,8 @@ CFLAGS_sha256.o                       +=3D $(PURGATORY_=
CFLAGS)
>  CFLAGS_REMOVE_string.o         +=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_string.o                        +=3D $(PURGATORY_CFLAGS)
>
> -AFLAGS_REMOVE_setup-x86_$(BITS).o      +=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_entry64.o                        +=3D -Wa,-gdwarf-2
> +AFLAGS_REMOVE_setup-x86_$(BITS).o      +=3D -g -gdwarf-4 -gdwarf-5 -Wa,-=
g -Wa,-gdwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_entry64.o                        +=3D -g -gdwarf-4 -gdwarf=
-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5


Ditto.


Thanks.



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
