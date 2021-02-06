Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7408C311E58
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 16:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhBFPMm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 6 Feb 2021 10:12:42 -0500
Received: from wildebeest.demon.nl ([212.238.236.112]:45844 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhBFPME (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 10:12:04 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2021 10:12:03 EST
Received: from tarox.wildebeest.org (tarox.wildebeest.org [172.31.17.39])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id 1996F30278CD;
        Sat,  6 Feb 2021 16:02:09 +0100 (CET)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id BEDE64000987; Sat,  6 Feb 2021 16:02:09 +0100 (CET)
Message-ID: <642ceee8911e201438068f39f828af9f52cbb6a0.camel@klomp.org>
Subject: Re: [PATCH v9 1/3] vmlinux.lds.h: add DWARF v5 sections
From:   Mark Wielaard <mark@klomp.org>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Caroline Tice <cmtice@google.com>,
        Nick Clifton <nickc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Chris Murphy <bugzilla@colorremedies.com>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Nathan Chancellor <nathan@kernel.org>
Date:   Sat, 06 Feb 2021 16:02:09 +0100
In-Reply-To: <20210205202220.2748551-2-ndesaulniers@google.com>
References: <20210205202220.2748551-1-ndesaulniers@google.com>
         <20210205202220.2748551-2-ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nick,

On Fri, 2021-02-05 at 12:22 -0800, Nick Desaulniers wrote:
> We expect toolchains to produce these new debug info sections as part of
> DWARF v5. Add explicit placements to prevent the linker warnings from
> --orphan-section=warn.
> 
> Compilers may produce such sections with explicit -gdwarf-5, or based on
> the implicit default version of DWARF when -g is used via DEBUG_INFO.
> This implicit default changes over time, and has changed to DWARF v5
> with GCC 11.
> 
> .debug_sup was mentioned in review, but without compilers producing it
> today, let's wait to add it until it becomes necessary.

I don't think that will be necessary. .debug_sup is for Dwarf
Supplemental file producers like dwz. Those would run after the linker.

> Cc: stable@vger.kernel.org
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1922707
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Suggested-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/asm-generic/vmlinux.lds.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 34b7e0d2346c..1e7cde4bd3f9 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -842,8 +842,13 @@
>  		/* DWARF 4 */						\
>  		.debug_types	0 : { *(.debug_types) }			\
>  		/* DWARF 5 */						\
> +		.debug_addr	0 : { *(.debug_addr) }			\
> +		.debug_line_str	0 : { *(.debug_line_str) }		\
> +		.debug_loclists	0 : { *(.debug_loclists) }		\
>  		.debug_macro	0 : { *(.debug_macro) }			\
> -		.debug_addr	0 : { *(.debug_addr) }
> +		.debug_names	0 : { *(.debug_names) }			\
> +		.debug_rnglists	0 : { *(.debug_rnglists) }		\
> +		.debug_str_offsets	0 : { *(.debug_str_offsets) }
>  
>  /* Stabs debugging sections. */
>  #define STABS_DEBUG							\

Looks good to me.

Cheers,

Mark
