Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BCA3CE5E6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348682AbhGSPz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350520AbhGSPvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE3B76127C;
        Mon, 19 Jul 2021 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712200;
        bh=wrAXyTUu8iaEYGFgf4AL1J9lnFaFjPOR7mr8+BQtH7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ool7iYE8MI6vCsqKD1V8BZenb5SApiqTe3S6TYs55vie7p2yIPZvZSekUmrfJBP/T
         HA/1iGuHAWqI3dFXdAczA6lYi/vOSDgLqMCPg+jCnSy2WNAtTOVfucQmOumH4v88YP
         nIF7uzvd81EQzcDLcVaocCcIccL9LE47tyE+T9io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20F=C3=A4cknitz?= <faecknitz@hotsplots.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 288/292] MIPS: vdso: Invalid GIC access through VDSO
Date:   Mon, 19 Jul 2021 16:55:50 +0200
Message-Id: <20210719144952.387046837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fäcknitz <faecknitz@hotsplots.de>

[ Upstream commit 47ce8527fbba145a7723685bc9a27d9855e06491 ]

Accessing raw timers (currently only CLOCK_MONOTONIC_RAW) through VDSO
doesn't return the correct time when using the GIC as clock source.
The address of the GIC mapped page is in this case not calculated
correctly. The GIC mapped page is calculated from the VDSO data by
subtracting PAGE_SIZE:

  void *get_gic(const struct vdso_data *data) {
    return (void __iomem *)data - PAGE_SIZE;
  }

However, the data pointer is not page aligned for raw clock sources.
This is because the VDSO data for raw clock sources (CS_RAW = 1) is
stored after the VDSO data for coarse clock sources (CS_HRES_COARSE = 0).
Therefore, only the VDSO data for CS_HRES_COARSE is page aligned:

  +--------------------+
  |                    |
  | vd[CS_RAW]         | ---+
  | vd[CS_HRES_COARSE] |    |
  +--------------------+    | -PAGE_SIZE
  |                    |    |
  |  GIC mapped page   | <--+
  |                    |
  +--------------------+

When __arch_get_hw_counter() is called with &vd[CS_RAW], get_gic returns
the wrong address (somewhere inside the GIC mapped page). The GIC counter
values are not returned which results in an invalid time.

Fixes: a7f4df4e21dd ("MIPS: VDSO: Add implementations of gettimeofday() and clock_gettime()")
Signed-off-by: Martin Fäcknitz <faecknitz@hotsplots.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/vdso/vdso.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/vdso/vdso.h b/arch/mips/include/asm/vdso/vdso.h
index 737ddfc3411c..a327ca21270e 100644
--- a/arch/mips/include/asm/vdso/vdso.h
+++ b/arch/mips/include/asm/vdso/vdso.h
@@ -67,7 +67,7 @@ static inline const struct vdso_data *get_vdso_data(void)
 
 static inline void __iomem *get_gic(const struct vdso_data *data)
 {
-	return (void __iomem *)data - PAGE_SIZE;
+	return (void __iomem *)((unsigned long)data & PAGE_MASK) - PAGE_SIZE;
 }
 
 #endif /* CONFIG_CLKSRC_MIPS_GIC */
-- 
2.30.2



