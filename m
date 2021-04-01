Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B45351871
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 19:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhDARpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbhDARkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 13:40:41 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F73BC031167
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 09:51:34 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u12so3544171pgr.3
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 09:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9vTU0L/T7IngBBh2gwOaqiBEmh3tpZ/KoOkiMOuv1Qw=;
        b=ZP3U/hoI3nkqb4bVctDkhc9JgAzWXkyhLBm9pBjaUFdnV0XOjjJaKKF5lt0ns9hoZ0
         SI7oUdqL1IdOzUY0bEs3zWF2gP0aVdJvo2bu2rHLew8j5yVfHQTgi+GZ6PBUU7OkPLut
         2P/VjEVY5LLf6vMrebN3g8BwOyyhWPAwPhinTC1RrLFwPD1HiZr7bChVIG7cMRkUnAL2
         I5hXaYX9P9HEmE2RYNIVufMAFFKJvP/4Cgih3h+fcFMlmMtgPtyKk4buunWJoVctPLh9
         5Rp+K/ErAGzZIm/dWcW9B9YeqOj4yZuDuK3qVg/wS8yD75bGWYwA8FAD/i4Jnx40LoCf
         gH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9vTU0L/T7IngBBh2gwOaqiBEmh3tpZ/KoOkiMOuv1Qw=;
        b=nHkqlCk6eUTnAjQkdhesO+qtaVrQ/FYtcB/3fOtRLzY2Ok2rJ8DycNsbllyfiDHWVE
         6sx1zFVHQ254LL0vWBkMB0Q8XcPvvZ7A3ZRBrYV1RBi0vyTP1oruFVA0goYJCNjbTYtP
         QXU8AS5bxqDd7hD17vteTgo7EWDmT0A9B8FeigvPWsueCwHp3/lmOgwpAPvGCCYLdFWT
         9xjJeQ3fHIDq2kWQrzMG8vj157TLGT8oKQcMDrciRYVSelDAsvCMUE+IpxEJAXCVROHP
         ju7soKAYmocTVlDge06j6s8VHvBkHlI5MA80sy396Eh0wyUUOfTslP5vjuWwy7YMACOa
         yQZQ==
X-Gm-Message-State: AOAM531GSaG00CvXILUHT2N52HCEIwqligGkSdtelr0cTn1q0iHKDj92
        vTMw1lAoLrplFRDKJa0rh5ux7a0=
X-Google-Smtp-Source: ABdhPJz22djsWCBeTCZsjWJqO0jJh5CTzU1OcoH9V4YF+J5lglwwH1BzisGEtRPrRZyJ4a3W7FIanfY=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:0:3dc0:b59f:6f36:16d2])
 (user=pcc job=sendgmr) by 2002:a17:902:e051:b029:e7:37d9:f32e with SMTP id
 x17-20020a170902e051b02900e737d9f32emr8698748plx.78.1617295893619; Thu, 01
 Apr 2021 09:51:33 -0700 (PDT)
Date:   Thu,  1 Apr 2021 09:51:10 -0700
Message-Id: <20210401165110.3952103-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH] arm64: fix inline asm in load_unaligned_zeropad()
From:   Peter Collingbourne <pcc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The inline asm's addr operand is marked as input-only, however in
the case where an exception is taken it may be modified by the BIC
instruction on the exception path. Fix the problem by using a temporary
register as the destination register for the BIC instruction.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org
Link: https://linux-review.googlesource.com/id/I84538c8a2307d567b4f45bb20b715451005f9617
---
 arch/arm64/include/asm/word-at-a-time.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/word-at-a-time.h b/arch/arm64/include/asm/word-at-a-time.h
index 3333950b5909..ea487218db79 100644
--- a/arch/arm64/include/asm/word-at-a-time.h
+++ b/arch/arm64/include/asm/word-at-a-time.h
@@ -53,7 +53,7 @@ static inline unsigned long find_zero(unsigned long mask)
  */
 static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
-	unsigned long ret, offset;
+	unsigned long ret, tmp;
 
 	/* Load word from unaligned pointer addr */
 	asm(
@@ -61,9 +61,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"2:\n"
 	"	.pushsection .fixup,\"ax\"\n"
 	"	.align 2\n"
-	"3:	and	%1, %2, #0x7\n"
-	"	bic	%2, %2, #0x7\n"
-	"	ldr	%0, [%2]\n"
+	"3:	bic	%1, %2, #0x7\n"
+	"	ldr	%0, [%1]\n"
+	"	and	%1, %2, #0x7\n"
 	"	lsl	%1, %1, #0x3\n"
 #ifndef __AARCH64EB__
 	"	lsr	%0, %0, %1\n"
@@ -73,7 +73,7 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"	b	2b\n"
 	"	.popsection\n"
 	_ASM_EXTABLE(1b, 3b)
-	: "=&r" (ret), "=&r" (offset)
+	: "=&r" (ret), "=&r" (tmp)
 	: "r" (addr), "Q" (*(unsigned long *)addr));
 
 	return ret;
-- 
2.31.0.291.g576ba9dcdaf-goog

