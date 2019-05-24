Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6754B298E0
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 15:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391124AbfEXN1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 09:27:45 -0400
Received: from foss.arm.com ([217.140.101.70]:43096 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391359AbfEXN1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 09:27:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54658A78;
        Fri, 24 May 2019 06:27:45 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1624E3F5AF;
        Fri, 24 May 2019 06:27:43 -0700 (PDT)
From:   Will Deacon <will.deacon@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>,
        "# 5 . 1" <stable@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH] arm64: Kconfig: Make ARM64_PSEUDO_NMI depend on BROKEN for now
Date:   Fri, 24 May 2019 14:27:35 +0100
Message-Id: <20190524132735.6592-1-will.deacon@arm.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although we merged support for pseudo-nmi using interrupt priority
masking in 5.1, we've since uncovered a number of non-trivial issues
with the implementation. Although there are patches pending to address
these problems, we're facing issues that prevent us from merging them at
this current time:

  https://lkml.kernel.org/r/1556553607-46531-1-git-send-email-julien.thierry@arm.com

For now, simply mark this optional feature as BROKEN in the hope that we
can fix things properly in the near future.

Cc: <stable@vger.kernel.org> # 5.1
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6a9544606da3..f6275c265d41 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1422,6 +1422,7 @@ config ARM64_MODULE_PLTS
 
 config ARM64_PSEUDO_NMI
 	bool "Support for NMI-like interrupts"
+	depends on BROKEN # 1556553607-46531-1-git-send-email-julien.thierry@arm.com
 	select CONFIG_ARM_GIC_V3
 	help
 	  Adds support for mimicking Non-Maskable Interrupts through the use of
-- 
2.11.0

