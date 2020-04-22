Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8B21B3CB3
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgDVKHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728592AbgDVKHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:07:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6FDD2076C;
        Wed, 22 Apr 2020 10:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550072;
        bh=BufB70BOJtnKBVjbWxfZqfEecSsOmUlsH5OZo5Dkf5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06Jem3rcSV4ntvhNmeKJvzZc7K+gMxkTWKMug+WZAd/T3PqqYWgj9SkcGSehcFw4b
         Q3nhTUhR9UOnsmqdAEx2Sr6jbw6pI2OQDGguzvQnWpienaYPxFponQoT8+B+0W0jnG
         2jQa+3hYqgUtMuXBZhI39wtgwdOf3AXJq7MClejg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Evalds Iodzevics <evalds.iodzevics@gmail.com>
Subject: [PATCH 4.9 123/125] x86/CPU: Add native CPUID variants returning a single datum
Date:   Wed, 22 Apr 2020 11:57:20 +0200
Message-Id: <20200422095052.306897814@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 5dedade6dfa243c130b85d1e4daba6f027805033 upstream.

... similarly to the cpuid_<reg>() variants.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/20170109114147.5082-2-bp@alien8.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Evalds Iodzevics <evalds.iodzevics@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/processor.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -213,6 +213,24 @@ static inline void native_cpuid(unsigned
 	    : "memory");
 }
 
+#define native_cpuid_reg(reg)					\
+static inline unsigned int native_cpuid_##reg(unsigned int op)	\
+{								\
+	unsigned int eax = op, ebx, ecx = 0, edx;		\
+								\
+	native_cpuid(&eax, &ebx, &ecx, &edx);			\
+								\
+	return reg;						\
+}
+
+/*
+ * Native CPUID functions returning a single datum.
+ */
+native_cpuid_reg(eax)
+native_cpuid_reg(ebx)
+native_cpuid_reg(ecx)
+native_cpuid_reg(edx)
+
 static inline void load_cr3(pgd_t *pgdir)
 {
 	write_cr3(__pa(pgdir));


