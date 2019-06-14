Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D88145287
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfFNDNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39758 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id j2so494514pfe.6
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jfnhx8qRw0jZ5LbGeW1WuYGyQJR2HfAomwQkRmg+oIk=;
        b=qJNBo0b4V/Cci6PjOFqtp7KxCk67ZIcnOyB16a8gon1qTpdr5xVxqrLnuWhqdFNwaM
         4IEiF02Kn66h2IT/dqtvYoVprY7kDlQ3auUSd+gCtWOisbg3BgIPgILlxtw7cDwDr6+5
         g3nUolw2TIhK6XAkhpzGrNxgTZe7gE4zG9rEHDINQZN8VA4O0bincWY61fE2whJrQnSy
         lLQ/VStv4avbGajJPyQab9L+Oae6AfdvNq2E4BHs1JvdYc45Qqpn5w+RI8Lr12aKqcpx
         jFPB4dwrBlFEulIsMgEH65dAPjlFyGx0mSWMJ2ZfixT02mGRRFp71hURgCO3Re6U5FoX
         6WNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jfnhx8qRw0jZ5LbGeW1WuYGyQJR2HfAomwQkRmg+oIk=;
        b=mqbVeCwaen30ubVDCShVLTX+d4MPcYCUBe9Zl9itXg9ujtLvE5DY/h/1x/tUhxYbyS
         ePBGxDr22SQkiy6wyWZ2VMGVhuwM3GVt3Qlfc9Se/7BhxUzMPBwt3FaU3u4qJCQ83Pzx
         jXw/c2Hqegd9N/IbkH2+e7tSEFqEtezTnYtoHB/pWsckm/DPW0ZB5qd4hmcfJ8LJCpGD
         YpNMvPEtK9LUiowP9XWo1cNL9PqY5tmIr9+kT8x8oFeKQUoOc5nf904Qd7UYJgNwNCqS
         LgCnde6OEoswQch43exegc0y4DZEvG00xBLFNedIaT5LWQFIwkQxcu0ccV+nQ8W6/dOu
         fnVQ==
X-Gm-Message-State: APjAAAWandQJpw6BwlDWT5wPrFPX/JNvRbaQ5e8uRwJ0HUavOKDvXESY
        1KpcWlTmGSnZoRA+BrsXtXgU9A==
X-Google-Smtp-Source: APXvYqy15f2JPOdFqBo2EZqq1Wijt1qcjXvFmXzWd9/Lc9RNPpfHv8WWo29ohtqmAJjjp8ci4qcIow==
X-Received: by 2002:a65:6295:: with SMTP id f21mr34672569pgv.416.1560482014249;
        Thu, 13 Jun 2019 20:13:34 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id j8sm999110pfi.148.2019.06.13.20.13.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:33 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 38/45] arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling
Date:   Fri, 14 Jun 2019 08:38:21 +0530
Message-Id: <d46e18606161998259bad6926ffb0f388ebf9c27.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit f72af90c3783d924337624659b43e2d36f1b36b4 upstream.

We want SMCCC_ARCH_WORKAROUND_1 to be fast. As fast as possible.
So let's intercept it as early as we can by testing for the
function call number as soon as we've identified a HVC call
coming from the guest.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Made changes to hyp.S instead and fixed registers ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kvm/hyp.S | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 8d3da858c257..8aa2ede8c999 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -15,6 +15,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/linkage.h>
 
 #include <asm/alternative.h>
@@ -974,10 +975,11 @@ el1_sync:					// Guest trapped into EL2
 	lsr	x2, x1, #ESR_ELx_EC_SHIFT
 
 	cmp	x2, #ESR_ELx_EC_HVC64
+	ccmp    x2, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
 
-	mrs	x3, vttbr_el2			// If vttbr is valid, the 64bit guest
-	cbnz	x3, el1_trap			// called HVC
+	mrs     x3, vttbr_el2           // If vttbr is valid, the guest
+	cbnz    x3, el1_hvc_guest       // called HVC
 
 	/* Here, we're pretty sure the host called HVC. */
 	pop	x2, x3
@@ -1003,6 +1005,20 @@ el1_sync:					// Guest trapped into EL2
 	pop	lr, xzr
 2:	eret
 
+el1_hvc_guest:
+	/*
+	 * Fastest possible path for ARM_SMCCC_ARCH_WORKAROUND_1.
+	 * The workaround has already been applied on the host,
+	 * so let's quickly get back to the guest. We don't bother
+	 * restoring x1, as it can be clobbered anyway.
+	 */
+	ldr     x1, [sp]                                // Guest's x0
+	eor     w1, w1, #ARM_SMCCC_ARCH_WORKAROUND_1
+	cbnz    w1, el1_trap
+	mov     x0, x1
+	add     sp, sp, #16
+	eret
+
 el1_trap:
 	/*
 	 * x1: ESR
-- 
2.21.0.rc0.269.g1a574e7a288b

