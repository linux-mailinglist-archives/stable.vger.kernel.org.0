Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839D7499AD8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378823AbiAXVrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456711AbiAXVjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E964C0419CA;
        Mon, 24 Jan 2022 12:26:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D058C6150D;
        Mon, 24 Jan 2022 20:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B10C340E5;
        Mon, 24 Jan 2022 20:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055996;
        bh=Pl/gtIakko0+K4DcO8u+PBfMjvwYR2boCYlTmG7IVEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfDZFo6zE4VSqYpY2Dgwxz2fkweSZe5RcqtGMQjYXUV9NH3egTtL7MbhEfQ8ussRi
         vS8PGUbdVjV584yE/lBfryT1lAV7NSNuo+KwdezRyqWlIflKSfhscBgXSK1z3L00/x
         Czfxzr3LwyaTFcrtLcZC9+kQYpnqdFbl56X8y5rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Huang Rui <ray.huang@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/846] x86, sched: Fix undefined reference to init_freq_invariance_cppc() build error
Date:   Mon, 24 Jan 2022 19:37:33 +0100
Message-Id: <20220124184112.514811632@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

[ Upstream commit 6c4ab1b86dac3954d15c00c1a6396d60a1023fab ]

The init_freq_invariance_cppc function is implemented in smpboot and depends on
CONFIG_SMP.

  MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.kallsyms1
ld: drivers/acpi/cppc_acpi.o: in function `acpi_cppc_processor_probe':
/home/ray/brahma3/linux/drivers/acpi/cppc_acpi.c:819: undefined reference to `init_freq_invariance_cppc'
make: *** [Makefile:1161: vmlinux] Error 1

See https://lore.kernel.org/lkml/484af487-7511-647e-5c5b-33d4429acdec@infradead.org/.

Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Huang Rui <ray.huang@amd.com>
[ rjw: Subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 9239399e54914..55160445ea78b 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -218,7 +218,7 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled)
 }
 #endif
 
-#ifdef CONFIG_ACPI_CPPC_LIB
+#if defined(CONFIG_ACPI_CPPC_LIB) && defined(CONFIG_SMP)
 void init_freq_invariance_cppc(void);
 #define init_freq_invariance_cppc init_freq_invariance_cppc
 #endif
-- 
2.34.1



