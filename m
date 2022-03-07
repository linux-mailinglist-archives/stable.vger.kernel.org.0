Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080ED4CF74F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbiCGJpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241031AbiCGJlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CC76D4E5;
        Mon,  7 Mar 2022 01:39:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86808B80F9F;
        Mon,  7 Mar 2022 09:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB5CC340F3;
        Mon,  7 Mar 2022 09:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645960;
        bh=dLkJHSehkvwf6TVlYKXzLag1jRfBp/iDlklf0WRr+0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgP7/r19XFBUNpsyxOgroVwO/0zBxRXms+ZmGfIu1RUl2aRwVkiMVzhAUK2r5fN3X
         et1al/B2scbfv1/Ms/m5O65wPTM5r+DhpriHLXwmUmYvCTU9I58feJpjesABevs0Xb
         7MApC4nsDzkvEJ44p6Zukoybe00MZmO6Ueq0COVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/262] MIPS: fix local_{add,sub}_return on MIPS64
Date:   Mon,  7 Mar 2022 10:16:33 +0100
Message-Id: <20220307091703.904636269@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



