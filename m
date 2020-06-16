Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B811FB711
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbgFPPn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731797AbgFPPn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:43:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4779208E4;
        Tue, 16 Jun 2020 15:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322208;
        bh=Wzn3XjHzpPwQWIlZS8NemT9LPOAPP3EdLDLU/Ufm+nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDHprG/F95CVccpS5MIHgE4jUvu191+cQsJGUe4EqzFA2sKdzfQvsjMl1QPEJHeZy
         AdukwS1sPSQgcXGQp+DYO8EgI3AbZtKerZ+LrrJG8tL9Bb43K3Au/OHeu8JdK10hO3
         T4Ny7WFQyxQsq9g0Qe8VAHTGXwwKkAAcpq2xDOp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 042/163] x86/vdso: Unbreak paravirt VDSO clocks
Date:   Tue, 16 Jun 2020 17:33:36 +0200
Message-Id: <20200616153108.879879486@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 7778d8417b74aded842eeb372961cfc460417fa0 upstream.

The conversion of x86 VDSO to the generic clock mode storage broke the
paravirt and hyperv clocksource logic. These clock sources have their own
internal sequence counter to validate the clocksource at the point of
reading it. This is necessary because the hypervisor can invalidate the
clocksource asynchronously so a check during the VDSO data update is not
sufficient. If the internal check during read invalidates the clocksource
the read return U64_MAX. The original code checked this efficiently by
testing whether the result (casted to signed) is negative, i.e. bit 63 is
set. This was done that way because an extra indicator for the validity had
more overhead.

The conversion broke this check because the check was replaced by a check
for a valid VDSO clock mode.

The wreckage manifests itself when the paravirt clock is installed as a
valid VDSO clock and during runtime invalidated by the hypervisor,
e.g. after a host suspend/resume cycle. After the invalidation the read
function returns U64_MAX which is used as cycles and makes the clock jump
by ~2200 seconds, and become stale until the 2200 seconds have elapsed
where it starts to jump again. The period of this effect depends on the
shift/mult pair of the clocksource and the jumps and staleness are an
artifact of undefined but reproducible behaviour of math overflow.

Implement an x86 version of the new vdso_cycles_ok() inline which adds this
check back and a variant of vdso_clocksource_ok() which lets the compiler
optimize it out to avoid the extra conditional. That's suboptimal when the
system does not have a VDSO capable clocksource, but that's not the case
which is optimized for.

Fixes: 5d51bee725cc ("clocksource: Add common vdso clock mode storage")
Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200606221532.080560273@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/vdso/gettimeofday.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -271,6 +271,24 @@ static __always_inline const struct vdso
 	return __vdso_data;
 }
 
+static inline bool arch_vdso_clocksource_ok(const struct vdso_data *vd)
+{
+	return true;
+}
+#define vdso_clocksource_ok arch_vdso_clocksource_ok
+
+/*
+ * Clocksource read value validation to handle PV and HyperV clocksources
+ * which can be invalidated asynchronously and indicate invalidation by
+ * returning U64_MAX, which can be effectively tested by checking for a
+ * negative value after casting it to s64.
+ */
+static inline bool arch_vdso_cycles_ok(u64 cycles)
+{
+	return (s64)cycles >= 0;
+}
+#define vdso_cycles_ok arch_vdso_cycles_ok
+
 /*
  * x86 specific delta calculation.
  *


