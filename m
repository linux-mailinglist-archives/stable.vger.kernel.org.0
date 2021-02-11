Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133FB318C80
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 14:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhBKNql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 08:46:41 -0500
Received: from mengyan1223.wang ([89.208.246.23]:47310 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231980AbhBKNnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 08:43:02 -0500
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2021 08:42:54 EST
Received: from [192.168.0.103] (unknown [120.208.101.20])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 4B70C65AC8;
        Thu, 11 Feb 2021 08:32:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1613050329;
        bh=isfdrzAN/aDlEfsQlBx+3bqfWbKXh9oIzMihYVq7voQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i2FFyuarN2VFHmYdNdwF6tt8/93l/3Bc6CDDrvv9k0eXxVSmcSUlwEYcNOFJIneys
         myN12cpz8roF95DXWVI4twTWQdTEJapPb31Lc5Vei6DVplFyf5V083Hzs3tOK5TkhQ
         kC5lv5dMtTfp4jnSB/mh+xIcf1ZRJ4XcVywrz2S4QkTOOOdODfXwonHFDX2/Pm3z+x
         3dT/tBCabwOScFbZYpaVJW5yEdfdJD+PNlN0cYjvVxfIae4FXlbIdhRHxyAI3Phs6H
         f9hvJ9F6/n9jattnL/hu7Ns7btCPRcDVA43wOccX8/2/5dTGBxwgb2JFhgwCiu+Ct/
         ZZEAd1U2tLSbw==
Message-ID: <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
From:   Xi Ruoyao <xry111@mengyan1223.wang>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miroslav Benes <mbenes@suse.cz>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Date:   Thu, 11 Feb 2021 21:32:03 +0800
In-Reply-To: <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
         <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

The latest GNU assembler (binutils-2.36.1) is removing unused section symbols
like Clang [1].  So linux-5.10.15 can't be built with binutils-2.36.1 now.  It
has been reported as https://bugzilla.kernel.org/show_bug.cgi?id=211693.

I can confirm this commit fixes the issue.  It should be cherry-picked into
stable branches, so the following stable releases will be able to built with
latest GNU toolchain.

[1]: https://sourceware.org/pipermail/binutils/2020-December/114671.html

At last, happy new lunar year guys :).

