Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182E8461A47
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhK2Own (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241965AbhK2Oun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 09:50:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2E4C0048E3
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 05:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39B35614CA
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136ADC004E1;
        Mon, 29 Nov 2021 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638191683;
        bh=CQupDxmI7OEpwojFpfIdnicQpmFJRgYlRsme5l3N+ww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fR1zz4A7Xu8kk5oaOZMNpm3Q1fLYRTDlc1np/uAxjXRqQzGT4aL4rg03R0ppiiVSs
         64BW5d+uzGqidZ+ioA/VFENEMnvo1Wezs7JsHhlArkBU8FEZRowqlUyNE6OTxgZgSn
         OZXnvxvb/IGUpnLxezBgs5Xa3ED7IoZsFIHd5FsM=
Date:   Mon, 29 Nov 2021 14:14:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] xtensa: use CONFIG_USE_OF instead of CONFIG_OF
Message-ID: <YaTSQJ6DQLhOCLic@kroah.com>
References: <20211129130626.25163-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129130626.25163-1-jcmvbkbc@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 05:06:26AM -0800, Max Filippov wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> commit d67ed2510d28a1eb33171010d35cf52178cfcbdd upstream.
> 
> CONFIG_OF can be set by a randconfig or by a user -- without setting the
> early flattree option (OF_EARLY_FLATTREE).  This causes build errors.
> However, if randconfig or a user sets USE_OF in the Xtensa config,
> the right kconfig symbols are set to fix the build.
> 
> Fixes these build errors:
> 
> ../arch/xtensa/kernel/setup.c:67:19: error: ‘__dtb_start’ undeclared here (not in a function); did you mean ‘dtb_start’?
>    67 | void *dtb_start = __dtb_start;
>       |                   ^~~~~~~~~~~
> ../arch/xtensa/kernel/setup.c: In function 'xtensa_dt_io_area':
> ../arch/xtensa/kernel/setup.c:201:14: error: implicit declaration of function 'of_flat_dt_is_compatible'; did you mean 'of_machine_is_compatible'? [-Werror=implicit-function-declaration]
>   201 |         if (!of_flat_dt_is_compatible(node, "simple-bus"))
> ../arch/xtensa/kernel/setup.c:204:18: error: implicit declaration of function 'of_get_flat_dt_prop' [-Werror=implicit-function-declaration]
>   204 |         ranges = of_get_flat_dt_prop(node, "ranges", &len);
> ../arch/xtensa/kernel/setup.c:204:16: error: assignment to 'const __be32 *' {aka 'const unsigned int *'} from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
>   204 |         ranges = of_get_flat_dt_prop(node, "ranges", &len);
>       |                ^
> ../arch/xtensa/kernel/setup.c: In function 'early_init_devtree':
> ../arch/xtensa/kernel/setup.c:228:9: error: implicit declaration of function 'early_init_dt_scan'; did you mean 'early_init_devtree'? [-Werror=implicit-function-declaration]
>   228 |         early_init_dt_scan(params);
> ../arch/xtensa/kernel/setup.c:229:9: error: implicit declaration of function 'of_scan_flat_dt' [-Werror=implicit-function-declaration]
>   229 |         of_scan_flat_dt(xtensa_dt_io_area, NULL);
> 
> xtensa-elf-ld: arch/xtensa/mm/mmu.o:(.text+0x0): undefined reference to `xtensa_kio_paddr'
> 
> Fixes: da844a81779e ("xtensa: add device trees support")
> Fixes: 6cb971114f63 ("xtensa: remap io area defined in device tree")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/xtensa/include/asm/vectors.h |  2 +-
>  arch/xtensa/kernel/setup.c        | 12 ++++++------
>  arch/xtensa/mm/mmu.c              |  2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)

Thanks, now updated.

greg k-h
