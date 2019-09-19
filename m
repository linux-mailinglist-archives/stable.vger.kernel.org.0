Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80B5B860D
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406768AbfISWWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404758AbfISWWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:22:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B487721924;
        Thu, 19 Sep 2019 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931727;
        bh=yS15S4ft0wc0riRxiATHhmn5nzjFhfv4vQg+5N7czZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZy4+Rzio2YFRTax7RWQkdHt4FijROxh/PSmcfduNFu6uv94uJnp60GLWcESKtC7M
         BOuoMcCQM9bpHFZttiuuJ9kQdRiSDyezaV3Z04ITnrIsJ0qO5SkKe4Ez6xn0Va7fv6
         PasEC/ZuM44Vg8/Wh7ReKfXjuTZeDlW3GkM30+V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 18/56] MIPS: VDSO: Prevent use of smp_processor_id()
Date:   Fri, 20 Sep 2019 00:03:59 +0200
Message-Id: <20190919214753.303821133@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit 351fdddd366245c0fb4636f32edfb4198c8d6b8c upstream.

VDSO code should not be using smp_processor_id(), since it is executed
in user mode.
Introduce a VDSO-specific path which will cause a compile-time
or link-time error (depending upon support for __compiletime_error) if
the VDSO ever incorrectly attempts to use smp_processor_id().

[Matt Redfearn <matt.redfearn@imgtec.com>: Move before change to
smp_processor_id in series]

Signed-off-by: Paul Burton <paul.burton@mips.com>
Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/17932/
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/smp.h |   12 +++++++++++-
 arch/mips/vdso/Makefile     |    3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -25,7 +25,17 @@ extern cpumask_t cpu_sibling_map[];
 extern cpumask_t cpu_core_map[];
 extern cpumask_t cpu_foreign_map;
 
-#define raw_smp_processor_id() (current_thread_info()->cpu)
+static inline int raw_smp_processor_id(void)
+{
+#if defined(__VDSO__)
+	extern int vdso_smp_processor_id(void)
+		__compiletime_error("VDSO should not call smp_processor_id()");
+	return vdso_smp_processor_id();
+#else
+	return current_thread_info()->cpu;
+#endif
+}
+#define raw_smp_processor_id raw_smp_processor_id
 
 /* Map from cpu id to sequential logical cpu number.  This will only
    not be idempotent when cpus failed to come on-line.	*/
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -6,7 +6,8 @@ ccflags-vdso := \
 	$(filter -I%,$(KBUILD_CFLAGS)) \
 	$(filter -E%,$(KBUILD_CFLAGS)) \
 	$(filter -mmicromips,$(KBUILD_CFLAGS)) \
-	$(filter -march=%,$(KBUILD_CFLAGS))
+	$(filter -march=%,$(KBUILD_CFLAGS)) \
+	-D__VDSO__
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
 	-O2 -g -fPIC -fno-strict-aliasing -fno-common -fno-builtin -G 0 \


