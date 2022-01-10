Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1001948906D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 07:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbiAJG4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 01:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiAJG4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 01:56:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C370AC06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 22:56:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDF22B811DA
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 06:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18610C36AED;
        Mon, 10 Jan 2022 06:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641797772;
        bh=PH1Bm5w6DaUHeR7AfqK2ValR7rLovmxWPQ5YTG6NYkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTsNU8qklI59YrbtQR8MfymRwUL24aZ2mEXXa/5uC80/lfjIM4CQy5BzR2YSOgtOW
         3y4DRiI8yz9L1Hw1KHkV9UnQTXBKtXJjpTYoGC9ZZdZ0g9zsfBC18l7AVWBtSUltAe
         WYEe83Q0nVr9EGR/Yg1cAlg2oYs9ltPowdm2a9/E=
Date:   Mon, 10 Jan 2022 07:56:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     ndesaulniers@google.com, sebastian.reichel@collabora.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4,4.9] power: reset: ltc2952: Fix use of floating point
 literals
Message-ID: <YdvYih67e806pY0g@kroah.com>
References: <164173270519248@kroah.com>
 <20220109185902.1097931-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109185902.1097931-1-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 09, 2022 at 11:59:02AM -0700, Nathan Chancellor wrote:
> commit 644106cdb89844be2496b21175b7c0c2e0fab381 upstream.
> 
> A new commit in LLVM causes an error on the use of 'long double' when
> '-mno-x87' is used, which the kernel does through an alias,
> '-mno-80387' (see the LLVM commit below for more details around why it
> does this).
> 
> drivers/power/reset/ltc2952-poweroff.c:162:28: error: expression requires  'long double' type support, but target 'x86_64-unknown-linux-gnu' does not support it
>         data->wde_interval = 300L * 1E6L;
>                                   ^
> drivers/power/reset/ltc2952-poweroff.c:162:21: error: expression requires  'long double' type support, but target 'x86_64-unknown-linux-gnu' does not support it
>         data->wde_interval = 300L * 1E6L;
>                            ^
> drivers/power/reset/ltc2952-poweroff.c:163:41: error: expression requires  'long double' type support, but target 'x86_64-unknown-linux-gnu' does not support it
>         data->trigger_delay = ktime_set(2, 500L*1E6L);
>                                                ^
> 3 errors generated.
> 
> This happens due to the use of a 'long double' literal. The 'E6' part of
> '1E6L' causes the literal to be a 'double' then the 'L' suffix promotes
> it to 'long double'.
> 
> There is no visible reason for floating point values in this driver, as
> the values are only assigned to integer types. Use NSEC_PER_MSEC, which
> is the same integer value as '1E6L', to avoid changing functionality but
> fix the error.
> 
> Fixes: 6647156c00cc ("power: reset: add LTC2952 poweroff driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1497
> Link: https://github.com/llvm/llvm-project/commit/a8083d42b1c346e21623a1d36d1f0cadd7801d83
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> [nathan: Resolve conflict due to lack of 8b0e195314fab]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/power/reset/ltc2952-poweroff.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
