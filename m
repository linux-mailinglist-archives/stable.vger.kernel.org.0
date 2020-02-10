Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B559157AA4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgBJNYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728633AbgBJMhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A8E2051A;
        Mon, 10 Feb 2020 12:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338226;
        bh=J5DLvdB6gBroYHWGrAiyydWfzx0oanCDBY7mMDZ58fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2U4s15aIPTqx5Z2ed4ROB2lqsc98JxmA+PVISVDhjf3WlTtO9/RvQkc/sQkBIE79
         O8S6RAjb0ZYrqrqSQ8+SoOVKiPla5DvB+Dan3o+AMVe+YPNBWeKPXQjxNfe+6muz9w
         mj7xOzvVWdrQpw5mL63QBmlzRl/IThKMncAnFn8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 065/309] arm64: acpi: fix DAIF manipulation with pNMI
Date:   Mon, 10 Feb 2020 04:30:21 -0800
Message-Id: <20200210122412.185333033@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit e533dbe9dcb199bb637a2c465f3a6e70564994fe upstream.

Since commit:

  d44f1b8dd7e66d80 ("arm64: KVM/mm: Move SEA handling behind a single 'claim' interface")

... the top-level APEI SEA handler has the shape:

1. current_flags = arch_local_save_flags()
2. local_daif_restore(DAIF_ERRCTX)
3. <GHES handler>
4. local_daif_restore(current_flags)

However, since commit:

  4a503217ce37e1f4 ("arm64: irqflags: Use ICC_PMR_EL1 for interrupt masking")

... when pseudo-NMIs (pNMIs) are in use, arch_local_save_flags() will save
the PMR value rather than the DAIF flags.

The combination of these two commits means that the APEI SEA handler will
erroneously attempt to restore the PMR value into DAIF. Fix this by
factoring local_daif_save_flags() out of local_daif_save(), so that we
can consistently save DAIF in step #1, regardless of whether pNMIs are in
use.

Both commits were introduced concurrently in v5.0.

Cc: <stable@vger.kernel.org>
Fixes: 4a503217ce37e1f4 ("arm64: irqflags: Use ICC_PMR_EL1 for interrupt masking")
Fixes: d44f1b8dd7e66d80 ("arm64: KVM/mm: Move SEA handling behind a single 'claim' interface")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/daifflags.h |   11 ++++++++++-
 arch/arm64/kernel/acpi.c           |    2 +-
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -36,7 +36,7 @@ static inline void local_daif_mask(void)
 	trace_hardirqs_off();
 }
 
-static inline unsigned long local_daif_save(void)
+static inline unsigned long local_daif_save_flags(void)
 {
 	unsigned long flags;
 
@@ -48,6 +48,15 @@ static inline unsigned long local_daif_s
 			flags |= PSR_I_BIT;
 	}
 
+	return flags;
+}
+
+static inline unsigned long local_daif_save(void)
+{
+	unsigned long flags;
+
+	flags = local_daif_save_flags();
+
 	local_daif_mask();
 
 	return flags;
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -274,7 +274,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	if (!IS_ENABLED(CONFIG_ACPI_APEI_GHES))
 		return err;
 
-	current_flags = arch_local_save_flags();
+	current_flags = local_daif_save_flags();
 
 	/*
 	 * SEA can interrupt SError, mask it and describe this as an NMI so


