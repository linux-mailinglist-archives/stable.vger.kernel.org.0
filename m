Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEB83CD8DC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243539AbhGSOZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243674AbhGSOYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE42D61221;
        Mon, 19 Jul 2021 15:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707037;
        bh=TNFVtHoJc3PqwJwXyaoHT9IFm9G1RO35rNOmgMwLZag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdESDIcChGQhFVdFBbSnFIkeNF9KMEjmVlOUXKQR4mSlB9WnikV5Nx33XWRglCKPh
         qpJxoI6eqqkLtZ6N4UnFMnnMqkWzcIY5OqbFzW3XpHN1PvcFO4pYf8WvwE4SbjK0X1
         NGAAElZhXl1ElpinUqeSkOewv+xtuIXUN8UQQLFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20F=C3=A4cknitz?= <faecknitz@hotsplots.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 188/188] MIPS: vdso: Invalid GIC access through VDSO
Date:   Mon, 19 Jul 2021 16:52:52 +0200
Message-Id: <20210719144942.638725545@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
 arch/mips/vdso/vdso.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/vdso/vdso.h b/arch/mips/vdso/vdso.h
index cfb1be441dec..921589b45bc2 100644
--- a/arch/mips/vdso/vdso.h
+++ b/arch/mips/vdso/vdso.h
@@ -81,7 +81,7 @@ static inline const union mips_vdso_data *get_vdso_data(void)
 
 static inline void __iomem *get_gic(const union mips_vdso_data *data)
 {
-	return (void __iomem *)data - PAGE_SIZE;
+	return (void __iomem *)((unsigned long)data & PAGE_MASK) - PAGE_SIZE;
 }
 
 #endif /* CONFIG_CLKSRC_MIPS_GIC */
-- 
2.30.2



