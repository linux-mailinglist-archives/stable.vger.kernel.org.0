Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A496322BA
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiKUMpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiKUMpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:45:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DB5BF826
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6DB4B80D7F
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CC4C433D6;
        Mon, 21 Nov 2022 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034705;
        bh=yF5lmYgGusI2G2b5d4CHRwVb6ZBxqdrfWSmY5rkfPYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDmHqP9wOMz7v/J+GRO81PyVjRFxSnK6OGdUPGolhqohYFVzFDhBBBBhC7k7pmQyu
         lfSlYr0jn2B5DLmQGgWZNozM5YLQ0SvGQGKVZmtHn87sdJNLtZMIBbN8ApGFGLChfi
         nEjs8kyKJU1kgtIh9Q6uiMldbGfeMAIDOgpfd8jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 05/34] x86/devicetable: Move x86 specific macro out of generic code
Date:   Mon, 21 Nov 2022 13:43:27 +0100
Message-Id: <20221121124151.058630231@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[suleiman: vmx.c moved]
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu_device_id.h   |   13 ++++++++++++-
 arch/x86/kvm/svm.c                     |    1 +
 arch/x86/kvm/vmx.c                     |    1 +
 drivers/cpufreq/acpi-cpufreq.c         |    1 +
 drivers/cpufreq/amd_freq_sensitivity.c |    1 +
 include/linux/mod_devicetable.h        |    4 +---
 6 files changed, 17 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -6,10 +6,21 @@
  * Declare drivers belonging to specific x86 CPUs
  * Similar in spirit to pci_device_id and related PCI functions
  */
-
 #include <linux/mod_devicetable.h>
 
 /*
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
+/*
  * Match specific microcode revisions.
  *
  * vendor/family/model/stepping must be all set.
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -50,6 +50,7 @@
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
+#include <asm/cpu_device_id.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -41,6 +41,7 @@
 
 #include <asm/asm.h>
 #include <asm/cpu.h>
+#include <asm/cpu_device_id.h>
 #include <asm/io.h>
 #include <asm/desc.h>
 #include <asm/vmx.h>
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -47,6 +47,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
--- a/drivers/cpufreq/amd_freq_sensitivity.c
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -21,6 +21,7 @@
 
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 #include "cpufreq_ondemand.h"
 
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -631,9 +631,7 @@ struct x86_cpu_id {
 	kernel_ulong_t driver_data;
 };
 
-#define X86_FEATURE_MATCH(x) \
-	{ X86_VENDOR_ANY, X86_FAMILY_ANY, X86_MODEL_ANY, x }
-
+/* Wild cards for x86_cpu_id::vendor, family, model and feature */
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0


