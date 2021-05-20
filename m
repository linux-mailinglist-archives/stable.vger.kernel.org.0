Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3D38A476
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhETKFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235210AbhETKDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CEDC6142C;
        Thu, 20 May 2021 09:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503603;
        bh=L23xSBOAnyAlQcFOEdPmVvG72roz3qiD9SDhEE6UNYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBYeWjIR1Q6iZhukQeaIXSYcAexZzqGZRV5M+dHRsPp0yGxs7jVgBOYZ0lgS6sR7y
         bYv11wDKuYC6Qblz3PCdm+D4rDWHY4fQed4E5+hHlPcvS5Nwd5IxdROFhUaljBZOHB
         xgAtGuz9hGKWleoXBUuzkeXTOCg7P/XC4sygal8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Chen Huang <chenhuang5@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 252/425] powerpc: Fix HAVE_HARDLOCKUP_DETECTOR_ARCH build configuration
Date:   Thu, 20 May 2021 11:20:21 +0200
Message-Id: <20210520092139.694449821@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Huang <chenhuang5@huawei.com>

[ Upstream commit 4fe529449d85e78972fa327999961ecc83a0b6db ]

When compiling the powerpc with the SMP disabled, it shows the issue:

arch/powerpc/kernel/watchdog.c: In function ‘watchdog_smp_panic’:
arch/powerpc/kernel/watchdog.c:177:4: error: implicit declaration of function ‘smp_send_nmi_ipi’; did you mean ‘smp_send_stop’? [-Werror=implicit-function-declaration]
  177 |    smp_send_nmi_ipi(c, wd_lockup_ipi, 1000000);
      |    ^~~~~~~~~~~~~~~~
      |    smp_send_stop
cc1: all warnings being treated as errors
make[2]: *** [scripts/Makefile.build:273: arch/powerpc/kernel/watchdog.o] Error 1
make[1]: *** [scripts/Makefile.build:534: arch/powerpc/kernel] Error 2
make: *** [Makefile:1980: arch/powerpc] Error 2
make: *** Waiting for unfinished jobs....

We found that powerpc used ipi to implement hardlockup watchdog, so the
HAVE_HARDLOCKUP_DETECTOR_ARCH should depend on the SMP.

Fixes: 2104180a5369 ("powerpc/64s: implement arch-specific hardlockup watchdog")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210327094900.938555-1-chenhuang5@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6dd2a14e1ebc..f0e09d5f0bed 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -208,7 +208,7 @@ config PPC
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI				if PERF_EVENTS || (PPC64 && PPC_BOOK3S)
-	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if (PPC64 && PPC_BOOK3S)
+	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if PPC64 && PPC_BOOK3S && SMP
 	select HAVE_OPROFILE
 	select HAVE_OPTPROBES			if PPC64
 	select HAVE_PERF_EVENTS
-- 
2.30.2



