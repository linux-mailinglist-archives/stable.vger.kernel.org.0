Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B792A477AD4
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 18:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhLPRoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 12:44:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55776 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbhLPRoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 12:44:37 -0500
Date:   Thu, 16 Dec 2021 17:44:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639676676;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMNzzdFVvHgGqj5PmCY/yhVB4p6193MGDumN7XAAmQI=;
        b=umO2xTcPm7QhyESP7qn9sYzEzUbFtCFVTydl7c5BPjjDJKqngq/e4D1QyW1hpJm/C4nk4z
        MdmBIh5+4O0D6jvDl38Pqt0nt1sIpHoewihaQCyHtXJTmVWDywk4z46YnKAAPGVoWRH/EI
        sOfWjI+RUS0xpw3fSmCpYC5C5OTC5nTbKCH+wNhH6EleX6K1cTOp1fDBvWWjSa9xIwE1G2
        y/t5fQPbIAYogDw3GlX8yi3+pA45teHuj7FRJQ7X42A5wDFk0wD+0x4+NgRyZZxgU6g0ZE
        Fuu6hL9JTiN/7cV8Qe7c/MG9SXp8RLrWHvymzGobj+wRodWOquFLBMQB/NU7+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639676676;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMNzzdFVvHgGqj5PmCY/yhVB4p6193MGDumN7XAAmQI=;
        b=4K4LSGLuW7shkYTptQ2Ydg3Rew5jHpEpGxEfq81Wh2kjnoC9cadhw1a4Qy6HEE1wwD1e8F
        CaYto0AmTPkY3bBw==
From:   "tip-bot2 for Andrew Cooper" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pkey: Fix undefined behaviour with PKRU_WD_BIT
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211216000856.4480-1-andrew.cooper3@citrix.com>
References: <20211216000856.4480-1-andrew.cooper3@citrix.com>
MIME-Version: 1.0
Message-ID: <163967667491.23020.16476392644769811399.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7aa3e3011ef3e0a9c36417eafca7894a028e5df6
Gitweb:        https://git.kernel.org/tip/7aa3e3011ef3e0a9c36417eafca7894a028e5df6
Author:        Andrew Cooper <andrew.cooper3@citrix.com>
AuthorDate:    Thu, 16 Dec 2021 00:08:56 
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 16 Dec 2021 09:39:40 -08:00

x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Both __pkru_allows_write() and arch_set_user_pkey_access() shift
PKRU_WD_BIT (a signed constant) by up to 30 bits, hitting the
sign bit.

Use unsigned constants instead.

Clearly pkey 15 has not been used in combination with UBSAN yet.

Noticed by code inspection only.  I can't actually provoke the
compiler into generating incorrect logic as far as this shift is
concerned, so haven't included a fixes tag.

[
  dhansen: add stable@ tag, plus minor changelog massaging,

           For anyone doing backports, these #defines were in
	   arch/x86/include/asm/pgtable.h before 784a46618f6.
]

Fixes: 33a709b25a76 ("mm/gup, x86/mm/pkeys: Check VMAs and PTEs for protection keys")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211216000856.4480-1-andrew.cooper3@citrix.com
---
 arch/x86/include/asm/pkru.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pkru.h b/arch/x86/include/asm/pkru.h
index 4cd49af..74f0a2d 100644
--- a/arch/x86/include/asm/pkru.h
+++ b/arch/x86/include/asm/pkru.h
@@ -4,8 +4,8 @@
 
 #include <asm/cpufeature.h>
 
-#define PKRU_AD_BIT 0x1
-#define PKRU_WD_BIT 0x2
+#define PKRU_AD_BIT 0x1u
+#define PKRU_WD_BIT 0x2u
 #define PKRU_BITS_PER_PKEY 2
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
