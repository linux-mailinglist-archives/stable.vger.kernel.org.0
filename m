Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B30A33D557
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 15:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbhCPOCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 10:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235627AbhCPOCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 10:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9FF26506A;
        Tue, 16 Mar 2021 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615903335;
        bh=i16G61MjWsPoU5as8xHDp+00TirP+H6Y7rzzM6KXU0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oFwZBmekbBVpdNl/bGqUoaWdFNL67i0tv9ARgLly4fs+NPrW/DMXHwWOyo62JeLex
         XA4kXkcp1kwWVq7cHdYE36G29eaZ65FpGWQd60lh84litlZNa6oduhVuSYhE2DqwzT
         BrYaCyAM1fQ4qpB1dEx6m9kgXvZzvU00cemEQ8XeK4UQJaZlLjBC48Gy+WEhGe1H4I
         xsFXMDH5iIcjtq63xzMUpKQKXYHUokiAwjWUHrX7g8bV2dJg+76CXI4WsIrkCxg3a7
         DdlFT7xRCCTAtUnYeO1pZOJEscmBwNojtpHdw+6v4ka6rTSpaBVfvrpE4OFbWSnqNE
         FOnI+s4S6OA8w==
Date:   Tue, 16 Mar 2021 10:02:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>, Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
Message-ID: <YFC6ZYvBfI/mFvaV@sashalap>
References: <YEs+iaQzEQYNgXcw@kroah.com>
 <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap>
 <YE8kIbyWKSojC1SV@kroah.com>
 <YE8k/2WTPFGwMpHk@kroah.com>
 <YE8l2qhycaGPYdNn@kroah.com>
 <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
 <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com>
 <CAMj1kXHfQmObPZaVOZu+0M3SKFKNg5vcKmyJMXQ3RTBCqho9WQ@mail.gmail.com>
 <CAKwvOdm6FXWVu-9YkQNNyoYmw+hkj1a7MQrRbWyUxsO2vDcnQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdm6FXWVu-9YkQNNyoYmw+hkj1a7MQrRbWyUxsO2vDcnQA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 03:58:07PM -0700, Nick Desaulniers wrote:
>On Mon, Mar 15, 2021 at 10:53 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>> You haven't explained why all this effort is justified to begin with.
>>
>> Who cares about being able to build 4.19 or 5.4 mainline with Clang 12
>> and IAS?
>
>Ah, sorry, ChromeOS and Android very much do so.  (Google's production
>kernels as well, though I don't think they have any 32b ARM machines).
>Android is already building 4.19+ with LLVM_IAS=1 for
>ARCH=arm64,x86_64,i686. ChromeOS is doing so for 5.4+ for
>ARCH=arm64,x86_64 as well.  I'm not sure precisely what's going on in
>prodkernel land, but I know they have LLVM_IAS=1 enabled for x86_64.
>So when Greg says this is "for no real users" I disagree.  Maybe no
>one is using LLVM_IAS=1 for ARCH=arm at this moment, but that was the
>point of the backports, to enable more distros to do so.

You can't both stay on a "stable" kernel because it's "stable", but
then expect a flow of new features. The users which you've mentioned
should be migrating to newer kernels instead of attempting to backport
features they care about to stable kernels.

-- 
Thanks,
Sasha
