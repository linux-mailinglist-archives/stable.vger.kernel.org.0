Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCBE1F38E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfEOLEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbfEOLEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CFA021734;
        Wed, 15 May 2019 11:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918255;
        bh=7LtjtEm+6npGd7blV5Zih9bJoLdFSeN4DjT2mASQb8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dg7bl4YOrsnrx+iA9hwF57K3yHXRfmJwHeoUqqfFY1dxtQhgkoU9VerG50FBsii/A
         iMF1TO7HMWMp5amovg+8wH4vEzE/PfNdB7YU8tUXKOYXz0X6p3qkECRUB6m0tvI3tB
         m8IOgcRxmXLl9+jebPKneoGYfvwz06JQ87Xoiock=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 027/266] powerpc/64s: Enhance the information in cpu_show_meltdown()
Date:   Wed, 15 May 2019 12:52:14 +0200
Message-Id: <20190515090723.486260500@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit ff348355e9c72493947be337bb4fae4fc1a41eba upstream.

Now that we have the security feature flags we can make the
information displayed in the "meltdown" file more informative.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/security_features.h |    1 
 arch/powerpc/kernel/security.c               |   30 +++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -10,6 +10,7 @@
 
 
 extern unsigned long powerpc_security_features;
+extern bool rfi_flush;
 
 static inline void security_ftr_set(unsigned long feature)
 {
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -6,6 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/seq_buf.h>
 
 #include <asm/security_features.h>
 
@@ -19,8 +20,33 @@ unsigned long powerpc_security_features
 
 ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	if (rfi_flush)
-		return sprintf(buf, "Mitigation: RFI Flush\n");
+	bool thread_priv;
+
+	thread_priv = security_ftr_enabled(SEC_FTR_L1D_THREAD_PRIV);
+
+	if (rfi_flush || thread_priv) {
+		struct seq_buf s;
+		seq_buf_init(&s, buf, PAGE_SIZE - 1);
+
+		seq_buf_printf(&s, "Mitigation: ");
+
+		if (rfi_flush)
+			seq_buf_printf(&s, "RFI Flush");
+
+		if (rfi_flush && thread_priv)
+			seq_buf_printf(&s, ", ");
+
+		if (thread_priv)
+			seq_buf_printf(&s, "L1D private per thread");
+
+		seq_buf_printf(&s, "\n");
+
+		return s.len;
+	}
+
+	if (!security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) &&
+	    !security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR))
+		return sprintf(buf, "Not affected\n");
 
 	return sprintf(buf, "Vulnerable\n");
 }


