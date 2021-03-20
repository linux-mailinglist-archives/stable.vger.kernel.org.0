Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127E6342A5E
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 05:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCTERD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 00:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhCTEQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 00:16:41 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34252C061762
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 21:16:41 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l123so7247404pfl.8
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 21:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouW7w1tJWbMBvkhdIE4FNoeWEk82Uxbfl+Y1tFiGtH8=;
        b=GaR+AlXSZ33dTxAXj2aQHNsb/sGlsgOLi4SYfJYpDeQ41vo5yOlbpjw4vqeKO6cOg4
         Jwab7ZTirHmKX0QkEAs6s5nMXaMkHvyvNTDPe9qDsvb6q4qO6bCoL30EUYZeTFe/sDZJ
         KHCA8IZ67qajMR7PT+Sh5vGYLDEFNJSP27mII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouW7w1tJWbMBvkhdIE4FNoeWEk82Uxbfl+Y1tFiGtH8=;
        b=DleLDMsPIvQ0xL1F4Z9tWQz3jasvxf8sd57tLgK35Cj6PnRTuO2qXp4UJ30RjaEE46
         JW7hhqsDX9uE7TwjeWFAtHTXCbunlF5K7AQTx4gu8Swh4PTJeuPHEdhmX1Lx8zBd8AdJ
         hP0WlYzu54JJBORYlG9LzM/hqsKoQxwnn/qnni2gCRjWTOrH4tDKJSlAP0nXshSeShEV
         4APkBMNFCTJ8yehkwKnqycVWG8zFBfyluVGyYaNIRNH4tlW4wGxk60+k0PBr7O6rF/Si
         6paQ8HB6Hl+zfLrvUWSCD5ltRvYIJs52vzJ0ArJ7RmtQGuyvkvjUAgJtI4s5tt8NDxzf
         JTOw==
X-Gm-Message-State: AOAM530K+9OLzG+2UPx5grWI4YDhmYW1VCMoxGvnjMlByk41Tji6bLd3
        ratn3HvVLrcCEEKq1+WOC7lIgRWpnUHkhw==
X-Google-Smtp-Source: ABdhPJyuVJUZTJmCmSbcUFGQVZHQYq/vnOWl4IN/MCtT7KdD0RfsEBPHuUvCBSAo8mGviV9bc7WcPA==
X-Received: by 2002:a62:7708:0:b029:1ee:f656:51d5 with SMTP id s8-20020a6277080000b02901eef65651d5mr12471549pfc.59.1616213800520;
        Fri, 19 Mar 2021 21:16:40 -0700 (PDT)
Received: from drinkcat2.tpe.corp.google.com ([2401:fa00:1:b:f0c7:e1f7:948e:d8d5])
        by smtp.gmail.com with ESMTPSA id s62sm6998869pfb.148.2021.03.19.21.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 21:16:40 -0700 (PDT)
From:   Nicolas Boichat <drinkcat@chromium.org>
To:     stable@vger.kernel.org
Cc:     groeck@chromium.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [for-stable-4.19 PATCH v2 2/2] lkdtm: don't move ctors to .rodata
Date:   Sat, 20 Mar 2021 12:16:26 +0800
Message-Id: <20210320121614.for-stable-4.19.v2.2.I0387622b15d84eed675e48a0ba3be9c03b9f9e97@changeid>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210320041626.885806-1-drinkcat@chromium.org>
References: <20210320041626.885806-1-drinkcat@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 3f618ab3323407ee4c6a6734a37eb6e9663ebfb9 upstream.

When building with KASAN and LKDTM, clang may implictly generate an
asan.module_ctor function in the LKDTM rodata object. The Makefile moves
the lkdtm_rodata_do_nothing() function into .rodata by renaming the
file's .text section to .rodata, and consequently also moves the ctor
function into .rodata, leading to a boot time crash (splat below) when
the ctor is invoked by do_ctors().

Let's prevent this by marking the function as noinstr rather than
notrace, and renaming the file's .noinstr.text to .rodata. Marking the
function as noinstr will prevent tracing and kprobes, and will inhibit
any undesireable compiler instrumentation.

