Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1F12860E
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 01:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLUAd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 19:33:57 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:48560 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfLUAd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 19:33:57 -0500
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 6704572CCE9;
        Sat, 21 Dec 2019 03:33:54 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 4368E7CCE30; Sat, 21 Dec 2019 03:33:54 +0300 (MSK)
Date:   Sat, 21 Dec 2019 03:33:54 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Vitaly Chikunov <vt@altlinux.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] tools lib: Fix builds when glibc contains strlcpy
Message-ID: <20191221003353.GA7214@altlinux.org>
References: <20191220235239.26928-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191220235239.26928-1-vt@altlinux.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 21, 2019 at 02:52:39AM +0300, Vitaly Chikunov wrote:
> Disable a couple of compilation warning (which are treated as errors) on
> strlcpy definition and declaration, allow users to compile perf and
> kernel (objtool).
> 
> 1. When glibc have strlcpy (such as in ALT Linux since 2004) objtool and
> perf build fails with this (in gcc):
> 
>   In file included from exec-cmd.c:3:
>   tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
>      20 | extern size_t strlcpy(char *dest, const char *src, size_t size);
> 
> 2. Clang ignores `-Wredundant-decls', but produces another warning when
> building perf:
> 
>     CC       util/string.o
>   ../lib/string.c:99:8: error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
>   size_t __weak strlcpy(char *dest, const char *src, size_t size)
>   ../../tools/include/linux/compiler.h:66:34: note: expanded from macro '__weak'
>   # define __weak                 __attribute__((weak))
>   /usr/include/bits/string_fortified.h:151:8: note: previous definition is here
>   __NTH (strlcpy (char *__restrict __dest, const char *__restrict __src,
> 
> Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string.c")
> Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIBC__")
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> Cc: Dmitry V. Levin <ldv@altlinux.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Cc: stable@vger.kernel.org

Resolves: https://bugzilla.kernel.org/show_bug.cgi?id=118481
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>


-- 
ldv
