Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C9A490DE7
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbiAQRGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54222 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241694AbiAQRET (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:04:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25BA16120D;
        Mon, 17 Jan 2022 17:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F539C36AE7;
        Mon, 17 Jan 2022 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439058;
        bh=Aqzs6TyYmoFSONdI2u4ZRgTSfsF8vwjIks/uERB6+TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyL7J/Ln/IGJp4Rj8auGq0JHa2sg8zNa146YSILOvFm35w0KK2B9mUTE5Dvu20L7o
         1HbMA5g1/WjqBhTB7cFgT4GtAVmua15L2hEYLcm+h0ugBQG5uy0G4inS6S927gpPkY
         5sKb2ovIw2APmNMJN02nwS4g6WDt9dMV+Xk6mdTnUs/qHZZKpLpRmdmqn4b+7dVwN4
         +bC4DHfRMEokuOE7NOidrc6Xl0R5K2svkiJqT3Ine3DbHev4/yToYd6z+xUPov0pmL
         2Uc/KljDrFeyFxcuNZ+swKRzxOg1vIjwNb5Z4ydTHs3z9wXMIJXU4QblmzdvMqVs1S
         sP989hgwsjRTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hari Bathini <hbathini@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, clg@kaod.org, parth@linux.ibm.com,
        npiggin@gmail.com, robh@kernel.org, yukuai3@huawei.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 23/34] powerpc: handle kdump appropriately with crash_kexec_post_notifiers option
Date:   Mon, 17 Jan 2022 12:03:13 -0500
Message-Id: <20220117170326.1471712-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 219572d2fc4135b5ce65c735d881787d48b10e71 ]

Kdump can be triggered after panic_notifers since commit f06e5153f4ae2
("kernel/panic.c: add "crash_kexec_post_notifiers" option for kdump
after panic_notifers") introduced crash_kexec_post_notifiers option.
But using this option would mean smp_send_stop(), that marks all other
CPUs as offline, gets called before kdump is triggered. As a result,
kdump routines fail to save other CPUs' registers. To fix this, kdump
friendly crash_smp_send_stop() function was introduced with kernel
commit 0ee59413c967 ("x86/panic: replace smp_send_stop() with kdump
friendly version in panic path"). Override this kdump friendly weak
function to handle crash_kexec_post_notifiers option appropriately
on powerpc.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
[Fixed signature of crash_stop_this_cpu() - reported by lkp@intel.com]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211207103719.91117-1-hbathini@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 50aeef08aa470..d993f28107afa 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -594,6 +594,36 @@ void crash_send_ipi(void (*crash_ipi_callback)(struct pt_regs *))
 }
 #endif
 
+#ifdef CONFIG_NMI_IPI
+static void crash_stop_this_cpu(struct pt_regs *regs)
+#else
+static void crash_stop_this_cpu(void *dummy)
+#endif
+{
+	/*
+	 * Just busy wait here and avoid marking CPU as offline to ensure
+	 * register data is captured appropriately.
+	 */
+	while (1)
+		cpu_relax();
+}
+
+void crash_smp_send_stop(void)
+{
+	static bool stopped = false;
+
+	if (stopped)
+		return;
+
+	stopped = true;
+
+#ifdef CONFIG_NMI_IPI
+	smp_send_nmi_ipi(NMI_IPI_ALL_OTHERS, crash_stop_this_cpu, 1000000);
+#else
+	smp_call_function(crash_stop_this_cpu, NULL, 0);
+#endif /* CONFIG_NMI_IPI */
+}
+
 #ifdef CONFIG_NMI_IPI
 static void nmi_stop_this_cpu(struct pt_regs *regs)
 {
-- 
2.34.1

