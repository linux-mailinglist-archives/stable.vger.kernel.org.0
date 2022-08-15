Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A814593AC8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345502AbiHOT5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346073AbiHOT5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C1578235;
        Mon, 15 Aug 2022 11:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84C5AB810A2;
        Mon, 15 Aug 2022 18:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECC6C433D7;
        Mon, 15 Aug 2022 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589572;
        bh=kzeU9tDf5ZnnhwhFYJgUGea/xFAtBz4ef9sqrhgUL+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1uBCdzG0JbezJIZZVk7UB0cpyBbkfMMGXDLyOBvsJGdIKawsLLx7EgTSGAxW5m6m
         5N0SQTGVAcYNtT7IyrPYyXf9isTWp82awHww/Oq02ZuzVG7TQdQst7KZFM7SNbLUB7
         ylRfvUIcf9IANMBZPQvqnW6IJtLiukMAqQ/9Pa9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 759/779] powerpc: Fix eh field when calling lwarx on PPC32
Date:   Mon, 15 Aug 2022 20:06:43 +0200
Message-Id: <20220815180409.887837961@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 18db466a9a306406dab3b134014d9f6ed642471c upstream.

Commit 9401f4e46cf6 ("powerpc: Use lwarx/ldarx directly instead of
PPC_LWARX/LDARX macros") properly handled the eh field of lwarx
in asm/bitops.h but failed to clear it for PPC32 in
asm/simple_spinlock.h

So, do as in arch_atomic_try_cmpxchg_lock(), set it to 1 if PPC64
but set it to 0 if PPC32. For that use IS_ENABLED(CONFIG_PPC64) which
returns 1 when CONFIG_PPC64 is set and 0 otherwise.

Fixes: 9401f4e46cf6 ("powerpc: Use lwarx/ldarx directly instead of PPC_LWARX/LDARX macros")
Cc: stable@vger.kernel.org # v5.15+
Reported-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
[mpe: Use symbolic names, use 'n' constraint per Segher]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a1176e19e627dd6a1b8d24c6c457a8ab874b7d12.1659430931.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/simple_spinlock.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/simple_spinlock.h
+++ b/arch/powerpc/include/asm/simple_spinlock.h
@@ -48,10 +48,11 @@ static inline int arch_spin_is_locked(ar
 static inline unsigned long __arch_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long tmp, token;
+	unsigned int eh = IS_ENABLED(CONFIG_PPC64);
 
 	token = LOCK_TOKEN;
 	__asm__ __volatile__(
-"1:	lwarx		%0,0,%2,1\n\
+"1:	lwarx		%0,0,%2,%[eh]\n\
 	cmpwi		0,%0,0\n\
 	bne-		2f\n\
 	stwcx.		%1,0,%2\n\
@@ -59,7 +60,7 @@ static inline unsigned long __arch_spin_
 	PPC_ACQUIRE_BARRIER
 "2:"
 	: "=&r" (tmp)
-	: "r" (token), "r" (&lock->slock)
+	: "r" (token), "r" (&lock->slock), [eh] "n" (eh)
 	: "cr0", "memory");
 
 	return tmp;
@@ -177,9 +178,10 @@ static inline void arch_spin_unlock(arch
 static inline long __arch_read_trylock(arch_rwlock_t *rw)
 {
 	long tmp;
+	unsigned int eh = IS_ENABLED(CONFIG_PPC64);
 
 	__asm__ __volatile__(
-"1:	lwarx		%0,0,%1,1\n"
+"1:	lwarx		%0,0,%1,%[eh]\n"
 	__DO_SIGN_EXTEND
 "	addic.		%0,%0,1\n\
 	ble-		2f\n"
@@ -187,7 +189,7 @@ static inline long __arch_read_trylock(a
 	bne-		1b\n"
 	PPC_ACQUIRE_BARRIER
 "2:"	: "=&r" (tmp)
-	: "r" (&rw->lock)
+	: "r" (&rw->lock), [eh] "n" (eh)
 	: "cr0", "xer", "memory");
 
 	return tmp;
@@ -200,17 +202,18 @@ static inline long __arch_read_trylock(a
 static inline long __arch_write_trylock(arch_rwlock_t *rw)
 {
 	long tmp, token;
+	unsigned int eh = IS_ENABLED(CONFIG_PPC64);
 
 	token = WRLOCK_TOKEN;
 	__asm__ __volatile__(
-"1:	lwarx		%0,0,%2,1\n\
+"1:	lwarx		%0,0,%2,%[eh]\n\
 	cmpwi		0,%0,0\n\
 	bne-		2f\n"
 "	stwcx.		%1,0,%2\n\
 	bne-		1b\n"
 	PPC_ACQUIRE_BARRIER
 "2:"	: "=&r" (tmp)
-	: "r" (token), "r" (&rw->lock)
+	: "r" (token), "r" (&rw->lock), [eh] "n" (eh)
 	: "cr0", "memory");
 
 	return tmp;


