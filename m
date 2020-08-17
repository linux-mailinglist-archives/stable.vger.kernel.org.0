Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E124708A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390444AbgHQSLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388281AbgHQQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A92420866;
        Mon, 17 Aug 2020 16:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680422;
        bh=F3hGrF7cMPs0Zativ+0w34SfGFDKisWaCsceG/QxuSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ru7FXo6ServxVol8zEVPQLaCHr8Gdhp9Mu1JyiF6EJFZNSKGfQRW9HNycfqw+TZQ+
         tsIvudWsv6v3rQJGi6nP0wf9MAdS4fM6p8bmrqN73we3Z+3ePElfKn67J3e/KK2r5W
         Ujdui+8j18y3qI2+U+9Gayag1vh4s7vjSXxwxHBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/270] powerpc/32s: Fix CONFIG_BOOK3S_601 uses
Date:   Mon, 17 Aug 2020 17:16:21 +0200
Message-Id: <20200817143804.770051937@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit df4d4ef22446b3a789a4efd74d34f2ec1e24deb2 ]

We have two uses of CONFIG_BOOK3S_601, which doesn't exist. Fix them
to use CONFIG_PPC_BOOK3S_601 which is the correct symbol.

Fixes: 12c3f1fd87bf ("powerpc/32s: get rid of CPU_FTR_601 feature")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200724131728.1643966-5-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/ptrace.h | 2 +-
 arch/powerpc/include/asm/timex.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index ee3ada66deb58..c41220f4aad9e 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -203,7 +203,7 @@ do {									      \
 #endif /* __powerpc64__ */
 
 #define arch_has_single_step()	(1)
-#ifndef CONFIG_BOOK3S_601
+#ifndef CONFIG_PPC_BOOK3S_601
 #define arch_has_block_step()	(true)
 #else
 #define arch_has_block_step()	(false)
diff --git a/arch/powerpc/include/asm/timex.h b/arch/powerpc/include/asm/timex.h
index d2d2c4bd84358..6047402b0a4db 100644
--- a/arch/powerpc/include/asm/timex.h
+++ b/arch/powerpc/include/asm/timex.h
@@ -17,7 +17,7 @@ typedef unsigned long cycles_t;
 
 static inline cycles_t get_cycles(void)
 {
-	if (IS_ENABLED(CONFIG_BOOK3S_601))
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S_601))
 		return 0;
 
 	return mftb();
-- 
2.25.1



