Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560F77D752
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfHAIVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34431 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731106AbfHAIVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:12 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so27510213pgc.1
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jbpvQKJEQu6FughKaepmre4Ek2Fg9qHsXyEHlW2kC7A=;
        b=nuPAxY96iM+XwKlBy8anITOo/610vyvWeiY88oH4WhEaRNHJ+4FpcKfNUOq6sORC1n
         bognKJBIWgQngLwGMhYvzwuGBzT4WIu2MfMf8wZwWkZari+WuthCl6e/xY85XPk1O9WS
         W4HJ2d3jp408eScQ9rXt/Og1AIxEp3+gEHIQ+m0RWksDj+hoyuWm7cqTTOVQdSMaDRnh
         QQbblfammaCkWIWdwB9jSxF/XD7zfcPy8fmeA0b3nXznGmJW8355BJcQ4Yb3fU+RSBtP
         xyQgP/CWI3bq3rP9YfrrackmXpNijHi+BWViX2RDCKnE+QVy/UZBD8wV3GkSzbEsMW+v
         EPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jbpvQKJEQu6FughKaepmre4Ek2Fg9qHsXyEHlW2kC7A=;
        b=hayDZnpHeeLxNZBQE4sTtVBfV4m7/glLrqxDlKzHTHSMvNiw21mlGNUtcJ9xfl2XSp
         sV1TDmMujtfO8TKeD88ehfbhk5Rr/8+opzsMQupZaSZeYsjeA9S5OvMjqZAx7zFDazMr
         InjFk2ED47PuytU5aSO4RWFI9fdEgZTGRUMJwjQD96lmhkhUN4XM+iN4kGkb1Tm5b8ni
         lK7p269Ly+dR3hWz5e5OQJiKC1kYiNRNDEQM+uHDejlW3VjSTAFQTLMPcOU+ZBikZU34
         81PrA5vKgmC9qRGNfoI63AA6Zch9svofltDf6RSppT2GoaMZXnk9642vI8FRRJ3JU2X0
         L60w==
X-Gm-Message-State: APjAAAVyKpe9g9+yM6RCHKLnvO29RqnnnOxp2EUM/1sy7/6i7Q7GlamC
        OJOc0KYZWKPG928i6aEadI8GPrNxhQA=
X-Google-Smtp-Source: APXvYqzzclOnJ7hW5Cy9TmZm9TaesjMC0utzsTgWcOSVCJD9TpzTUtFt96KW/izuU1HOlYfsmURQtw==
X-Received: by 2002:a65:53cb:: with SMTP id z11mr1365272pgr.200.1564647670832;
        Thu, 01 Aug 2019 01:21:10 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id w4sm90742508pfn.144.2019.08.01.01.21.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:10 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 37/47] ARM: 8809/1: proc-v7: fix Thumb annotation of cpu_v7_hvc_switch_mm
Date:   Thu,  1 Aug 2019 13:46:21 +0530
Message-Id: <41ffeadd36b1640c285d4d7b633696cd5ae4f03c.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Commit 6282e916f774e37845c65d1eae9f8c649004f033 upstream.

Due to what appears to be a copy/paste error, the opening ENTRY()
of cpu_v7_hvc_switch_mm() lacks a matching ENDPROC(), and instead,
the one for cpu_v7_smc_switch_mm() is duplicated.

Given that it is ENDPROC() that emits the Thumb annotation, the
cpu_v7_hvc_switch_mm() routine will be called in ARM mode on a
Thumb2 kernel, resulting in the following splat:

  Internal error: Oops - undefined instruction: 0 [#1] SMP THUMB2
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.18.0-rc1-00030-g4d28ad89189d-dirty #488
  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  PC is at cpu_v7_hvc_switch_mm+0x12/0x18
  LR is at flush_old_exec+0x31b/0x570
  pc : [<c0316efe>]    lr : [<c04117c7>]    psr: 00000013
  sp : ee899e50  ip : 00000000  fp : 00000001
  r10: eda28f34  r9 : eda31800  r8 : c12470e0
  r7 : eda1fc00  r6 : eda53000  r5 : 00000000  r4 : ee88c000
  r3 : c0316eec  r2 : 00000001  r1 : eda53000  r0 : 6da6c000
  Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none

Note the 'ISA ARM' in the last line.

Fix this by using the correct name in ENDPROC().

Cc: <stable@vger.kernel.org>
Fixes: 10115105cb3a ("ARM: spectre-v2: add firmware based hardening")
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/proc-v7.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index b6359ce39fa7..90cddff176f6 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -106,7 +106,7 @@ ENTRY(cpu_v7_hvc_switch_mm)
 	hvc	#0
 	ldmfd	sp!, {r0 - r3}
 	b	cpu_v7_switch_mm
-ENDPROC(cpu_v7_smc_switch_mm)
+ENDPROC(cpu_v7_hvc_switch_mm)
 #endif
 ENTRY(cpu_v7_iciallu_switch_mm)
 	mov	r3, #0
-- 
2.21.0.rc0.269.g1a574e7a288b

