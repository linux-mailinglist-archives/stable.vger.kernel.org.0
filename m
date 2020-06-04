Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034FD1EEBC2
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 22:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgFDUSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 16:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgFDUSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 16:18:54 -0400
Received: from localhost.localdomain (unknown [194.230.155.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF5D6206E6;
        Thu,  4 Jun 2020 20:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591301934;
        bh=8AMUfx+U41h/W4ISZLyWgwankxiN0RxfqRn8dcLTozk=;
        h=From:To:Cc:Subject:Date:From;
        b=cG4hGRm4OKubJ9zcO4yHg94fi43rWCmcMt8d3MJmSafIsSh2OGN1qFw9nk/MLdprw
         H6eZ30H84bXPOOlHoH1sDG1irCKDzTN0sOTcomSsPzs8jhao4DDoUxzs+Oh7L/XD8P
         U7sNhA/X4xC11tIvj05ZxlWkA9jfz2Zax3QCFD6Y=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Tom Vaden <tom.vaden@hpe.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org
Subject: [RFT PATCH] ia64: Fix build error with !COREDUMP
Date:   Thu,  4 Jun 2020 22:18:42 +0200
Message-Id: <20200604201842.29482-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix linkage error when CONFIG_BINFMT_ELF is selected but CONFIG_COREDUMP
is not:

    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_phdrs':
    elfcore.c:(.text+0x172): undefined reference to `dump_emit'
    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_data':
    elfcore.c:(.text+0x2b2): undefined reference to `dump_emit'

Cc: <stable@vger.kernel.org>
Fixes: 1fcccbac89f5 ("elf coredump: replace ELF_CORE_EXTRA_* macros by functions")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Please let kbuild test it for a while before applying. I built it only
on few configurations.

This is similar fix to commit 42d91f612c87 ("um: Fix build error and
kconfig for i386") although I put different fixes tag - the commit which
introduced this part of code.
---
 arch/ia64/kernel/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index 1a8df6669eee..18d6008b151f 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -41,7 +41,7 @@ obj-y				+= esi_stub.o	# must be in kernel proper
 endif
 obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 
-obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+obj-$(CONFIG_ELF_CORE)		+= elfcore.o
 
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31
-- 
2.17.1

