Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98992A5685
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbgKCU7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733113AbgKCU7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9485D223BF;
        Tue,  3 Nov 2020 20:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437170;
        bh=ebhFxyfQPpIfUkMOndtreeKy5cOZRimmFH/uWLJz1V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWCKR4onBwOhi/1H1Napy2IPSCFT7w7fJDtTUXMG6ZMvWkvjGv4hgEor/0N/wgDPc
         vxFU3ewaFk5xvyUAhAGZfO3U5GwEFNERutz6fsifVGJuQOjVEXhxqanUoktcuZ4JHn
         dWVu428L44fqLjRBQ60xJCRHuRq49PMCfJKBCrSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 176/214] ia64: fix build error with !COREDUMP
Date:   Tue,  3 Nov 2020 21:37:04 +0100
Message-Id: <20201103203307.223513174@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 7404840d87557c4092bf0272bce5e0354c774bf9 upstream.

Fix linkage error when CONFIG_BINFMT_ELF is selected but CONFIG_COREDUMP
is not:

    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_phdrs':
    elfcore.c:(.text+0x172): undefined reference to `dump_emit'
    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_data':
    elfcore.c:(.text+0x2b2): undefined reference to `dump_emit'

Fixes: 1fcccbac89f5 ("elf coredump: replace ELF_CORE_EXTRA_* macros by functions")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200819064146.12529-1-krzk@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/ia64/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -41,7 +41,7 @@ obj-y				+= esi_stub.o	# must be in kern
 endif
 obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 
-obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+obj-$(CONFIG_ELF_CORE)		+= elfcore.o
 
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31


