Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7E36E4EEB
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 19:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjDQRPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 13:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjDQRPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 13:15:08 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D9149E9
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 10:15:06 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f04275b2bdso231495e9.1
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 10:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681751705; x=1684343705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a3stGmteRzeKnj1XWwcELOuoYuh13a22U1AyLn+AXFA=;
        b=USlKOpbDldphAUyai69TJ//1HRVKA+ShayAbY7sLGbOvQEvKIz5naSn8kFIiDcr28/
         NIQJbOHZ8t3qCBFz3xrGTiZzjZeb3edXdAxv576q7gp/guq8USCQw3xlKGcIgm2F9wlh
         czvyeui5XMogGuzZFqFg3RkSzMKnnDBMXFJ++iSePFy3yf5ijT7DBL196+/BykIq58yB
         mCV0EAz3oaws1Mx2yyICHKgCqo+opOlSsTFGz2C9YDQXIbqoTXT9QDfJfo/feuB7Qelk
         K1jUJryuv9g3iU2g0t9KSxnLF5jTTdFowzqOPr/k9fHkohYrGxSyWDWgs/u1KLsxaF5+
         F59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681751705; x=1684343705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a3stGmteRzeKnj1XWwcELOuoYuh13a22U1AyLn+AXFA=;
        b=k1pL00P1J/iXBXbWvY+VtfX6CcwAC3HB2Zu8GI8UNHd8Jt0cZ1HdRwz0AX1IqtOgOf
         J9ff+wU1NP3kMzgS9kOORyaBIXFY84U9vhRfjcE0reGhd0n0FETVofCBMjCDIHW+MG8C
         tZvWFL6NvOYuxdAJB+JHtcNuSvDfSEZlqt/QjSBNFQYH2P3yqBSFN0k7g87ZkFi6ZVAd
         Ak9OUU2pDm7lmtKx4dXbOKI3Q//mJY1S/UZl+iLie/p2JmUd751Vt8E5Wd7jdAAIGp0E
         T/+1Vn1O+z81LnqSye30DAroKJVe7JTIf2XnhzioPdKm7mo6er5N4joG8OV1Mh5Uvv4p
         oZ0Q==
X-Gm-Message-State: AAQBX9dHvzaHO0ftqm8S4AY1I3qjqCy1zT5s7rfIbEzzbRTrFdZM+JPs
        5bNDHrghtqKd3pZXG6xFqpd6nUzHQdaGMalfp5BFSg==
X-Google-Smtp-Source: AKy350Z7GLpgZB4nWfaWROBdqmPEACzgMPzNNdQCuM59lX1IGltn277CXYX21QobH4mjsaKVJbsxhora8Sr1e5fDRRg=
X-Received: by 2002:a05:600c:5122:b0:3f1:70d1:21a6 with SMTP id
 o34-20020a05600c512200b003f170d121a6mr4313wms.0.1681751704759; Mon, 17 Apr
 2023 10:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230417122943.2155502-1-anders.roxell@linaro.org> <20230417122943.2155502-2-anders.roxell@linaro.org>
In-Reply-To: <20230417122943.2155502-2-anders.roxell@linaro.org>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 17 Apr 2023 10:14:51 -0700
Message-ID: <CAP-5=fWUevSnyn5MtVO1p6cEVE8MvBTq4Qgth7RcPYueRERQKA@mail.gmail.com>
Subject: Re: [backport PATCH 1/2] tools perf: Fix compilation error with new binutils
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, acme@redhat.com, andres@anarazel.de,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <benh@debian.org>, Jiri Olsa <jolsa@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Apr 17, 2023 at 5:30=E2=80=AFAM Anders Roxell <anders.roxell@linaro=
.org> wrote:
>
> From: Andres Freund <andres@anarazel.de>
>
> binutils changed the signature of init_disassemble_info(), which now caus=
es
> compilation failures for tools/perf/util/annotate.c, e.g. on debian
> unstable.

Thanks, I believe the compilation issue may well be resolved by:
https://lore.kernel.org/lkml/20230311065753.3012826-8-irogers@google.com/
where binutils is made opt-in rather than opt-out.

> Relevant binutils commit:
>
>   https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommit;h=3D60a3da0=
0bd5407f07
>
> Wire up the feature test and switch to init_disassemble_info_compat(),
> which were introduced in prior commits, fixing the compilation failure.

I was kind of surprised to see no version check ifdef. Is
init_disassemble_info_compat is supported in older binutils?

Thanks,
Ian

