Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5411F2C05A4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgKWMYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:24:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbgKWMYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:24:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B91AF208FE;
        Mon, 23 Nov 2020 12:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134244;
        bh=zAGFwI+/cRpJDwLyxUtzSYE4+l+MOqPG7UIOWrt+1CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJmGqrj/At+Lsa+pVaTjRvVjK9+1Ie8pou41t9gQH/FzrVz/rZ+pA7t89+qnwx2xO
         ZdJNDreUOApWOZZqW3q/7SASS+f1c9jMMQFORGYZ2tLDSSVrvJ9YAaCHL6TaKUDD9z
         ATp87e9B4o6AyFs45ZYDiIC++Oa1ikzchJlF8eZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/38] MIPS: Fix BUILD_ROLLBACK_PROLOGUE for microMIPS
Date:   Mon, 23 Nov 2020 13:22:01 +0100
Message-Id: <20201123121805.043491918@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

[ Upstream commit 1eefcbc89cf3a8e252e5aeb25825594699b47360 ]

When the kernel is built for microMIPS, branches targets need to be
known to be microMIPS code in order to result in bit 0 of the PC being
set. The branch target in the BUILD_ROLLBACK_PROLOGUE macro was simply
the end of the macro, which may be pointing at padding rather than at
code. This results in recent enough GNU linkers complaining like so:

    mips-img-linux-gnu-ld: arch/mips/built-in.o: .text+0x3e3c: Unsupported branch between ISA modes.
    mips-img-linux-gnu-ld: final link failed: Bad value
    Makefile:936: recipe for target 'vmlinux' failed
    make: *** [vmlinux] Error 1

Fix this by changing the branch target to be the start of the
appropriate handler, skipping over any padding.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/14019/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/genex.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 7ffd158de76e5..1b837d6f73deb 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -142,9 +142,8 @@ LEAF(__r4k_wait)
 	PTR_LA	k1, __r4k_wait
 	ori	k0, 0x1f	/* 32 byte rollback region */
 	xori	k0, 0x1f
-	bne	k0, k1, 9f
+	bne	k0, k1, \handler
 	MTC0	k0, CP0_EPC
-9:
 	.set pop
 	.endm
 
-- 
2.27.0



