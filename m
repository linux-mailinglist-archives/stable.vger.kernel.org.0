Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236D649A2C8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365977AbiAXXwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843477AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D168C06C5AF;
        Mon, 24 Jan 2022 13:15:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0738FB811FB;
        Mon, 24 Jan 2022 21:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D194C340E5;
        Mon, 24 Jan 2022 21:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058923;
        bh=/EESlIcy4u19W/9Xq1u2Tkvy0QQYoel1/VtuLRwMchQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FKCDMZe0MSK4bRfM3CWQMihOcsUwahnydDrxAPqyGmG+tEgVdcpafip4SNtTfprf
         d5iFf0W5gahP1d9g2GNAHEz79befP4IbAmQb03LfVjIUhjwqWIjc74Xe3rUqhhzqTq
         oLmULhXZ8FiQpF3TcUPKogI0jujgChpkhssxWDe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Huang Rui <ray.huang@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0404/1039] x86, sched: Fix undefined reference to init_freq_invariance_cppc() build error
Date:   Mon, 24 Jan 2022 19:36:33 +0100
Message-Id: <20220124184138.888274826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index cc164777e6619..2f0b6be8eaabc 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -221,7 +221,7 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled)
 }
 #endif
 
-#ifdef CONFIG_ACPI_CPPC_LIB
+#if defined(CONFIG_ACPI_CPPC_LIB) && defined(CONFIG_SMP)
 void init_freq_invariance_cppc(void);
 #define init_freq_invariance_cppc init_freq_invariance_cppc
 #endif
-- 
2.34.1



