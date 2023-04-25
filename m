Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C7E6ED919
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 02:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjDYAB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 20:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbjDYAB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 20:01:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6180865A0;
        Mon, 24 Apr 2023 17:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E893C62A62;
        Tue, 25 Apr 2023 00:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83958C433EF;
        Tue, 25 Apr 2023 00:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682380881;
        bh=DOtLRFklRFNIwZwR+mJSNOC+/SMlST+wjhFM31DemZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI0iQsJDzXLdF4K3zTSApDcaUBWn9bHvayuO0rQWGCq+s9Z0Rx4zWYGy1kQE0dpf4
         L+843nKU0eXmKvlbaK51nYQOBeNu7hB8e0cnIl9BX8ZNYmkQvemsQADHsJ0kMFacHo
         Dh7RP9kcb37iT39U86Oe06X8pTB/VNpsjMJgaD0DdgIoo9JIYRt18wYZFXFoagNoBO
         zx2gzzC55BHVVhuJXz6QVNlF1cN42IgJQrSsqV6i+diMwdy6cnL0TxCdS4Ta8w8Zns
         N01FWvAtskWhlNsWN26V6y0slo5reC62c1iluzpBQwSVJ0h6OJu16KVe37pSFjMvPL
         rnWFjCSTt9mHQ==
From:   SeongJae Park <sj@kernel.org>
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David Gow" <davidgow@google.com>,
        =?UTF-8?q?Sergio=20Gonz=C3=A1lez=20Collado?= 
        <sergio.collado@gmail.com>, "Richard Weinberger" <richard@nod.at>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 04/13] rust: arch/um: Disable FP/SIMD instruction to match x86
Date:   Tue, 25 Apr 2023 00:01:18 +0000
Message-Id: <20230425000118.45838-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314124325.470931-4-sashal@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha and Greg,


On Tue, 14 Mar 2023 08:43:16 -0400 Sasha Levin <sashal@kernel.org> wrote:

> From: David Gow <davidgow@google.com>
> 
> [ Upstream commit 8849818679478933dd1d9718741f4daa3f4e8b86 ]
> 
> The kernel disables all SSE and similar FP/SIMD instructions on
> x86-based architectures (partly because we shouldn't be using floats in
> the kernel, and partly to avoid the need for stack alignment, see:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383 )
> 
> UML does not do the same thing, which isn't in itself a problem, but
> does add to the list of differences between UML and "normal" x86 builds.
> 
> In addition, there was a crash bug with LLVM < 15 / rustc < 1.65 when
> building with SSE, so disabling it fixes rust builds with earlier
> compiler versions, see:
> https://github.com/Rust-for-Linux/linux/pull/881
> 
> Signed-off-by: David Gow <davidgow@google.com>
> Reviewed-by: Sergio González Collado <sergio.collado@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

There is a followup fix of this patch that merged into the mainline by commit
a3046a618a28 ("um: Only disable SSE on clang to work around old GCC bugs"), but
it has not added to 6.1.y so far.  Without it, compiling on some setup using an
old version of gcc fails, as the followup is also mentioning.  I also confirmed
the issue can be reproduced on latest 6.1.y.

Could you please add the followup fix to 6.1.y?  I confirmed the commit can be
cleanly cherry-picked on latest 6.1.y, and fixes the issue as expected.


Thanks,
SJ

> ---
>  arch/x86/Makefile.um | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
> index b3c1ae084180d..d2e95d1d4db77 100644
> --- a/arch/x86/Makefile.um
> +++ b/arch/x86/Makefile.um
> @@ -1,6 +1,12 @@
>  # SPDX-License-Identifier: GPL-2.0
>  core-y += arch/x86/crypto/
>  
> +#
> +# Disable SSE and other FP/SIMD instructions to match normal x86
> +#
> +KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
> +KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
> +
>  ifeq ($(CONFIG_X86_32),y)
>  START := 0x8048000
>  
> -- 
> 2.39.2
> 
> 