On 2020-12-16 13:49 +0000, tip-bot2 for Josh Poimboeuf wrote:
> The following commit has been merged into the objtool/urgent branch of tip:
> 
> Commit-ID:     44f6a7c0755d8dd453c70557e11687bb080a6f21
> Gitweb:       
> https://git.kernel.org/tip/44f6a7c0755d8dd453c70557e11687bb080a6f21
> Author:        Josh Poimboeuf <jpoimboe@redhat.com>
> AuthorDate:    Mon, 14 Dec 2020 16:04:20 -06:00
> Committer:     Peter Zijlstra <peterz@infradead.org>
> CommitterDate: Wed, 16 Dec 2020 14:35:46 +01:00
> 
> objtool: Fix seg fault with Clang non-section symbols
> 
> The Clang assembler likes to strip section symbols, which means objtool
> can't reference some text code by its section.  This confuses objtool
> greatly, causing it to seg fault.
> 
> The fix is similar to what was done before, for ORC reloc generation:
> 
>   e81e07244325 ("objtool: Support Clang non-section symbols in ORC
> generation")
> 
> Factor out that code into a common helper and use it for static call
> reloc generation as well.
> 
> Reported-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1207
> Link:
> https://lkml.kernel.org/r/ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com
> ---
>  tools/objtool/check.c   | 11 +++++++++--
>  tools/objtool/elf.c     | 26 ++++++++++++++++++++++++++
>  tools/objtool/elf.h     |  2 ++
>  tools/objtool/orc_gen.c | 29 +++++------------------------
>  4 files changed, 42 insertions(+), 26 deletions(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index c6ab445..5f8d3ee 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -467,13 +467,20 @@ static int create_static_call_sections(struct
> objtool_file *file)
>  
>                 /* populate reloc for 'addr' */
>                 reloc = malloc(sizeof(*reloc));
> +
>                 if (!reloc) {
>                         perror("malloc");
>                         return -1;
>                 }
>                 memset(reloc, 0, sizeof(*reloc));
> -               reloc->sym = insn->sec->sym;
> -               reloc->addend = insn->offset;
> +
> +               insn_to_reloc_sym_addend(insn->sec, insn->offset, reloc);
> +               if (!reloc->sym) {
> +                       WARN_FUNC("static call tramp: missing containing
> symbol",
> +                                 insn->sec, insn->offset);
> +                       return -1;
> +               }
> +
>                 reloc->type = R_X86_64_PC32;
>                 reloc->offset = idx * sizeof(struct static_call_site);
>                 reloc->sec = reloc_sec;
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index 4e1d746..be89c74 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -262,6 +262,32 @@ struct reloc *find_reloc_by_dest(const struct elf *elf,
> struct section *sec, uns
>         return find_reloc_by_dest_range(elf, sec, offset, 1);
>  }
>  
> +void insn_to_reloc_sym_addend(struct section *sec, unsigned long offset,
> +                             struct reloc *reloc)
> +{
> +       if (sec->sym) {
> +               reloc->sym = sec->sym;
> +               reloc->addend = offset;
> +               return;
> +       }
> +
> +       /*
> +        * The Clang assembler strips section symbols, so we have to reference
> +        * the function symbol instead:
> +        */
> +       reloc->sym = find_symbol_containing(sec, offset);
> +       if (!reloc->sym) {
> +               /*
> +                * Hack alert.  This happens when we need to reference the NOP
> +                * pad insn immediately after the function.
> +                */
> +               reloc->sym = find_symbol_containing(sec, offset - 1);
> +       }
> +
> +       if (reloc->sym)
> +               reloc->addend = offset - reloc->sym->offset;
> +}
> +
>  static int read_sections(struct elf *elf)
>  {
>         Elf_Scn *s = NULL;
> diff --git a/tools/objtool/elf.h b/tools/objtool/elf.h
> index 807f8c6..e6890cc 100644
> --- a/tools/objtool/elf.h
> +++ b/tools/objtool/elf.h
> @@ -140,6 +140,8 @@ struct reloc *find_reloc_by_dest(const struct elf *elf,
> struct section *sec, uns
>  struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section
> *sec,
>                                      unsigned long offset, unsigned int len);
>  struct symbol *find_func_containing(struct section *sec, unsigned long
> offset);
> +void insn_to_reloc_sym_addend(struct section *sec, unsigned long offset,
> +                             struct reloc *reloc);
>  int elf_rebuild_reloc_section(struct elf *elf, struct section *sec);
>  
>  #define for_each_sec(file,
> sec)                                                \
> diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
> index 235663b..9ce68b3 100644
> --- a/tools/objtool/orc_gen.c
> +++ b/tools/objtool/orc_gen.c
> @@ -105,30 +105,11 @@ static int create_orc_entry(struct elf *elf, struct
> section *u_sec, struct secti
>         }
>         memset(reloc, 0, sizeof(*reloc));
>  
> -       if (insn_sec->sym) {
> -               reloc->sym = insn_sec->sym;
> -               reloc->addend = insn_off;
> -       } else {
> -               /*
> -                * The Clang assembler doesn't produce section symbols, so we
> -                * have to reference the function symbol instead:
> -                */
> -               reloc->sym = find_symbol_containing(insn_sec, insn_off);
> -               if (!reloc->sym) {
> -                       /*
> -                        * Hack alert.  This happens when we need to reference
> -                        * the NOP pad insn immediately after the function.
> -                        */
> -                       reloc->sym = find_symbol_containing(insn_sec,
> -                                                          insn_off - 1);
> -               }
> -               if (!reloc->sym) {
> -                       WARN("missing symbol for insn at offset 0x%lx\n",
> -                            insn_off);
> -                       return -1;
> -               }
> -
> -               reloc->addend = insn_off - reloc->sym->offset;
> +       insn_to_reloc_sym_addend(insn_sec, insn_off, reloc);
> +       if (!reloc->sym) {
> +               WARN("missing symbol for insn at offset 0x%lx",
> +                    insn_off);
> +               return -1;
>         }
>  
>         reloc->type = R_X86_64_PC32;

-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

