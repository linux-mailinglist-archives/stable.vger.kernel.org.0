Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E3C21FB44
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbgGNTAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731363AbgGNTAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E5B2240B;
        Tue, 14 Jul 2020 19:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753221;
        bh=QQPLdQsHm8zskkrD67gBus4xmrYf5opoihyze2dADgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyPRkjm1tUapovJSag/wYAXQe7idOSzrFLtOezPW9uLztLlL1e9hMdFOOO5gWOzt+
         ojY9CElPuHD/7Rw+uijWFimyVYdCmoleMRFETdYLdqkQpRTBVMiGzVePl/Qv5RWVK6
         zFAZL/gReaP1bwRYHLS0dx43RXSmrV1vuSoq7PVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.7 157/166] arm64: Introduce a way to disable the 32bit vdso
Date:   Tue, 14 Jul 2020 20:45:22 +0200
Message-Id: <20200714184123.341424853@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 97884ca8c2925d14c32188e865069f21378b4b4f upstream.

We have a class of errata (grouped under the ARM64_WORKAROUND_1418040
banner) that force the trapping of counter access from 32bit EL0.

We would normally disable the whole vdso for such defect, except that
it would disable it for 64bit userspace as well, which is a shame.

Instead, add a new vdso_clock_mode, which signals that the vdso
isn't usable for compat tasks.  This gets checked in the new
vdso_clocksource_ok() helper, now provided for the 32bit vdso.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-2-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/vdso/clocksource.h         |    7 +++++--
 arch/arm64/include/asm/vdso/compat_gettimeofday.h |    8 +++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/vdso/clocksource.h
+++ b/arch/arm64/include/asm/vdso/clocksource.h
@@ -2,7 +2,10 @@
 #ifndef __ASM_VDSOCLOCKSOURCE_H
 #define __ASM_VDSOCLOCKSOURCE_H
 
-#define VDSO_ARCH_CLOCKMODES	\
-	VDSO_CLOCKMODE_ARCHTIMER
+#define VDSO_ARCH_CLOCKMODES					\
+	/* vdso clocksource for both 32 and 64bit tasks */	\
+	VDSO_CLOCKMODE_ARCHTIMER,				\
+	/* vdso clocksource for 64bit tasks only */		\
+	VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT
 
 #endif
--- a/arch/arm64/include/asm/vdso/compat_gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
@@ -111,7 +111,7 @@ static __always_inline u64 __arch_get_hw
 	 * update. Return something. Core will do another round and then
 	 * see the mode change and fallback to the syscall.
 	 */
-	if (clock_mode == VDSO_CLOCKMODE_NONE)
+	if (clock_mode != VDSO_CLOCKMODE_ARCHTIMER)
 		return 0;
 
 	/*
@@ -152,6 +152,12 @@ static __always_inline const struct vdso
 	return ret;
 }
 
+static inline bool vdso_clocksource_ok(const struct vdso_data *vd)
+{
+	return vd->clock_mode == VDSO_CLOCKMODE_ARCHTIMER;
+}
+#define vdso_clocksource_ok	vdso_clocksource_ok
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_VDSO_GETTIMEOFDAY_H */


