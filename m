Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3397D3C4D74
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241800AbhGLHNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245121AbhGLHL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12DC760FE7;
        Mon, 12 Jul 2021 07:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073718;
        bh=RmdQxgmQUKngZiEEpvwrd/RjukaXrvrfyJGxWjEcI7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQUR3O1A4e+lskpWLhiKbfTRzNqaPrHaRaKojYsBFX8PyYKQKwRbuaA5feIf0ZfG0
         7QuD1UhWyeFOzTjICwUqaVXO88jSfC1cswY6t5cuDFZU+JcZ1exyUJ4wtYwmeIY4NP
         PoFvgN+aD8kizLbDNqN6rjci1kktEkAiUncVFgK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 335/700] EDAC/igen6: fix core dependency
Date:   Mon, 12 Jul 2021 08:06:58 +0200
Message-Id: <20210712061012.000513561@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0a9ece9ba154dd6205709108180952c55e630833 ]

igen6_edac needs mce_register()/unregister() functions,
so it should depend on X86_MCE (or X86_MCE_INTEL).

That change prevents these build errors:

ld: drivers/edac/igen6_edac.o: in function `igen6_remove':
igen6_edac.c:(.text+0x494): undefined reference to `mce_unregister_decode_chain'
ld: drivers/edac/igen6_edac.o: in function `igen6_probe':
igen6_edac.c:(.text+0xf5b): undefined reference to `mce_register_decode_chain'

Fixes: 10590a9d4f23e ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20210619160203.2026-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 27d0c4cdc58d..9b21e45debc2 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -270,7 +270,8 @@ config EDAC_PND2
 
 config EDAC_IGEN6
 	tristate "Intel client SoC Integrated MC"
-	depends on PCI && X86_64 && PCI_MMCONFIG && ARCH_HAVE_NMI_SAFE_CMPXCHG
+	depends on PCI && PCI_MMCONFIG && ARCH_HAVE_NMI_SAFE_CMPXCHG
+	depends on X64_64 && X86_MCE_INTEL
 	help
 	  Support for error detection and correction on the Intel
 	  client SoC Integrated Memory Controller using In-Band ECC IP.
-- 
2.30.2



