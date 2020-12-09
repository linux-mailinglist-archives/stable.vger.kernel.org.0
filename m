Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C26C2D4085
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 12:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbgLILBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 06:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgLILBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 06:01:14 -0500
Date:   Wed, 9 Dec 2020 12:01:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607511634;
        bh=WWnHgxoLW2MH6iA9QG/UVeTB42+Fb4FGIoIsrat/bWg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=z5/M5WhVtPxcm6TU6GooGPDC5E0xzJeNYqb+GxEtdSleGqWn8MsZCgbVOCP/NDwfp
         BhAg/DU18ft3mQtuM4hKqupRAmurPys2sWGiYA8YghzhlIGx3YJAsagzYTghf58rjn
         De/Vz74/KTnaEaSOwgMNnOxqtCDBAy3V23VthZFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 4.4] arm64: assembler: make adr_l work in modules under
 KASLR
Message-ID: <X9Cun9A/dx7apRvd@kroah.com>
References: <CALdTtnuT7fVJ17C2nq8kks_rFRGtDySx61tWpt8b+roajyi7vg@mail.gmail.com>
 <20201208011034.3015079-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208011034.3015079-1-dann.frazier@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 06:10:34PM -0700, dann frazier wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> commit 41c066f2c4d436c535616fe182331766c57838f0 upstream
> 
> When CONFIG_RANDOMIZE_MODULE_REGION_FULL=y, the offset between loaded
> modules and the core kernel may exceed 4 GB, putting symbols exported
> by the core kernel out of the reach of the ordinary adrp/add instruction
> pairs used to generate relative symbol references. So make the adr_l
> macro emit a movz/movk sequence instead when executing in module context.
> 
> While at it, remove the pointless special case for the stack pointer.
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [ dannf: backported to v4.4 by replacing the 3-arg adr_l macro in head.S
>   with it's output, as this commit drops the 3-arg variant ]
> Fixes: c042dd600f4e ("crypto: arm64/sha - avoid non-standard inline asm tricks")
> Signed-off-by: dann frazier <dann.frazier@canonical.com>
> ---
>  arch/arm64/include/asm/assembler.h | 36 +++++++++++++++++++++++++++---------
>  arch/arm64/kernel/head.S           |  3 ++-
>  2 files changed, 29 insertions(+), 10 deletions(-)

Now queued up, thanks!

greg k-h