The ctor function (if any) will be placed in .text and will work
correctly.

Example splat before this patch is applied:

[    0.916359] Unable to handle kernel execute from non-executable memory at virtual address ffffa0006b60f5ac
[    0.922088] Mem abort info:
[    0.922828]   ESR = 0x8600000e
[    0.923635]   EC = 0x21: IABT (current EL), IL = 32 bits
[    0.925036]   SET = 0, FnV = 0
[    0.925838]   EA = 0, S1PTW = 0
[    0.926714] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000427b3000
[    0.928489] [ffffa0006b60f5ac] pgd=000000023ffff003, p4d=000000023ffff003, pud=000000023fffe003, pmd=0068000042000f01
[    0.931330] Internal error: Oops: 8600000e [#1] PREEMPT SMP
[    0.932806] Modules linked in:
[    0.933617] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.0-rc7 #2
[    0.935620] Hardware name: linux,dummy-virt (DT)
[    0.936924] pstate: 40400005 (nZcv daif +PAN -UAO -TCO BTYPE=--)
[    0.938609] pc : asan.module_ctor+0x0/0x14
[    0.939759] lr : do_basic_setup+0x4c/0x70
[    0.940889] sp : ffff27b600177e30
[    0.941815] x29: ffff27b600177e30 x28: 0000000000000000
[    0.943306] x27: 0000000000000000 x26: 0000000000000000
[    0.944803] x25: 0000000000000000 x24: 0000000000000000
[    0.946289] x23: 0000000000000001 x22: 0000000000000000
[    0.947777] x21: ffffa0006bf4a890 x20: ffffa0006befb6c0
[    0.949271] x19: ffffa0006bef9358 x18: 0000000000000068
[    0.950756] x17: fffffffffffffff8 x16: 0000000000000000
[    0.952246] x15: 0000000000000000 x14: 0000000000000000
[    0.953734] x13: 00000000838a16d5 x12: 0000000000000001
[    0.955223] x11: ffff94000da74041 x10: dfffa00000000000
[    0.956715] x9 : 0000000000000000 x8 : ffffa0006b60f5ac
[    0.958199] x7 : f9f9f9f9f9f9f9f9 x6 : 000000000000003f
[    0.959683] x5 : 0000000000000040 x4 : 0000000000000000
[    0.961178] x3 : ffffa0006bdc15a0 x2 : 0000000000000005
[    0.962662] x1 : 00000000000000f9 x0 : ffffa0006bef9350
[    0.964155] Call trace:
[    0.964844]  asan.module_ctor+0x0/0x14
[    0.965895]  kernel_init_freeable+0x158/0x198
[    0.967115]  kernel_init+0x14/0x19c
[    0.968104]  ret_from_fork+0x10/0x30
[    0.969110] Code: 00000003 00000000 00000000 00000000 (00000000)
[    0.970815] ---[ end trace b5339784e20d015c ]---

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20201207170533.10738-1-mark.rutland@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
---

(no changes since v1)

 drivers/misc/lkdtm/Makefile | 2 +-
 drivers/misc/lkdtm/rodata.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index cce47a15a79f..aeb960cb096d 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -13,7 +13,7 @@ KCOV_INSTRUMENT_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-			--rename-section .text=.rodata,alloc,readonly,load
+			--rename-section .noinstr.text=.rodata,alloc,readonly,load
 targets += rodata.o rodata_objcopy.o
 $(obj)/rodata_objcopy.o: $(obj)/rodata.o FORCE
 	$(call if_changed,objcopy)
diff --git a/drivers/misc/lkdtm/rodata.c b/drivers/misc/lkdtm/rodata.c
index 58d180af72cf..baacb876d1d9 100644
--- a/drivers/misc/lkdtm/rodata.c
+++ b/drivers/misc/lkdtm/rodata.c
@@ -5,7 +5,7 @@
  */
 #include "lkdtm.h"
 
-void notrace lkdtm_rodata_do_nothing(void)
+void noinstr lkdtm_rodata_do_nothing(void)
 {
 	/* Does nothing. We just want an architecture agnostic "return". */
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

