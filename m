Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85A932A29
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfFCH63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 03:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfFCH63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 03:58:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0221F27D02;
        Mon,  3 Jun 2019 07:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559548708;
        bh=Vyq8wFEsWZczVkU2TMN3imZ3jt8TiMnuXTOMDcIRMLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XtiVBGCXSSIOXg8TxT2afHLUDv2EQFQImEhcVf00iwtdUGtzqbRVCjaM2+ABTtIVJ
         eLAqhdh8GrHCy0xFImcIHngNNzNGbauPHv0u214mWcijfLUZimoVDGj1CMJ3DMR/Rt
         hF2Nm32o13v08iK6qYfsz+56C/8Hy7s/kUthfsVQ=
Date:   Mon, 3 Jun 2019 09:58:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 4.19] compiler.h: give up __compiletime_assert_fallback()
Message-ID: <20190603075826.GD7814@kroah.com>
References: <20190531060109.124476-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531060109.124476-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 11:01:10PM -0700, Nathan Chancellor wrote:
> From: Masahiro Yamada <yamada.masahiro@socionext.com>
> 
> commit 81b45683487a51b0f4d3b29d37f20d6d078544e4 upstream.
> 
> __compiletime_assert_fallback() is supposed to stop building earlier
> by using the negative-array-size method in case the compiler does not
> support "error" attribute, but has never worked like that.
> 
> You can simply try:
> 
>     BUILD_BUG_ON(1);
> 
> GCC immediately terminates the build, but Clang does not report
> anything because Clang does not support the "error" attribute now.
> It will later fail at link time, but __compiletime_assert_fallback()
> is not working at least.
> 
> The root cause is commit 1d6a0d19c855 ("bug.h: prevent double evaluation
> of `condition' in BUILD_BUG_ON").  Prior to that commit, BUILD_BUG_ON()
> was checked by the negative-array-size method *and* the link-time trick.
> Since that commit, the negative-array-size is not effective because
> '__cond' is no longer constant.  As the comment in <linux/build_bug.h>
> says, GCC (and Clang as well) only emits the error for obvious cases.
> 
> When '__cond' is a variable,
> 
>     ((void)sizeof(char[1 - 2 * __cond]))
> 
> ... is not obvious for the compiler to know the array size is negative.
> 
> Reverting that commit would break BUILD_BUG() because negative-size-array
> is evaluated before the code is optimized out.
> 
> Let's give up __compiletime_assert_fallback().  This commit does not
> change the current behavior since it just rips off the useless code.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> Hi Greg and Sasha,
> 
> Please pick up this patch for 4.19. It fixes an insane amount of spam
> from the drivers/gpu/drm/i915 subsystem because they enable the -Wvla
> warning and we have been carrying it in our CI for a while.

Now applied, thanks.

greg k-h
