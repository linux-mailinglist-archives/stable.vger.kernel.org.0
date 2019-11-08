Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46045F4BC3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKHMg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfKHMg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:27 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E09F4222C9;
        Fri,  8 Nov 2019 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216587;
        bh=MbXatxJpsvst8ICGkSFEmESQab2TZO2tWpDaaS3zX6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUkrh+UFeXkCwh6QVxtXf75N9DQGyTbDGiv5sQ4hI6iXgflFyXfIFik9Se192+M34
         LnCVy/tqb42xqSn2MIjfOgiDZadYmNuy35QR7ol51bDHZtK+AgwCB0BNWbfBN7x7M5
         wSxYeI6fF6gWQlnUET3MZLUmgv4e3VlUc7ZiYK1Y=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 09/50] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date:   Fri,  8 Nov 2019 13:35:13 +0100
Message-Id: <20191108123554.29004-10-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

From: Marc Zyngier <marc.zyngier@arm.com>

commit 6167ec5c9145cdf493722dfd80a5d48bafc4a18a upstream.

A new feature of SMCCC 1.1 is that it offers firmware-based CPU
workarounds. In particular, SMCCC_ARCH_WORKAROUND_1 provides
BP hardening for CVE-2017-5715.

If the host has some mitigation for this issue, report that
we deal with it using SMCCC_ARCH_WORKAROUND_1, as we apply the
host workaround on every guest exit.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[v4.9: account for files moved to virt/ upstream]
Signed-off-by: Mark Rutland <mark.rutland@arm.com> [v4.9 backport]
Tested-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ardb: restrict to include/linux/arm-smccc.h]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/arm-smccc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 8bf047eab116..f2416b58367d 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -70,6 +70,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 1)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
-- 
2.20.1

