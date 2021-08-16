Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041523ED684
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbhHPNVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240682AbhHPNUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE422632CF;
        Mon, 16 Aug 2021 13:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119724;
        bh=PUxughzb1omkrIgHFWiJiaRECvWdnLUoFaMWyzy0txM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd2zonBW5aSbqm6Ha2nnVh0keEI9wlyptjcHph23ReYdzbsqLiC/ZC14lb1tr4bfY
         aTbV/yORfx/kHgcnBaH/R40BRnDAOAUN0Gj37EPl62yKsxYXaabCtMRrMA4LaKzN75
         s54j2uLYW3ft+o7sWuAq4o3SMGTWe1hlaLSRqAfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 138/151] powerpc/32s: Fix napping restore in data storage interrupt (DSI)
Date:   Mon, 16 Aug 2021 15:02:48 +0200
Message-Id: <20210816125448.610247853@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 62376365048878f770d8b7d11b89b8b3e18018f1 upstream.

When a DSI (Data Storage Interrupt) is taken while in NAP mode,
r11 doesn't survive the call to power_save_ppc32_restore().

So use r1 instead of r11 as they both contain the virtual stack
pointer at that point.

Fixes: 4c0104a83fc3 ("powerpc/32: Dismantle EXC_XFER_STD/LITE/TEMPLATE")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/731694e0885271f6ee9ffc179eb4bcee78313682.1628003562.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_book3s_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -300,7 +300,7 @@ ALT_MMU_FTR_SECTION_END_IFSET(MMU_FTR_HP
 	EXCEPTION_PROLOG_1
 	EXCEPTION_PROLOG_2 INTERRUPT_DATA_STORAGE DataAccess handle_dar_dsisr=1
 	prepare_transfer_to_handler
-	lwz	r5, _DSISR(r11)
+	lwz	r5, _DSISR(r1)
 	andis.	r0, r5, DSISR_DABRMATCH@h
 	bne-	1f
 	bl	do_page_fault


