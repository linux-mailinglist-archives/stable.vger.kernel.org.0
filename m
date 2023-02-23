Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D576A0536
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjBWJu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjBWJu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:50:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F275E4DE2E;
        Thu, 23 Feb 2023 01:50:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7CB5B81990;
        Thu, 23 Feb 2023 09:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D17C433EF;
        Thu, 23 Feb 2023 09:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677145824;
        bh=6+RS3vKNtOBH6Iix7VuTmtdw51WghGYeiUtoXdjfsao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pxNV593LF5ua2oXpyWhWw1CF8jqDWKRzFCBzYfUwdPB1+9vcs6TD9K2SlZipxjpQB
         kV9faWEzrhPUEdIgV4eq1gA6XRO9nQrFwQ5KdKWOiyXk8WAIxeNisp8BiVE0gT9p4h
         n5hwQSUaA3nqHXumhYz3HIspsumEAftd2BDgXNvU=
Date:   Thu, 23 Feb 2023 10:50:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 5.4 v2 1/6] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to
 generic DISCARDS
Message-ID: <Y/c23lnfn42s5uCC@kroah.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
 <20230210-tsaeger-upstream-linux-stable-5-4-v2-1-a56d1e0f5e98@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-1-a56d1e0f5e98@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 01:20:22PM -0700, Tom Saeger wrote:
> From: "H.J. Lu" <hjl.tools@gmail.com>
> 
> commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.
> 
> In the x86 kernel, .exit.text and .exit.data sections are discarded at
> runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS
> and define it in the x86 kernel linker script to keep them.
> 
> The sections are added before the DISCARD directive so document here
> only the situation explicitly as this change doesn't have any effect on
> the generated kernel. Also, other architectures like ARM64 will use it
> too so generalize the approach with the RUNTIME_DISCARD_EXIT define.
> 
>  [ bp: Massage and extend commit message. ]
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
>  arch/x86/kernel/vmlinux.lds.S     |  1 +
>  include/asm-generic/vmlinux.lds.h | 11 +++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 1afe211d7a7c..0ae3cd9a25ea 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -21,6 +21,7 @@
>  #define LOAD_OFFSET __START_KERNEL_map
>  #endif
>  
> +#define RUNTIME_DISCARD_EXIT
>  #include <asm-generic/vmlinux.lds.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/thread_info.h>

Does this backport look correct from a style point-of-view?

Hint, extra blank line needed after the define, like what is done in the
original...

thanks,

greg k-h
