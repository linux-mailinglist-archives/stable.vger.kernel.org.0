Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AD82F9CD9
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389443AbhARK0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389994AbhARKWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 05:22:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95ACF221EC;
        Mon, 18 Jan 2021 10:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610964900;
        bh=pZtusNSwr8zLipjPyphuZCumKLM1QFJMlQeqzkZy1jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IiAscpFgeBXShOTNWRHYmKtpr+P25XRcMQUaNsEmFP8CghbRLyLCw9SjKRij8VvXq
         KUnE07fZSGlUttsZfrCC2wYenvq4XOshi0H/7a4CuF08FBIVNtI8PbJ5z8J6NK1xtD
         gRcL/eqrz8gl5N7fZ9rh3Nint6G63vxmYSq4/ASvNgypDrekhSm75zVnMD/aFK6F83
         5kiZsD2Ah28QldFoRd+H5aGfTneBvnvNCKypIQsoNzf+gn3ILWN7ed7Y4T5/Y1svTJ
         0Qyc7CHmbJuLz8xEF2SbGQvd3eJoEOwZNuLrI9MSBmqE6EGp2AXv9P6qcz0RwivSMX
         6ZlrX31v0JHyQ==
Date:   Mon, 18 Jan 2021 11:14:55 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Fangrui Song <maskray@google.com>
Cc:     linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Sam Ravnborg <sam@ravnborg.org>,
        Marco Elver <elver@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for
 undefined symbols
Message-ID: <20210118101453.GA13910@linux-8ccs>
References: <20210114211840.GA5617@linux-8ccs>
 <20210115195222.3453262-1-maskray@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210115195222.3453262-1-maskray@google.com>
X-OS:   Linux linux-8ccs 5.8.0-rc6-lp150.12.61-default+ x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ Fangrui Song [15/01/21 11:52 -0800]:
>clang-12 -fno-pic (since
>https://github.com/llvm/llvm-project/commit/a084c0388e2a59b9556f2de0083333232da3f1d6)
>can emit `call __stack_chk_fail@PLT` instead of `call __stack_chk_fail`
>on x86.  The two forms should have identical behaviors on x86-64 but the
>former causes GNU as<2.37 to produce an unreferenced undefined symbol
>_GLOBAL_OFFSET_TABLE_.
>
>(On x86-32, there is an R_386_PC32 vs R_386_PLT32 difference but the
>linker behavior is identical as far as Linux kernel is concerned.)
>
>Simply ignore _GLOBAL_OFFSET_TABLE_ for now, like what
>scripts/mod/modpost.c:ignore_undef_symbol does. This also fixes the
>problem for gcc/clang -fpie and -fpic, which may emit `call foo@PLT` for
>external function calls on x86.
>
>Note: ld -z defs and dynamic loaders do not error for unreferenced
>undefined symbols so the module loader is reading too much.  If we ever
>need to ignore more symbols, the code should be refactored to ignore
>unreferenced symbols.
>
>Reported-by: Marco Elver <elver@google.com>
>Link: https://github.com/ClangBuiltLinux/linux/issues/1250
>Signed-off-by: Fangrui Song <maskray@google.com>
>Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>Tested-by: Marco Elver <elver@google.com>
>Cc: <stable@vger.kernel.org>
>
>---
>Changes in v2:
>* Fix Marco's email address
>* Add a function ignore_undef_symbol similar to scripts/mod/modpost.c:ignore_undef_symbol
>---
>Changes in v3:
>* Fix the style of a multi-line comment.
>* Use static bool ignore_undef_symbol.

Patch has been queued up on modules-next:

https://git.kernel.org/pub/scm/linux/kernel/git/jeyu/linux.git/commit/?h=modules-next&id=ebfac7b778fac8b0e8e92ec91d0b055f046b4604

Thanks!

Jessica
