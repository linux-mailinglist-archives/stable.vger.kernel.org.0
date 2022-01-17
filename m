Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105D6490EB9
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243663AbiAQRLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243376AbiAQRJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:09:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9335DC0619D0;
        Mon, 17 Jan 2022 09:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32DD161242;
        Mon, 17 Jan 2022 17:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FA3C36AE3;
        Mon, 17 Jan 2022 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439133;
        bh=+4Y45NR2lyzG41zk6KY232Sml1e0lHoiQZKzYnmhRPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLziprGxrKUiYk7EzhHcRRlIkZRUfXWlj8ksd2f/RLRhxOHITAmPD4ukTd2SDxYjT
         TmqEOzo08QkrWWo49akd81plKomM66R1BaiXF3LbspcJQ1mjjnvdmGr/oELpZGjESi
         9pW4uNltA6LdZ3/gRWms4FwPZtQPXo2d5m1lSK5e9LGvSV++BSS0T80r59rVep3kzS
         AGzv+agCXQCwlxCEDUDXYyRQfAv9D2ry1rYtNwP+7TSktqPbyNGFvr2jsMBtlFw/fm
         hQPieDyfSpgXGuEikfp+f8uKXX7uOjGo0GvtGcfCXMWnmgSfhAwjq9xH4eAwgY+EMl
         mI6HAdCovJwLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hari Bathini <hbathini@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, valentin.schneider@arm.com, clg@kaod.org,
        parth@linux.ibm.com, npiggin@gmail.com, robh@kernel.org,
        yukuai3@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 16/21] powerpc: handle kdump appropriately with crash_kexec_post_notifiers option
Date:   Mon, 17 Jan 2022 12:04:48 -0500
Message-Id: <20220117170454.1472347-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170454.1472347-1-sashal@kernel.org>
References: <20220117170454.1472347-1-sashal@kernel.org>
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
index 82dff003a7fd6..4de63ec2e1551 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -582,6 +582,36 @@ void crash_send_ipi(void (*crash_ipi_callback)(struct pt_regs *))
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

