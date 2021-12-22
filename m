Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE74F47D17C
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244794AbhLVMID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:08:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51470 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhLVMID (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:08:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47230B81C12
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B1C36AE5;
        Wed, 22 Dec 2021 12:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640174881;
        bh=ih0yNi3pYBYHvZ9jpRfJHj284bDIF50JlTo6vHdU8CU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yiSy49mNv9FWGkjQkslm+E5fTyVfqW3+1fg+K/DSxOZrQwiMUe9kXI7wQhSOp9eYB
         XG7ZDyrbmSIl/BVkVobL1QukM6cCPXEg5SxJjitMbsgT1Y+p60tNRzgZ6uCY/8yHwb
         n4kYCIrd/URQ8GaS9M3gMa1YLQ+E+VRjpj/vaAJw=
Date:   Wed, 22 Dec 2021 12:58:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev
Subject: Re: CROSS_COMPILE_COMPAT cherry picks for linux-5.10.y and
 linux-5.15.y
Message-ID: <YcMSzCt3vZ75UQ5c@kroah.com>
References: <CAKwvOd=3ZSuiLxWbRWicTWF2WX4biS=-+EEXbSJiuLEborbD6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=3ZSuiLxWbRWicTWF2WX4biS=-+EEXbSJiuLEborbD6w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 21, 2021 at 04:32:12PM -0800, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> 
> Please consider cherry-picking to linux-5.15.y:
> 
> commit 3e6f8d1fa184 ("arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd")
> 
> Please also consider cherry-picking to linux-5.10.y:
> 
> commit ef94340583ee ("arm64: vdso32: drop -no-integrated-as flag")
> commit 3e6f8d1fa184 ("arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd")
> 
> They landed in v5.13-rc1 and v5.16-rc1 respectively.
> 
> They allow the command line for building the arm64 compat vdso to be
> shortened by dropping the need for CROSS_COMPILE_COMPAT for LLVM=1
> (and LLVM_IAS=1) builds.
> 
> linux-5.15.y:
> from:
> $ ARCH=arm64 CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make LLVM=1 -j72
> to:
> $ ARCH=arm64 make LLVM=1 -j72
> 
> linux-5.10.y:
> from:
> $ ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
> CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make LLVM=1 LLVM_IAS=1 -j72
> to
> $ ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make LLVM=1 LLVM_IAS=1 -j72
> 
> This can be verified with the above by checking .config for
> CONFIG_COMPAT_VDSO=y after running defconfig or building
> arch/arm64/kernel/vdso32/.
> 
> I also verified these build with clang-10, which was the minimum
> supported release of clang for linux-5.10.y and linux-5.15.y
> (Documentation/process/changes.rst).

Both now queued up, thanks.

greg k-h
