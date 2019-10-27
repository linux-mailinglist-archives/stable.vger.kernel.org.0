Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C00E6620
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbfJ0VIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbfJ0VIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7730A20B7C;
        Sun, 27 Oct 2019 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210531;
        bh=0P04B2adEBHzzhOJCXQeGs0nSkHAwogVAekqy2RDdKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFyovkcd9jlh1mPjpZUS4MOLgiuGUoAwUxGOcEfUimIxTLbWxzQI8FNX/0qNXprxl
         L0CXmbCQinaQcO1fLOj/xqIU/M1RzLI81e2gRbKl0T+pZpCzjMbuV42sW1yZRrV67e
         361GUbW/9HhtOXb4+TgHs+o4uIde0oeL6cf03JHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 045/119] arm64: Introduce sysreg_clear_set()
Date:   Sun, 27 Oct 2019 22:00:22 +0100
Message-Id: <20191027203317.852806511@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 6ebdf4db8fa564a150f46d32178af0873eb5abbb ]

Currently we have a couple of helpers to manipulate bits in particular
sysregs:

 * config_sctlr_el1(u32 clear, u32 set)

 * change_cpacr(u64 val, u64 mask)

The parameters of these differ in naming convention, order, and size,
which is unfortunate. They also differ slightly in behaviour, as
change_cpacr() skips the sysreg write if the bits are unchanged, which
is a useful optimization when sysreg writes are expensive.

Before we gain yet another sysreg manipulation function, let's
unify these with a common helper, providing a consistent order for
clear/set operands, and the write skipping behaviour from
change_cpacr(). Code will be migrated to the new helper in subsequent
patches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -584,6 +584,17 @@ asm(
 	asm volatile("msr_s " __stringify(r) ", %x0" : : "rZ" (__val));	\
 } while (0)
 
+/*
+ * Modify bits in a sysreg. Bits in the clear mask are zeroed, then bits in the
+ * set mask are set. Other bits are left as-is.
+ */
+#define sysreg_clear_set(sysreg, clear, set) do {			\
+	u64 __scs_val = read_sysreg(sysreg);				\
+	u64 __scs_new = (__scs_val & ~(u64)(clear)) | (set);		\
+	if (__scs_new != __scs_val)					\
+		write_sysreg(__scs_new, sysreg);			\
+} while (0)
+
 static inline void config_sctlr_el1(u32 clear, u32 set)
 {
 	u32 val;


