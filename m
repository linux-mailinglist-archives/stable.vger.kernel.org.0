Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912BF5F30B9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJCNLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJCNLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:11:17 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB444DB39;
        Mon,  3 Oct 2022 06:11:09 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D5D1642FB5;
        Mon,  3 Oct 2022 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802668;
        bh=NcWtzCGR68+ig3ZpuHn0vrTyGTEsrNPt7T8apUj1qjg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Rp4eumjE9PhYi1rFQaphe/yGNyfgdXdgEK1m8Qw2rVxqg2cxXNq4OSzhW0fU/Ja5D
         We8yFq18HrSbi+QXZyrg8nfTUmNIqbgAJoNGExj/nzJOFFn8Co3PWhVuml3nmv51ae
         uCInNS65RoI0JUi6AyvYMLeFRFHa6doq/Po6ReWyJz4B/nlZyLeudwX96mh4Xsl/LG
         9vDFjXlLU6sa28DfFRngcIpaaqxcGjYAtPcb30gvhgdVs7TX9WE/ddxxWgY+NgyIAV
         XY3+xnD4VvvPQrTsF4WSakoMgPtkndwyqJQMFED90lqcOEq8TpbanPRF7fXJqfyoiQ
         lUTv6cZasSebA==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 03/37] x86/devicetable: Move x86 specific macro out of generic code
Date:   Mon,  3 Oct 2022 10:10:04 -0300
Message-Id: <20221003131038.12645-4-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit ba5bade4cc0d2013cdf5634dae554693c968a090 upstream.

There is no reason that this gunk is in a generic header file. The wildcard
defines need to stay as they are required by file2alias.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lkml.kernel.org/r/20200320131508.736205164@linutronix.de
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/include/asm/cpu_device_id.h   | 13 ++++++++++++-
 arch/x86/kvm/svm.c                     |  1 +
 arch/x86/kvm/vmx/vmx.c                 |  1 +
 drivers/cpufreq/acpi-cpufreq.c         |  1 +
 drivers/cpufreq/amd_freq_sensitivity.c |  1 +
 include/linux/mod_devicetable.h        |  4 +---
 6 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 31c379c1da41..a28dc6ba5be1 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -6,9 +6,20 @@
  * Declare drivers belonging to specific x86 CPUs
  * Similar in spirit to pci_device_id and related PCI functions
  */
-
 #include <linux/mod_devicetable.h>
 
+/*
+ * The wildcard initializers are in mod_devicetable.h because
+ * file2alias needs them. Sigh.
+ */
+
+#define X86_FEATURE_MATCH(x) {			\
+	.vendor		= X86_VENDOR_ANY,	\
+	.family		= X86_FAMILY_ANY,	\
+	.model		= X86_MODEL_ANY,	\
+	.feature	= x,			\
+}
+
 /*
  * Match specific microcode revisions.
  *
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1efcc7d4bc88..3db407e3c416 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,6 +47,7 @@
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
+#include <asm/cpu_device_id.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bd1bf6214ee..766612a339af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -31,6 +31,7 @@
 #include <asm/apic.h>
 #include <asm/asm.h>
 #include <asm/cpu.h>
+#include <asm/cpu_device_id.h>
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/internal.h>
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 4195834a4591..cf7ebe3bd1ad 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -30,6 +30,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
index e2df9d112106..5107cbe2d64d 100644
--- a/drivers/cpufreq/amd_freq_sensitivity.c
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -18,6 +18,7 @@
 
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 #include "cpufreq_ondemand.h"
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 04a19e30b168..d82048680e59 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -667,9 +667,7 @@ struct x86_cpu_id {
 	kernel_ulong_t driver_data;
 };
 
-#define X86_FEATURE_MATCH(x) \
-	{ X86_VENDOR_ANY, X86_FAMILY_ANY, X86_MODEL_ANY, x }
-
+/* Wild cards for x86_cpu_id::vendor, family, model and feature */
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
-- 
2.34.1

