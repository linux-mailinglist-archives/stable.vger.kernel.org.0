Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD06FBE2
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 11:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfGVJL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 05:11:26 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:35353 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbfGVJL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 05:11:26 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N3bb1-1iXnOP1GRX-010ghb; Mon, 22 Jul 2019 11:11:02 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        akpm@linux-foundation.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Sodagudi Prasad <psodagud@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] ubsan: build ubsan.c more conservatively
Date:   Mon, 22 Jul 2019 11:10:18 +0200
Message-Id: <20190722091050.2188664-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:JRfD2+R8cl2MpZ0Zaxxg8tUpm69nNkWykZmnDl1qh32EVPdlKtE
 feSJZgESNtHDb2ndZGxg9yLvPE3xOaO/zQ6RIFEl59plmT0MYDgVWRxeD2ia6fgtqKP96pZ
 c3a9q9oTdIKkeVckRiZ85phK58GVGTCqUxQ19o6DYjM6emumoqVfTCEpJNZU8I9HbMLNK0j
 SG7WTRjuVhHqmFl1VMLLg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iYdJrXJ7yi8=:+VQeBL+nIZ99R9qas4XCAf
 JVehlIWqUOXYHMbMds8Lk6aF1ARdIDjQRiz3IgnzlLpuyx6Lh8BwzXxwpVLRJkDISxElGyZqZ
 tCo4+uvUoJqrT7IezXOLCMDX+pYKj62Qu04HNg2bhhf+zcxE8ZbRBgWq6Qqu4k3e3vqxF5Tpg
 dJ0jcz4AUzqn3e4PpHGxqRnFfGyfmkXqMjbLF6pjGIWYjdd2L/hY04IM4gtlNdY881Q9ztYV0
 hvublVP6vIuStwuNKsid45s1GhqknIakTpgAl7ralnEoX7nIJFRCW3A8nmHpR4kpGb4vKORd7
 FddKLU5zEzib5E80VV5NvXSuZozdLxoATZ9lZajNj8RjrahzoKiX0/0n7N4fiEXNyECqTUkdn
 qLkHOsI6THRAhD3Ga8ksZQRfFkezZHHzpp31COWftnXj8AZLodKh7K5ZvQCWMlBVofclfhHiR
 ndHO12eg6A9ChqN/1xqhj2DiquLQOLPB9sVdAGYHSNYXVrUiINY2XRg7pLk52KMdtQn+MFa/o
 XU9vI7AfHQWK1MzqlFT1d41nVRvp7+5vAQ4KZcgqL952lCzbyiF/sdNcOJteN9NnCFVQ5DD/e
 83Mp+jdKnCj116HLHJak0Ed1tFSNlvJow5hw2Qu0Biyv3kLNIFQo7THz8c2OfzOzke92odu8Q
 eH2b37g4p1ih79+wLl3nNSVZtguQ371lSgzu8LMjnwra8iPTrs3mHzecal76nXpt0q8YkKqK8
 RHQHOpj8iiipJxOTicd3LWlcOsbIY90Wj4/GwQ==
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
mixed with the gcc specific -fno-conserve-stack option, so we need to
test them separately.

Fixes: 42440c1f9911 ("lib/ubsan: add type mismatch handler for new GCC/Clang")
Link: https://lore.kernel.org/lkml/20190617123109.667090-1-arnd@arndb.de/t/
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index 095601ce371d..320e3b632dd3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -279,7 +279,8 @@ obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
 obj-$(CONFIG_UBSAN) += ubsan.o
 
 UBSAN_SANITIZE_ubsan.o := n
-CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+KASAN_SANITIZE_ubsan.o := n
+CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack) $(call cc-option, -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)
 
 obj-$(CONFIG_SBITMAP) += sbitmap.o
 
-- 
2.20.0

