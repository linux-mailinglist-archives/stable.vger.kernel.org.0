Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6470030
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 14:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfGVMwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 08:52:23 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:58069 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfGVMwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 08:52:23 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MysBI-1icPK53l90-00vyTP; Mon, 22 Jul 2019 14:51:48 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        akpm@linux-foundation.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] [v2] ubsan: build ubsan.c more conservatively
Date:   Mon, 22 Jul 2019 14:50:44 +0200
Message-Id: <20190722125139.1335385-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ZbSfErMSYT0XZps8vqU+FdzxiZIIfdRsVbwo2+ZwWA6bzGC/I+J
 KFdIEBcdZUW8aDO6RrtMhqauXy0rH/NfKjfGmJdkiNOSJ6sdejYtP9dfLjtgYCLslrunH9o
 19YhL4jj2fsSiGKT2n+rbI92yJSkhdQoS9MC8aZW/5hAa6/MYJaW1MjL7ikoW258MJ1j+PP
 b0qBCormfF0Ay2Iq69rrg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Fru7WA/0SPY=:vO4Aj/PjqBmpCCbNqTzdyt
 Q6nVC4CU8ncCdVXbm8ukI4ZyQqE//Fg1Ah2aNRoJ4DfapUAnRfr1osMWBFxLya51TxOtb9NUk
 GRz40FOeFIx80pOUfvhhF+tx/IhFoWY1cK9WEr39vVn62G6WnMIrhK4T5oq9yygamIX04E4yR
 3kFacJ7KQyfHeyqShHR9REb1f9viZ6l1kmal0m2hqrw9PEqJIWE5Bxjh+MOyVoPmw95XVh+OW
 VrrwGM3ns9CIUB5rc+G1dMmIKeu6u+QQp845bHrq7/CUrcV7YHW4k710EaRMydfRBhSCaGCVP
 NShVaXH78Fgcg580XfZm/K2WcFynGrXCTzNg8vRBlv0fSGb0BEQL46NMg6vndTS2vY2U215r/
 qIF9/HM+mXd0mRbAyQdvmV+rCXPWw8p6Wp3eIswYqqjAmdJb7zjm836JsIf6bjqFNrXjuCbNo
 jOQEmaLNsk/VnQE0An7GL9XlPpJXfMqIaL2xG0xYImPrxEIWPGKtXE+U/U5f10ZCxJDCEYgSs
 vy2KkPtfigdXkAwDKmW61IgWgYn7r+Ptu1K2rXv9y9UsxbivKSGDx0zVfFpFoVYqUwLcNqlwH
 gob87cPAZ07kHesQoQ/N52T+bj3X9YKlof11u9Ui/6L5f76bITDEdlluo6uRX0rCWjmpGSSM1
 gmqdS4siGLsLPVxRZaVA0hJRPw0OtnP/hCs9JRG/UNiI1rbgwSOZKiJXXiEDrT+YvQRC+MZx0
 qzcwZ+nCd8IvJ43W5K8v4dkSbNg7ahYvXvLqSQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

objtool points out several conditions that it does not like, depending
on the combination with other configuration options and compiler
variants:

stack protector:
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0xbf: call to __stack_chk_fail() with UACCESS enabled
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0xbe: call to __stack_chk_fail() with UACCESS enabled

stackleak plugin:
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled

kasan:
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x25: call to memcpy() with UACCESS enabled
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x25: call to memcpy() with UACCESS enabled

The stackleak and kasan options just need to be disabled for this file
as we do for other files already. For the stack protector, we already
attempt to disable it, but this fails on clang because the check is
mixed with the gcc specific -fno-conserve-stack option. According
to Andrey Ryabinin, that option is not even needed, dropping it here
fixes the stackprotector issue.

Fixes: d08965a27e84 ("x86/uaccess, ubsan: Fix UBSAN vs. SMAP")
Link: https://lore.kernel.org/lkml/20190617123109.667090-1-arnd@arndb.de/t/
Link: https://lore.kernel.org/lkml/20190722091050.2188664-1-arnd@arndb.de/t/
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2:
- drop  -fno-conserve-stack
- fix the Fixes: line
---
 lib/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index 095601ce371d..29c02a924973 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -279,7 +279,8 @@ obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
 obj-$(CONFIG_UBSAN) += ubsan.o
 
 UBSAN_SANITIZE_ubsan.o := n
-CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+KASAN_SANITIZE_ubsan.o := n
+CFLAGS_ubsan.o := $(call cc-option, -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)
 
 obj-$(CONFIG_SBITMAP) += sbitmap.o
 
-- 
2.20.0

