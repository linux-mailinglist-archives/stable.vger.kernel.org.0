Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F3733B9A1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhCOOGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhCOOBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4D8664F23;
        Mon, 15 Mar 2021 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816889;
        bh=oNeT7UkvqxRBX3Bnap7SLnaoOLWYYGHGMOLeeypXxAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miGSEnfPzZ2VorAvbOUwfsHM2vgu74TrZQX9+LoxVsgoBdEoZTqX+Ap1OKz1NdH7o
         pVq1u8AppUU/lLPFqPpCn8EDY7gZqwLFbATSZTRxkChdv5bu4VkDCMcPXGC9DFfFog
         0OFAt9PGmdkd0C87llQoDzqLuMWcpaCUBKhOZcGI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/290] ARM: efistub: replace adrl pseudo-op with adr_l macro invocation
Date:   Mon, 15 Mar 2021 14:54:23 +0100
Message-Id: <20210315135547.643891667@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ard Biesheuvel <ardb@kernel.org>

commit 67e3f828bd4bf5e4eb4214dc4eb227d8f1c8a877 upstream.

The ARM 'adrl' pseudo instruction is a bit problematic, as it does not
exist in Thumb mode, and it is not implemented by Clang either. Since
the Thumb variant has a slightly bigger range, it is sometimes necessary
to emit the 'adrl' variant in ARM mode where Thumb mode can use adr just
fine. However, that still leaves the Clang issue, which does not appear
to be supporting this any time soon.

So let's switch to the adr_l macro, which works for both ARM and Thumb,
and has unlimited range.

Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/head.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index a0de09f994d8..247ce9055990 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1440,8 +1440,7 @@ ENTRY(efi_enter_kernel)
 		mov	r4, r0			@ preserve image base
 		mov	r8, r1			@ preserve DT pointer
 
- ARM(		adrl	r0, call_cache_fn	)
- THUMB(		adr	r0, call_cache_fn	)
+		adr_l	r0, call_cache_fn
 		adr	r1, 0f			@ clean the region of code we
 		bl	cache_clean_flush	@ may run with the MMU off
 
-- 
2.30.1