> I verified that perf can still disassemble bpf programs by using bpftrace
> under load, recording a perf trace, and then annotating the bpf "function=
"
> with and without the changes. With old binutils there's no change in outp=
ut
> before/after this patch. When comparing the output from old binutils (2.3=
5)
> to new bintuils with the patch (upstream snapshot) there are a few output
> differences, but they are unrelated to this patch. An example hunk is:
>
>        1.15 :   55:mov    %rbp,%rdx
>        0.00 :   58:add    $0xfffffffffffffff8,%rdx
>        0.00 :   5c:xor    %ecx,%ecx
>   -    1.03 :   5e:callq  0xffffffffe12aca3c
>   +    1.03 :   5e:call   0xffffffffe12aca3c
>        0.00 :   63:xor    %eax,%eax
>   -    2.18 :   65:leaveq
>   -    2.82 :   66:retq
>   +    2.18 :   65:leave
>   +    2.82 :   66:ret
>
> Signed-off-by: Andres Freund <andres@anarazel.de>
> Acked-by: Quentin Monnet <quentin@isovalent.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Ben Hutchings <benh@debian.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Sedat Dilek <sedat.dilek@gmail.com>
> Cc: bpf@vger.kernel.org
> Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.a=
narazel.de
> Link: https://lore.kernel.org/r/20220801013834.156015-5-andres@anarazel.d=
e
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  tools/perf/Makefile.config | 8 ++++++++
>  tools/perf/util/annotate.c | 7 ++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 3e7706c251e9..55905571f87b 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -281,6 +281,7 @@ FEATURE_CHECK_LDFLAGS-libpython :=3D $(PYTHON_EMBED_L=
DOPTS)
>  FEATURE_CHECK_LDFLAGS-libaio =3D -lrt
>
>  FEATURE_CHECK_LDFLAGS-disassembler-four-args =3D -lbfd -lopcodes -ldl
> +FEATURE_CHECK_LDFLAGS-disassembler-init-styled =3D -lbfd -lopcodes -ldl
>
>  CORE_CFLAGS +=3D -fno-omit-frame-pointer
>  CORE_CFLAGS +=3D -ggdb3
> @@ -838,13 +839,16 @@ else
>    ifeq ($(feature-libbfd-liberty), 1)
>      EXTLIBS +=3D -lbfd -lopcodes -liberty
>      FEATURE_CHECK_LDFLAGS-disassembler-four-args +=3D -liberty -ldl
> +    FEATURE_CHECK_LDFLAGS-disassembler-init-styled +=3D -liberty -ldl
>    else
>      ifeq ($(feature-libbfd-liberty-z), 1)
>        EXTLIBS +=3D -lbfd -lopcodes -liberty -lz
>        FEATURE_CHECK_LDFLAGS-disassembler-four-args +=3D -liberty -lz -ld=
l
> +      FEATURE_CHECK_LDFLAGS-disassembler-init-styled +=3D -liberty -ldl
>      endif
>    endif
>    $(call feature_check,disassembler-four-args)
> +  $(call feature_check,disassembler-init-styled)
>  endif
>
>  ifeq ($(feature-libbfd-buildid), 1)
> @@ -957,6 +961,10 @@ ifeq ($(feature-disassembler-four-args), 1)
>      CFLAGS +=3D -DDISASM_FOUR_ARGS_SIGNATURE
>  endif
>
> +ifeq ($(feature-disassembler-init-styled), 1)
> +    CFLAGS +=3D -DDISASM_INIT_STYLED
> +endif
> +
>  ifeq (${IS_64_BIT}, 1)
>    ifndef NO_PERF_READ_VDSO32
>      $(call feature_check,compile-32)
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 308189454788..f2d1741b7610 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -1684,6 +1684,7 @@ static int dso__disassemble_filename(struct dso *ds=
o, char *filename, size_t fil
>  #define PACKAGE "perf"
>  #include <bfd.h>
>  #include <dis-asm.h>
> +#include <tools/dis-asm-compat.h>
>
>  static int symbol__disassemble_bpf(struct symbol *sym,
>                                    struct annotate_args *args)
> @@ -1726,9 +1727,9 @@ static int symbol__disassemble_bpf(struct symbol *s=
ym,
>                 ret =3D errno;
>                 goto out;
>         }
> -       init_disassemble_info(&info, s,
> -                             (fprintf_ftype) fprintf);
> -
> +       init_disassemble_info_compat(&info, s,
> +                                    (fprintf_ftype) fprintf,
> +                                    fprintf_styled);
>         info.arch =3D bfd_get_arch(bfdf);
>         info.mach =3D bfd_get_mach(bfdf);
>
> --
> 2.39.2
>
