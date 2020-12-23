Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D942E159E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgLWCum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbgLWCVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF5F122A99;
        Wed, 23 Dec 2020 02:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690092;
        bh=3ZACMQIcQWnmZL9ULyup2SrmOjvIT27EZp63RBPbbSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbvaU/ner6An0EqLSPjbGlv53Pto/UEIuko/fs0SaMpoYHfhSeT2tQb9hTFUypDQb
         CmSwkFzOUYhhsQsDKflyIXDoNBAt6mvxXwjhlcB/xo78jflfD7RbE4oevV0zOq8CQ9
         3jD1yYulZvszJ3ibAdVfz3Fd1dkzUIbNqmSb7C7ZLV3jKagSI2/eTqtfzfkmt/seLh
         y2NFKVVllc0hdVK01+Jojs5FEfgn471MYXpi9rlpKQ8+BzUfIn/ZNU5hj+khPXJ8lJ
         Bhvf72Pop9mZNEE4ppjpH0yIx1nFXbvocZc99VWH1MkMGjOxZQgbtVFXXfY9y6k4Ug
         x/xdiYnic9+oQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/87] MIPS: BMC47xx: fix kconfig dependency bug for BCM47XX_SSB
Date:   Tue, 22 Dec 2020 21:19:59 -0500
Message-Id: <20201223022103.2792705-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 09a48cbcd7af9203296938044f1100bb113ce01a ]

When BCM47XX_SSB is enabled and SSB_PCIHOST is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for SSB_B43_PCI_BRIDGE
  Depends on [n]: SSB [=y] && SSB_PCIHOST [=n]
  Selected by [y]:
  - BCM47XX_SSB [=y] && BCM47XX [=y] && PCI [=y]

The reason is that BCM47XX_SSB selects SSB_B43_PCI_BRIDGE without
depending on or selecting SSB_PCIHOST while SSB_B43_PCI_BRIDGE depends on
SSB_PCIHOST. This can also fail building the kernel as demonstrated in a
bug report.

Honor the kconfig dependency to remove unmet direct dependency warnings
and avoid any potential build failures.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210051
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm47xx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
index 29471038d817e..54e79f3047a14 100644
--- a/arch/mips/bcm47xx/Kconfig
+++ b/arch/mips/bcm47xx/Kconfig
@@ -9,6 +9,7 @@ config BCM47XX_SSB
 	select SSB_DRIVER_MIPS
 	select SSB_DRIVER_EXTIF
 	select SSB_EMBEDDED
+	select SSB_PCIHOST if PCI
 	select SSB_B43_PCI_BRIDGE if PCI
 	select SSB_DRIVER_PCICORE if PCI
 	select SSB_PCICORE_HOSTMODE if PCI
-- 
2.27.0

