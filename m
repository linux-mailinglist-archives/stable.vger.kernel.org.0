Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C0713F43A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390169AbgAPSsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389752AbgAPRJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 231B8206D9;
        Thu, 16 Jan 2020 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194588;
        bh=ds3K/+Shpqm/cw3bLKGdAoAuyM1oYw+f5Ag3IkVPWAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quaA4PiILbj4XbPKVWBigMMPc08Pe4KpkTeztuF/UZu3Az989FRY4eWyJsvdY0uNY
         P2wL9OIZ/X9ZqPyoG4jRZ767Cy9SwVJ7xjlZk+uDkyF436qk0d92QD6yh2luylNMEZ
         VY9MtUFpTMyNBFv8CjYWixWRdYGi/759EmUqGwBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 460/671] x86/pgtable/32: Fix LOWMEM_PAGES constant
Date:   Thu, 16 Jan 2020 12:01:38 -0500
Message-Id: <20200116170509.12787-197-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 26515699863d68058e290e18e83f444925920be5 ]

clang points out that the computation of LOWMEM_PAGES causes a signed
integer overflow on 32-bit x86:

arch/x86/kernel/head32.c:83:20: error: signed shift result (0x100000000) requires 34 bits to represent, but 'int' only has 32 bits [-Werror,-Wshift-overflow]
                (PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT);
                                 ^~~~~~~~~~~~
arch/x86/include/asm/pgtable_32.h:109:27: note: expanded from macro 'LOWMEM_PAGES'
 #define LOWMEM_PAGES ((((2<<31) - __PAGE_OFFSET) >> PAGE_SHIFT))
                         ~^ ~~
arch/x86/include/asm/pgtable_32.h:98:34: note: expanded from macro 'PAGE_TABLE_SIZE'
 #define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PGD)

Use the _ULL() macro to make it a 64-bit constant.

Fixes: 1e620f9b23e5 ("x86/boot/32: Convert the 32-bit pgtable setup code from assembly to C")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190710130522.1802800-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pgtable_32.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index b3ec519e3982..71e1df860176 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -106,6 +106,6 @@ do {						\
  * with only a host target support using a 32-bit type for internal
  * representation.
  */
-#define LOWMEM_PAGES ((((2<<31) - __PAGE_OFFSET) >> PAGE_SHIFT))
+#define LOWMEM_PAGES ((((_ULL(2)<<31) - __PAGE_OFFSET) >> PAGE_SHIFT))
 
 #endif /* _ASM_X86_PGTABLE_32_H */
-- 
2.20.1

