Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5202F6422C0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 06:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiLEFfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 00:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiLEFfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 00:35:03 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A611260E;
        Sun,  4 Dec 2022 21:34:59 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NQXLN2j8Wz4xFr;
        Mon,  5 Dec 2022 16:34:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1670218494;
        bh=LZM/dOQ5o1Fzq95MgbgafsjU5PRMxGu0sQRONJPy2b8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PJRBsMYB8VhCGc+x3Xz8vv/KcTg4s2ARgnKNIcEc7w0H61ggLNz/ZJNLytP1BAo0p
         Xj2a+anTUWCEYXLEM8IeiBYQ04zLotcKr75wFa2j921f9Mnt2IJQGstYQp7OIpzsKE
         9PfqUH0x40QLfSKFSO6uN8ENnZTmqhIymKEOUyqm8loeI7N/VZ+u3WZhpmcYOeWqXF
         Usla1e1QW/qqrDvX508v4RPMT9cXRH2thKaTHLESsujL33GP4W9NTCqmjos+Na7O0/
         CkUEaAuBOCfudLzXRiub9fi8Yn+N4+izJajUa2A1MtJ9bzcceehUVmW09fk6IEihsZ
         ClySslHjWnWFQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Michael Jeanson <mjeanson@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Michael Jeanson <mjeanson@efficios.com>, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michal Suchanek <msuchanek@suse.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
In-Reply-To: <20221201161442.2127231-1-mjeanson@efficios.com>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
Date:   Mon, 05 Dec 2022 16:34:49 +1100
Message-ID: <87pmcys9ae.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michael Jeanson <mjeanson@efficios.com> writes:
> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
> changing from their dot prefixed variant to the non-prefixed ones.
>
> Since ftrace prefixes a dot to the syscall names when matching them to
> build its syscall event list, this resulted in no syscall events being
> available.
>
> Remove the PPC64_ELF_ABI_V1 specific version of
> arch_syscall_match_sym_name to have the same behavior across all powerpc
> variants.

This doesn't seem to work for me.

Event with it applied I still don't see anything in /sys/kernel/debug/tracing/events/syscalls

Did we break it in some other way recently?

cheers


> Fixes: 68b34588e202 ("powerpc/64/sycall: Implement syscall entry/exit logic in C")
> Cc: stable@vger.kernel.org # v5.7+
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Michal Suchanek <msuchanek@suse.de>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  arch/powerpc/include/asm/ftrace.h | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
> index 3cee7115441b..e3d1f377bc5b 100644
> --- a/arch/powerpc/include/asm/ftrace.h
> +++ b/arch/powerpc/include/asm/ftrace.h
> @@ -64,17 +64,6 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
>   * those.
>   */
>  #define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
> -#ifdef CONFIG_PPC64_ELF_ABI_V1
> -static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
> -{
> -	/* We need to skip past the initial dot, and the __se_sys alias */
> -	return !strcmp(sym + 1, name) ||
> -		(!strncmp(sym, ".__se_sys", 9) && !strcmp(sym + 6, name)) ||
> -		(!strncmp(sym, ".ppc_", 5) && !strcmp(sym + 5, name + 4)) ||
> -		(!strncmp(sym, ".ppc32_", 7) && !strcmp(sym + 7, name + 4)) ||
> -		(!strncmp(sym, ".ppc64_", 7) && !strcmp(sym + 7, name + 4));
> -}
> -#else
>  static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
>  {
>  	return !strcmp(sym, name) ||
> @@ -83,7 +72,6 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
>  		(!strncmp(sym, "ppc32_", 6) && !strcmp(sym + 6, name + 4)) ||
>  		(!strncmp(sym, "ppc64_", 6) && !strcmp(sym + 6, name + 4));
>  }
> -#endif /* CONFIG_PPC64_ELF_ABI_V1 */
>  #endif /* CONFIG_FTRACE_SYSCALLS */
>  
>  #if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
> -- 
> 2.34.1
