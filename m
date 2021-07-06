Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40A33BCBC4
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhGFLR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhGFLRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72C16610F7;
        Tue,  6 Jul 2021 11:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570078;
        bh=+ZbkuVJEHJBuzO5PpuUSnc0YNDHUydqlwvn1ED6Y+ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is6ZQGsmFdD6qTbiXPmHJ7xUwc3fMvBsObMhxaKWQxlwhmCcZhRscrqmb4P6cQ2hI
         oq8DybBDesJU8rmcT7Ut0hZYJeR5aJ1h1u0bv7FUaqPbpmuX6W8sI9GUt/t+nVE969
         qem3Y/dt9qr6P18RNM3H6ZnG4TW8U5l4GPXEY1MEHuUrTfUoj2lQvUVm1jH9dhd98j
         jvve40G1jlMgayq5lw+DC0b0HIn07R8yit3hpKE9D+q4ZsRfZIUxIclyKCp6E9dsq7
         +hdeRClwidk/4xrZwWoVgfO02bYXpPKvk4T53ThvZo+h9fXfr+DX/BQ5bS9BW9YXNC
         aMgBvQOpTt8xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youling Tang <tangyouling@loongson.cn>,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 019/189] MIPS: Loongson64: Fix build error 'secondary_kexec_args' undeclared under !SMP
Date:   Tue,  6 Jul 2021 07:11:19 -0400
Message-Id: <20210706111409.2058071-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Youling Tang <tangyouling@loongson.cn>

[ Upstream commit 6a73022ee3fdf7e60f2ba0a3a835dd421c05b5b5 ]

On the Loongson64 platform, if CONFIG_SMP is not set, the following build
error will occur:
arch/mips/loongson64/reset.c:133:2: error:'secondary_kexec_args' undeclared

Because the definition and declaration of secondary_kexec_args are in the
CONFIG_SMP, the secondary_kexec_args variable should be used in CONFIG_SMP.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/reset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mips/loongson64/reset.c b/arch/mips/loongson64/reset.c
index c97bfdc8c922..758d5d26aaaa 100644
--- a/arch/mips/loongson64/reset.c
+++ b/arch/mips/loongson64/reset.c
@@ -126,11 +126,12 @@ static void loongson_kexec_shutdown(void)
 	for_each_possible_cpu(cpu)
 		if (!cpu_online(cpu))
 			cpu_device_up(get_cpu_device(cpu));
+
+	secondary_kexec_args[0] = TO_UNCAC(0x3ff01000);
 #endif
 	kexec_args[0] = kexec_argc;
 	kexec_args[1] = fw_arg1;
 	kexec_args[2] = fw_arg2;
-	secondary_kexec_args[0] = TO_UNCAC(0x3ff01000);
 	memcpy((void *)fw_arg1, kexec_argv, KEXEC_ARGV_SIZE);
 	memcpy((void *)fw_arg2, kexec_envp, KEXEC_ENVP_SIZE);
 }
@@ -141,7 +142,9 @@ static void loongson_crash_shutdown(struct pt_regs *regs)
 	kexec_args[0] = kdump_argc;
 	kexec_args[1] = fw_arg1;
 	kexec_args[2] = fw_arg2;
+#ifdef CONFIG_SMP
 	secondary_kexec_args[0] = TO_UNCAC(0x3ff01000);
+#endif
 	memcpy((void *)fw_arg1, kdump_argv, KEXEC_ARGV_SIZE);
 	memcpy((void *)fw_arg2, kexec_envp, KEXEC_ENVP_SIZE);
 }
-- 
2.30.2

