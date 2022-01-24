Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A72C4998CB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453378AbiAXVaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40302 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449483AbiAXVTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:19:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C569A61490;
        Mon, 24 Jan 2022 21:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7E0C340E4;
        Mon, 24 Jan 2022 21:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059154;
        bh=dLkJHSehkvwf6TVlYKXzLag1jRfBp/iDlklf0WRr+0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRfVKPb5BiIsurK9bawi5FD5VeAaLgzli4oR5M7qJUhyVEU0VF6AG5WDbLlyPyYGw
         vTqQh8LDvN5xbANxCKwEwB1VkTy1efim29Wewx9zoEggBHz2RF0W7RN3rsrmfq2KSw
         MVI3xYHeJCzgRSYaEksPifae7j9GN3MDcqf0G+Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0522/1039] MIPS: fix local_{add,sub}_return on MIPS64
Date:   Mon, 24 Jan 2022 19:38:31 +0100
Message-Id: <20220124184142.841372597@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit 277c8cb3e8ac199f075bf9576ad286687ed17173 ]

Use "daddu/dsubu" for long int on MIPS64 instead of "addu/subu"

Fixes: 7232311ef14c ("local_t: mips extension")
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/local.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
index ecda7295ddcd1..3fa6340903882 100644
--- a/arch/mips/include/asm/local.h
+++ b/arch/mips/include/asm/local.h
@@ -5,6 +5,7 @@
 #include <linux/percpu.h>
 #include <linux/bitops.h>
 #include <linux/atomic.h>
+#include <asm/asm.h>
 #include <asm/cmpxchg.h>
 #include <asm/compiler.h>
 #include <asm/war.h>
@@ -39,7 +40,7 @@ static __inline__ long local_add_return(long i, local_t * l)
 		"	.set	arch=r4000				\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
+			__stringify(LONG_ADDU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
@@ -55,7 +56,7 @@ static __inline__ long local_add_return(long i, local_t * l)
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
+			__stringify(LONG_ADDU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
@@ -88,7 +89,7 @@ static __inline__ long local_sub_return(long i, local_t * l)
 		"	.set	arch=r4000				\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
+			__stringify(LONG_SUBU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
@@ -104,7 +105,7 @@ static __inline__ long local_sub_return(long i, local_t * l)
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 			__SYNC(full, loongson3_war) "			\n"
 		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
+			__stringify(LONG_SUBU)	"	%0, %1, %3	\n"
 			__SC	"%0, %2					\n"
 		"	beqz	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
-- 
2.34.1



