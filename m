Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBFC35ACD1
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhDJLKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234180AbhDJLKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14A0361056;
        Sat, 10 Apr 2021 11:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618053001;
        bh=T4Myy0gtphcBvhwuYlyk+B2LEbpU1bpjMhq/HMjtphE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ToLqwJOcpQ8gUXXCAgTGCxWt+6Sfnm8hEyRvzoj/IwQDds7ccQLjr+lTiT5v4FsyF
         2Y6Eao6CnupxNefS1FzvAqhIgbU6JL0cnWcudv8oxSDiJ6xcbxrTzmMC/0jWREcL0j
         9UV0Jxtb6EB83WUUw/S0fxVWNtNGI+ReizEZJpB0=
Date:   Sat, 10 Apr 2021 13:09:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9] ARM: 8723/2: always assume the "unified" syntax for
 assembly code
Message-ID: <YHGHh13fy1nok5CT@kroah.com>
References: <YGhV2gwpI1XUlkyu@kroah.com>
 <20210405190827.502021-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405190827.502021-1-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 12:08:27PM -0700, Nathan Chancellor wrote:
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
> 
> commit 75fea300d73ae5b18957949a53ec770daaeb6fc2 upstream.
> 
> The GNU assembler has implemented the "unified syntax" parsing since
> 2005. This "unified" syntax is required when the kernel is built in
> Thumb2 mode. However the "unified" syntax is a mixed bag of features,
> including not requiring a `#' prefix with immediate operands. This leads
> to situations where some code builds just fine in Thumb2 mode and fails
> to build in ARM mode if that prefix is missing. This behavior
> discrepancy makes build tests less valuable, forcing both ARM and Thumb2
> builds for proper coverage.
> 
> Let's "fix" this issue by always using the "unified" syntax for both ARM
> and Thumb2 mode. Given that the documented minimum binutils version that
> properly builds the kernel is version 2.20 released in 2010, we can
> assume that any toolchain capable of building the latest kernel is also
> "unified syntax" capable.
> 
> Whith this, a bunch of macros used to mask some differences between both
> syntaxes can be removed, with the side effect of making LTO easier.
> 
> Suggested-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> [nathan: Resolve small conflict on 4.9 due to a lack of 494609701e06a]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> 
> Hi all,
> 
> This commit is needed to fix the backport of commit 7f9942c61fa6 ("ARM:
> s3c: fix fiq for clang IAS"):
> 
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/message/MJWA3VGAUNQYOL7XZBYMS4EI4AYRC3XN/
> 
> It is present in 4.14+ and it has been validate via TuxSuite across a
> variety of arch/arm configs with no errors so I feel it should be a
> fairly safe backport.

Now queued up, thanks.

greg k-h
