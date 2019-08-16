Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF821905FD
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfHPQkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 12:40:37 -0400
Received: from foss.arm.com ([217.140.110.172]:58938 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfHPQkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 12:40:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B15528;
        Fri, 16 Aug 2019 09:40:36 -0700 (PDT)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC39A3F694;
        Fri, 16 Aug 2019 09:40:35 -0700 (PDT)
Date:   Fri, 16 Aug 2019 17:40:33 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: ftrace: Ensure module ftrace trampoline is
 coherent with I-side
Message-ID: <20190816164033.GA36069@arrakis.emea.arm.com>
References: <20190816135743.13683-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816135743.13683-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 02:57:43PM +0100, Will Deacon wrote:
> The initial support for dynamic ftrace trampolines in modules made use
> of an indirect branch which loaded its target from the beginning of
> a special section (e71a4e1bebaf7 ("arm64: ftrace: add support for far
> branches to dynamic ftrace")). Since no instructions were being patched,
> no cache maintenance was needed. However, later in be0f272bfc83 ("arm64:
> ftrace: emit ftrace-mod.o contents through code") this code was reworked
> to output the trampoline instructions directly into the PLT entry but,
> unfortunately, the necessary cache maintenance was overlooked.
> 
> Add a call to __flush_icache_range() after writing the new trampoline
> instructions but before patching in the branch to the trampoline.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: <stable@vger.kernel.org>
> Fixes: be0f272bfc83 ("arm64: ftrace: emit ftrace-mod.o contents through code")
> Signed-off-by: Will Deacon <will@kernel.org>

Queued for 5.3. Thanks.

-- 
Catalin
