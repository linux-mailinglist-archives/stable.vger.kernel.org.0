Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D69907D3
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 20:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfHPSlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 14:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbfHPSlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 14:41:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0E6C2086C;
        Fri, 16 Aug 2019 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565980875;
        bh=+TegksvBcnQ60mAfmy6Gg68hjAz2Cq0jKayHgvBT+2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s4/Kd/hxpfGRIoo72h2wb/TrifDoogpZLrUMUy52s6sPJLS0kBew8zkbbdmBIsotn
         qnydOdShzhIKTIB0yhu2AQsMAhBhH2vPc0byEO0ZEv49qWafhdD/yI8nhpl/DJqdul
         gLC4q2TCsC2yS+/7LBUFZe/rMQvxYJSF/np9upDA=
Date:   Fri, 16 Aug 2019 20:41:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     stable@vger.kernel.org, Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH -stable v4.14] mm/usercopy: use memory range to be
 accessed for wraparound check
Message-ID: <20190816184113.GA26008@kroah.com>
References: <201908161123.93DFEB96@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908161123.93DFEB96@keescook>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 11:24:08AM -0700, Kees Cook wrote:
> From: Prasad Sodagudi <psodagud@codeaurora.org>
> 
> commit 951531691c4bcaa59f56a316e018bc2ff1ddf855 upstream.
> 
> Currently, when checking to see if accessing n bytes starting at address
> "ptr" will cause a wraparound in the memory addresses, the check in
> check_bogus_address() adds an extra byte, which is incorrect, as the
> range of addresses that will be accessed is [ptr, ptr + (n - 1)].
> 
> This can lead to incorrectly detecting a wraparound in the memory
> address, when trying to read 4 KB from memory that is mapped to the the
> last possible page in the virtual address space, when in fact, accessing
> that range of memory would not cause a wraparound to occur.
> 
> Use the memory range that will actually be accessed when considering if
> accessing a certain amount of bytes will cause the memory address to
> wrap around.
> 
> Link: http://lkml.kernel.org/r/1564509253-23287-1-git-send-email-isaacm@codeaurora.org
> Fixes: f5509cc18daa ("mm: Hardened usercopy")
> Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
> Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
> Co-developed-by: Prasad Sodagudi <psodagud@codeaurora.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Trilok Soni <tsoni@codeaurora.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [kees: backport to v4.14]
> Signed-off-by: Kees Cook <keescook@chromium.org>

This and the 4.9 patch now queued up, thanks for the backports.

greg k-h
