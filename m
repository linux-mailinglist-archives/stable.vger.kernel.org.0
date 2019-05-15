Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5D51F389
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfEOLEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728349AbfEOLEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D545216FD;
        Wed, 15 May 2019 11:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918247;
        bh=Pqo3riyvY69moMPRn40Unc7xUUE3cx6zoZGhLr3eOlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAA/ZybhKSntK777BSg51QE8YUJawhm4YMgnlwi1yhqRiIM3rp8mUG2HWaddkGDaW
         boMHUYR8VICONcTx9hz4+VgNghg6DlgJVmRtW4hdhXVIFesY+iSNZhXnKHs27uLgfQ
         f6sYDqiLmF9bs8+NiKioiDbODlPSP3zg4iI+DKuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 060/266] powerpc/fsl: Add nospectre_v2 command line argument
Date:   Wed, 15 May 2019 12:52:47 +0200
Message-Id: <20190515090724.469052311@linuxfoundation.org>
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

From: Diana Craciun <diana.craciun@nxp.com>

commit f633a8ad636efb5d4bba1a047d4a0f1ef719aa06 upstream.

When the command line argument is present, the Spectre variant 2
mitigations are disabled.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/setup.h |    5 +++++
 arch/powerpc/kernel/security.c   |   21 +++++++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -53,6 +53,11 @@ void do_barrier_nospec_fixups_range(bool
 static inline void do_barrier_nospec_fixups_range(bool enable, void *start, void *end) { };
 #endif
 
+#ifdef CONFIG_PPC_FSL_BOOK3E
+void setup_spectre_v2(void);
+#else
+static inline void setup_spectre_v2(void) {};
+#endif
 void do_btb_flush_fixups(void);
 
 #endif /* !__ASSEMBLY__ */
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -27,6 +27,10 @@ static enum count_cache_flush_type count
 
 bool barrier_nospec_enabled;
 static bool no_nospec;
+static bool btb_flush_enabled;
+#ifdef CONFIG_PPC_FSL_BOOK3E
+static bool no_spectrev2;
+#endif
 
 static void enable_barrier_nospec(bool enable)
 {
@@ -102,6 +106,23 @@ static __init int barrier_nospec_debugfs
 device_initcall(barrier_nospec_debugfs_init);
 #endif /* CONFIG_DEBUG_FS */
 
+#ifdef CONFIG_PPC_FSL_BOOK3E
+static int __init handle_nospectre_v2(char *p)
+{
+	no_spectrev2 = true;
+
+	return 0;
+}
+early_param("nospectre_v2", handle_nospectre_v2);
+void setup_spectre_v2(void)
+{
+	if (no_spectrev2)
+		do_btb_flush_fixups();
+	else
+		btb_flush_enabled = true;
+}
+#endif /* CONFIG_PPC_FSL_BOOK3E */
+
 #ifdef CONFIG_PPC_BOOK3S_64
 ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, char *buf)
 {


