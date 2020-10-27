Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E59629AE6F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411174AbgJ0OAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753229AbgJ0N70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:59:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85AB6218AC;
        Tue, 27 Oct 2020 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807166;
        bh=kS14tNJwqQLq1lh9ljGm95QpagsGhtEkRo6fYA0ugOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXmR2Ar2KGkualnTL7eUWMBUV9f7m6Nbs9Fus+dWkC4tWNRFNxZzzijHwcvXc6cmC
         4V9ae70mZXsreV9mzB8uCBYrdhp1jUj6S/vJnv4H1M0DyTgqjgXvdEEfMIpmQiIcxA
         ruol4ocEXkOoFQyz6Ii9Iniil+L9fYCwlapSndw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 059/112] powerpc/tau: Use appropriate temperature sample interval
Date:   Tue, 27 Oct 2020 14:49:29 +0100
Message-Id: <20201027134903.360605644@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 66943005cc41f48e4d05614e8f76c0ca1812f0fd ]

According to the MPC750 Users Manual, the SITV value in Thermal
Management Register 3 is 13 bits long. The present code calculates the
SITV value as 60 * 500 cycles. This would overflow to give 10 us on
a 500 MHz CPU rather than the intended 60 us. (But according to the
Microprocessor Datasheet, there is also a factor of 266 that has to be
applied to this value on certain parts i.e. speed sort above 266 MHz.)
Always use the maximum cycle count, as recommended by the Datasheet.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/896f542e5f0f1d6cf8218524c2b67d79f3d69b3c.1599260540.git.fthain@telegraphics.com.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/reg.h |  2 +-
 arch/powerpc/kernel/tau_6xx.c  | 12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index ca372bbc0ffee..dd262f09a99ed 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -647,7 +647,7 @@
 #define THRM1_TIN	(1 << 31)
 #define THRM1_TIV	(1 << 30)
 #define THRM1_THRES(x)	((x&0x7f)<<23)
-#define THRM3_SITV(x)	((x&0x3fff)<<1)
+#define THRM3_SITV(x)	((x & 0x1fff) << 1)
 #define THRM1_TID	(1<<2)
 #define THRM1_TIE	(1<<1)
 #define THRM1_V		(1<<0)
diff --git a/arch/powerpc/kernel/tau_6xx.c b/arch/powerpc/kernel/tau_6xx.c
index a753b72efbc0c..1880481322880 100644
--- a/arch/powerpc/kernel/tau_6xx.c
+++ b/arch/powerpc/kernel/tau_6xx.c
@@ -174,15 +174,11 @@ static void tau_timeout(void * info)
 	 * complex sleep code needs to be added. One mtspr every time
 	 * tau_timeout is called is probably not a big deal.
 	 *
-	 * Enable thermal sensor and set up sample interval timer
-	 * need 20 us to do the compare.. until a nice 'cpu_speed' function
-	 * call is implemented, just assume a 500 mhz clock. It doesn't really
-	 * matter if we take too long for a compare since it's all interrupt
-	 * driven anyway.
-	 *
-	 * use a extra long time.. (60 us @ 500 mhz)
+	 * The "PowerPC 740 and PowerPC 750 Microprocessor Datasheet"
+	 * recommends that "the maximum value be set in THRM3 under all
+	 * conditions."
 	 */
-	mtspr(SPRN_THRM3, THRM3_SITV(500*60) | THRM3_E);
+	mtspr(SPRN_THRM3, THRM3_SITV(0x1fff) | THRM3_E);
 
 	local_irq_restore(flags);
 }
-- 
2.25.1



