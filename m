Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8E499DD4
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393017AbfHVRpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731760AbfHVRXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:02 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2886923405;
        Thu, 22 Aug 2019 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494581;
        bh=d4aXzbNgr0rYiq6xmLABKv62VPP5r1AMuZX8nIKaVVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8DkKAiGIz8oTT9rXLLBQsQ/CApUIv6O3xdDKf/7dHtehuFfVxG5gNwYnYPrqlfwB
         w20ecfOIPoKoaPBrIm3EoCYS1y5f+gKbMnylbqMubWXtHtOhgY7be+ZNUn5IYzMLCh
         1B69vehjSh9xcQbiigYGE5+wpDX5h0xVEYkRsZ28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 73/78] x86/boot: Disable the address-of-packed-member compiler warning
Date:   Thu, 22 Aug 2019 10:19:17 -0700
Message-Id: <20190822171834.147513311@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

commit 20c6c189045539d29f4854d92b7ea9c329e1edfc upstream.

The clang warning 'address-of-packed-member' is disabled for the general
kernel code, also disable it for the x86 boot code.

This suppresses a bunch of warnings like this when building with clang:

./arch/x86/include/asm/processor.h:535:30: warning: taking address of
  packed member 'sp0' of class or structure 'x86_hw_tss' may result in an
  unaligned pointer value [-Waddress-of-packed-member]
    return this_cpu_read_stable(cpu_tss.x86_tss.sp0);
                                ^~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/percpu.h:391:59: note: expanded from macro
  'this_cpu_read_stable'
    #define this_cpu_read_stable(var)       percpu_stable_op("mov", var)
                                                                    ^~~
./arch/x86/include/asm/percpu.h:228:16: note: expanded from macro
  'percpu_stable_op'
    : "p" (&(var)));
             ^~~

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20170725215053.135586-1-mka@chromium.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -30,6 +30,7 @@ KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
+KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n


