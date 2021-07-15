Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B123CA9E8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbhGOTLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242533AbhGOTH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 977DB6140A;
        Thu, 15 Jul 2021 19:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375839;
        bh=+ZbkuVJEHJBuzO5PpuUSnc0YNDHUydqlwvn1ED6Y+ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKn0niwvMgaDx8uOlK+r+33fnBz+FFARwT9qLwSftvxU5QxFXUbtTODR6Fi8otDfb
         VGCeB2mhm4aJ8Zdo/Nq5iGuDNVKjOt+oLfqMJXu8E08AowMUOz7J6R2e9S7tSXGW4f
         Vz4pw9gSBepELtT/PX8fV4GgMFBfQHn+91CtaSos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Youling Tang <tangyouling@loongson.cn>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 016/266] MIPS: Loongson64: Fix build error secondary_kexec_args undeclared under !SMP
Date:   Thu, 15 Jul 2021 20:36:11 +0200
Message-Id: <20210715182616.704279907@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



