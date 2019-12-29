Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB7312C746
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbfL2Rzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:55:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732663AbfL2Rzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F30A421744;
        Sun, 29 Dec 2019 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642146;
        bh=ctz9TUZwWD8BI0guBl6aQHE2Snj4GLoAeDzfH6Pa+fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuM/rHl3PPItXaXDd+vZl6Myk9Hl/D9v5OL+BvkebmNL1ODfsmTwG+4ZClRwwN4X0
         v+85Bjhtc3b+RoTjw6kdpLRUUz8aWlAY6UbbC0j+H2hyYE89mds178qgp35KNMZPcH
         3ZuMObhXP7UIuCf2JSctjt28HY3AzXmGjxm7QXmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 360/434] MIPS: futex: Restore \n after sync instructions
Date:   Sun, 29 Dec 2019 18:26:53 +0100
Message-Id: <20191229172725.883100834@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

[ Upstream commit fd7710cb491f900eb63d2ce5aac0e682003e84e9 ]

Commit 3c1d3f097972 ("MIPS: futex: Emit Loongson3 sync workarounds
within asm") inadvertently removed the newlines following
__WEAK_LLSC_MB, which causes build failures for configurations in which
__WEAK_LLSC_MB expands to a sync instruction:

  {standard input}: Assembler messages:
  {standard input}:9346: Error: symbol `sync3' is already defined
  {standard input}:9380: Error: symbol `sync3' is already defined
  ...

Fix this by restoring the newlines to separate the sync instruction from
anything following it (such as the 3: label), preventing inadvertent
concatenation.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: 3c1d3f097972 ("MIPS: futex: Emit Loongson3 sync workarounds within asm")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/futex.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/futex.h b/arch/mips/include/asm/futex.h
index 54cf20530931..110220705e97 100644
--- a/arch/mips/include/asm/futex.h
+++ b/arch/mips/include/asm/futex.h
@@ -33,7 +33,7 @@
 		"	.set	arch=r4000			\n"	\
 		"2:	sc	$1, %2				\n"	\
 		"	beqzl	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB)				\
+		__stringify(__WEAK_LLSC_MB) "			\n"	\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -63,7 +63,7 @@
 		"	.set	"MIPS_ISA_ARCH_LEVEL"		\n"	\
 		"2:	"user_sc("$1", "%2")"			\n"	\
 		"	beqz	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB)				\
+		__stringify(__WEAK_LLSC_MB) "			\n"	\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -148,7 +148,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		"	.set	arch=r4000				\n"
 		"2:	sc	$1, %2					\n"
 		"	beqzl	$1, 1b					\n"
-		__stringify(__WEAK_LLSC_MB)
+		__stringify(__WEAK_LLSC_MB) "				\n"
 		"3:							\n"
 		"	.insn						\n"
 		"	.set	pop					\n"
-- 
2.20.1



