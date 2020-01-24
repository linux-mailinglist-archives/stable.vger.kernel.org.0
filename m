Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E143414823C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389114AbgAXL0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389067AbgAXL0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:21 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA603214DB;
        Fri, 24 Jan 2020 11:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865180;
        bh=T0mzEV+4ZsVAtAF6AQldWRssemw0q4CFwKiOKgIDE0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NC5xsKLW0JKPMhL431uGgUYjEDPRqXzcj6qDIJYARTveFaoE0iZE3zCkvFtMBhLYB
         NwMKZKdSXXpgtSFcmqn2g0c4jZ4HvdKEIPg7mW46Ffwm5Pac99Zvmnl4LquSMbPKV3
         QyoHbhsv1DwtA9WCt36/J/dr6qZTDoKisVhL6wbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 475/639] x86/pgtable/32: Fix LOWMEM_PAGES constant
Date:   Fri, 24 Jan 2020 10:30:45 +0100
Message-Id: <20200124093147.503511029@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b3ec519e39827..71e1df8601765 100644
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



