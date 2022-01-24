Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8BE49A9C5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323483AbiAYD2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445655AbiAXVEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74527C068090;
        Mon, 24 Jan 2022 12:04:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B780B811FB;
        Mon, 24 Jan 2022 20:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF09C340E5;
        Mon, 24 Jan 2022 20:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054659;
        bh=Aqzs6TyYmoFSONdI2u4ZRgTSfsF8vwjIks/uERB6+TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRcTrICOhJgCTmJYpAqnqpf+syd7eNa0hkkOea2q6EBaJ0vsLPFiIBbKCEvB1waW5
         dhA9QCWfCVN6WslJSEir5dWk5npJZaSVF7BAXGCTfgIY+JtXlWgj7uxy7NZu2ODbgw
         PluLpX9qB42dKm2Ted/6JSfu6ekjX4dERD15kP9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/563] powerpc: handle kdump appropriately with crash_kexec_post_notifiers option
Date:   Mon, 24 Jan 2022 19:43:14 +0100
Message-Id: <20220124184039.294568624@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



