Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C1643A03B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhJYT3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234434AbhJYT12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B64F461154;
        Mon, 25 Oct 2021 19:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189854;
        bh=uh+onX4lya15jpShJDlMJOjftqDM96kehkwXOaOh+Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdGFg9geMnoq5vzNWAUIABACeDOJm2BnCDtfF3A8fmQ7mfdXyHnGA12G1gx4CEPGC
         /nDHskoQs2yWhqDBRhtxPe1kJlmVSsXMPD8irbzHdZzF/aE5adcB0WnyLX2fSYJL5D
         KA1pk7TkmTjdcDrqdf4uQKFdWQubYIxTnq/rtuY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/37] NIOS2: irqflags: rename a redefined register name
Date:   Mon, 25 Oct 2021 21:14:34 +0200
Message-Id: <20211025190930.076950108@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 4cce60f15c04d69eff6ffc539ab09137dbe15070 ]

Both arch/nios2/ and drivers/mmc/host/tmio_mmc.c define a macro
with the name "CTL_STATUS". Change the one in arch/nios2/ to be
"CTL_FSTATUS" (flags status) to eliminate the build warning.

In file included from ../drivers/mmc/host/tmio_mmc.c:22:
drivers/mmc/host/tmio_mmc.h:31: warning: "CTL_STATUS" redefined
   31 | #define CTL_STATUS 0x1c
arch/nios2/include/asm/registers.h:14: note: this is the location of the previous definition
   14 | #define CTL_STATUS      0

Fixes: b31ebd8055ea ("nios2: Nios2 registers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/irqflags.h  | 4 ++--
 arch/nios2/include/asm/registers.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/nios2/include/asm/irqflags.h b/arch/nios2/include/asm/irqflags.h
index 75ab92e639f8..0338fcb88203 100644
--- a/arch/nios2/include/asm/irqflags.h
+++ b/arch/nios2/include/asm/irqflags.h
@@ -22,7 +22,7 @@
 
 static inline unsigned long arch_local_save_flags(void)
 {
-	return RDCTL(CTL_STATUS);
+	return RDCTL(CTL_FSTATUS);
 }
 
 /*
@@ -31,7 +31,7 @@ static inline unsigned long arch_local_save_flags(void)
  */
 static inline void arch_local_irq_restore(unsigned long flags)
 {
-	WRCTL(CTL_STATUS, flags);
+	WRCTL(CTL_FSTATUS, flags);
 }
 
 static inline void arch_local_irq_disable(void)
diff --git a/arch/nios2/include/asm/registers.h b/arch/nios2/include/asm/registers.h
index 615bce19b546..33824f2ad1ab 100644
--- a/arch/nios2/include/asm/registers.h
+++ b/arch/nios2/include/asm/registers.h
@@ -24,7 +24,7 @@
 #endif
 
 /* control register numbers */
-#define CTL_STATUS	0
+#define CTL_FSTATUS	0
 #define CTL_ESTATUS	1
 #define CTL_BSTATUS	2
 #define CTL_IENABLE	3
-- 
2.33.0



