Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D912351B8
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 12:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHAKiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 06:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbgHAKiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Aug 2020 06:38:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EDC620716;
        Sat,  1 Aug 2020 10:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596278300;
        bh=MwBy2MwIa4CIqD8Q0XE7qYhvWBriHmuPCmICedbn2Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EEWQHW5MOfWUXIDnLWWModJ2LjzaoDD2ocMtn5vo9KwhW7QuORIjzRnlxTs4Z5HQV
         FajI6YbE/Y5tmP81DZbqvfmfrhJiRjMzvISVcul8m0iiN+nhVioVl+J15uU/7J6PhL
         Z/imgkxYxRPR/sMomRSPXl0Fw6rpZYlpnENaERz0=
Date:   Sat, 1 Aug 2020 12:38:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH 4.14.y] ARM: 8702/1: head-common.S: Clear lr before
 jumping to start_kernel()
Message-ID: <20200801103805.GD3046974@kroah.com>
References: <20200730180340.1724137-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730180340.1724137-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 11:03:40AM -0700, Nick Desaulniers wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> commit 59b6359dd92d18f5dc04b14a4c926fa08ab66f7c upstream.
> 
> If CONFIG_DEBUG_LOCK_ALLOC=y, the kernel log is spammed with a few
> hundred identical messages:
> 
>     unwind: Unknown symbol address c0800300
>     unwind: Index not found c0800300
> 
> c0800300 is the return address from the last subroutine call (to
> __memzero()) in __mmap_switched().  Apparently having this address in
> the link register confuses the unwinder.
> 
> To fix this, reset the link register to zero before jumping to
> start_kernel().
> 
> Fixes: 9520b1a1b5f7a348 ("ARM: head-common.S: speed up startup code")
> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> Looks like this first landed in v4.15-rc1.  Without this, we can't tell
> during an unwind initiated from start_kernel() when to stop unwinding,
> which for the clang specific implementation of the arm frame pointer
> unwinder leads to dereferencing a garbage value, triggering an exception
> which has no fixup, triggering a panic, triggering an unwind, triggering
> an infinite loop that prevents booting. I have more patches to send
> upstream to make the unwinder more resilient, but it's ambiguous as to
> when to stop unwinding without this patch.

Note, the "Fixes:" tag points at something in 4.15, not 4.14, so are you
_SURE_ this is needed in 4.14.y?

thanks,

greg k-h
