Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBCC23381A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 20:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgG3SDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 14:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730204AbgG3SDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 14:03:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBCDC061574
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 11:03:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x10so16198026ybj.19
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 11:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RKbdLkq470ddFEAhoN8dslKMFuIe6gCNhu2f+gFLXbo=;
        b=AYXD98CYJaxvZj351bCuwkKEgAp6qB/0qN45oav4U0Nku0PPI6vQQepfwhNZwK5CzC
         52/y5L32aXsIbe29yg94Cqy9MvAEm96xKtPkB2dSYH2KycwLmjduog0vbxc4ojTa/V+E
         9CPEXlIfrIkVGaC5PRqvkOHDAPKdVv8YpTYlYaaISqauubNyhXD+gI8+5K7xiQpSFoz+
         JjlCnAGoRSbZD06iL62nOu+N8EjiYphpi1xa8+zL9hYs/HsVMYTRTP40c++87vPuOGLS
         bPFcimYL5LPAweRbKHbAzuI8iG0BUkR1QgPxWFwwqpHV0Czt54NauY+hefqA3c3ViC2U
         XWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RKbdLkq470ddFEAhoN8dslKMFuIe6gCNhu2f+gFLXbo=;
        b=UpiswCngoVoL4qVDYaJaeYdlBelXOmijYwhgznMJms/BsfAFG5iKpPzOYd+VsEULPM
         tboUwjMPyR81QMuj4XZMKIVL6E1HK/XHXHapFc8cydXA28VjFN23aUzN0ZVRPdI53iBg
         bUjxttoBspdr39bh8tlTN6DF/PcXvmlE4l/yDYoqk65k2NQAx+G6NfelApgxQPUeQW1/
         59EpxO45MnbAWMb5gMLL/K/9GdvJpKRlvMEO6vH0BcoO/av7pvP3KfhH2BIcV+7+YIeY
         YovxYjZwd2NFH9FXKC+hQh4bq2xrdR5x9d1I/TV8EZrJda2drZIfRyfTz7DBi6Tefy9S
         cItA==
X-Gm-Message-State: AOAM531pw5gfbA+0kxcn8N/dmgqZqaC8FHCxLEIKex0KCOhfr7c5Tixr
        rwWrGDID1GHa3F26Jt5JXTv2q1u1Dt7Xllqt2w1AxeIW1QyDbHi95gRI9sCaRQDB41+sbXZQ93g
        8A5WlFdsjZgqvaOhACpAO40CTk8G4WCuNsvr+YlnBwPj3R/ZUGTt1pjq10R+Kd6YnEUAoqW+6zq
        UVpA==
X-Google-Smtp-Source: ABdhPJwWTOk5Rkil7/YZB1kpbcZdwuN6b1zKF45bHRzQiMgMlQ2K+j2K8dSQLCmCxzkuQHpG2duUO4m3x9YzGPiAN/Y=
X-Received: by 2002:a25:f40a:: with SMTP id q10mr172146ybd.192.1596132221796;
 Thu, 30 Jul 2020 11:03:41 -0700 (PDT)
Date:   Thu, 30 Jul 2020 11:03:40 -0700
Message-Id: <20200730180340.1724137-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH 4.14.y] ARM: 8702/1: head-common.S: Clear lr before jumping to start_kernel()
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     stable@vger.kernel.org
Cc:     Miles Chen <miles.chen@mediatek.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nicolas Pitre <nico@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 59b6359dd92d18f5dc04b14a4c926fa08ab66f7c upstream.

If CONFIG_DEBUG_LOCK_ALLOC=y, the kernel log is spammed with a few
hundred identical messages:

    unwind: Unknown symbol address c0800300
    unwind: Index not found c0800300

c0800300 is the return address from the last subroutine call (to
__memzero()) in __mmap_switched().  Apparently having this address in
the link register confuses the unwinder.

To fix this, reset the link register to zero before jumping to
start_kernel().

Fixes: 9520b1a1b5f7a348 ("ARM: head-common.S: speed up startup code")
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Looks like this first landed in v4.15-rc1.  Without this, we can't tell
during an unwind initiated from start_kernel() when to stop unwinding,
which for the clang specific implementation of the arm frame pointer
unwinder leads to dereferencing a garbage value, triggering an exception
which has no fixup, triggering a panic, triggering an unwind, triggering
an infinite loop that prevents booting. I have more patches to send
upstream to make the unwinder more resilient, but it's ambiguous as to
when to stop unwinding without this patch.

 arch/arm/kernel/head-common.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 7e662bdd5cb3..932b2244e709 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -101,6 +101,7 @@ __mmap_switched:
 	str	r2, [r6]			@ Save atags pointer
 	cmp	r7, #0
 	strne	r0, [r7]			@ Save control register values
+	mov	lr, #0
 	b	start_kernel
 ENDPROC(__mmap_switched)
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

