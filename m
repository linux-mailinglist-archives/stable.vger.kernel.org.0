Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7181D499531
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392406AbiAXUvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390184AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD76C061381;
        Mon, 24 Jan 2022 11:54:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C6CD61012;
        Mon, 24 Jan 2022 19:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AE6C340E5;
        Mon, 24 Jan 2022 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054090;
        bh=6j0VPUnXttJfHiteE5SxThT+4Mz+16P0Y0QVdGbg2/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2RpqiQnpMLiWlVt3opMIG63jgQtApxmGOwApqSbp6SkeWEr95vxgV2bwTC6o/RKg
         piawuthXqJXp2NrIcVfL0nYTYP9RaMRRPn9qIORHCS3tC61YqZOCDNSTQDj9hmyZQB
         G+7gct8lGddLL8Cee3eBP60w2Elfw7+h/W9CAGrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/563] mips: fix Kconfig reference to PHYS_ADDR_T_64BIT
Date:   Mon, 24 Jan 2022 19:40:40 +0100
Message-Id: <20220124184033.951928346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit a670c82d9ca4f1e7385d9d6f26ff41a50fbdd944 ]

Commit d4a451d5fc84 ("arch: remove the ARCH_PHYS_ADDR_T_64BIT config
symbol") removes config ARCH_PHYS_ADDR_T_64BIT with all instances of that
config refactored appropriately. Since then, it is recommended to use the
config PHYS_ADDR_T_64BIT instead.

Commit 171543e75272 ("MIPS: Disallow CPU_SUPPORTS_HUGEPAGES for XPA,EVA")
introduces the expression "!(32BIT && (ARCH_PHYS_ADDR_T_64BIT || EVA))"
for config CPU_SUPPORTS_HUGEPAGES, which unintentionally refers to the
non-existing symbol ARCH_PHYS_ADDR_T_64BIT instead of the intended
PHYS_ADDR_T_64BIT.

Fix this Kconfig reference to the intended PHYS_ADDR_T_64BIT.

This issue was identified with the script ./scripts/checkkconfigsymbols.py.
I then reported it on the mailing list and Paul confirmed the mistake in
the linked email thread.

Link: https://lore.kernel.org/lkml/H8IU3R.H5QVNRA077PT@crapouillou.net/
Suggested-by: Paul Cercueil <paul@crapouillou.net>
Fixes: 171543e75272 ("MIPS: Disallow CPU_SUPPORTS_HUGEPAGES for XPA,EVA")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index db8fe5d7a2377..3442bdd4314cb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2150,7 +2150,7 @@ config CPU_SUPPORTS_ADDRWINCFG
 	bool
 config CPU_SUPPORTS_HUGEPAGES
 	bool
-	depends on !(32BIT && (ARCH_PHYS_ADDR_T_64BIT || EVA))
+	depends on !(32BIT && (PHYS_ADDR_T_64BIT || EVA))
 config MIPS_PGD_C0_CONTEXT
 	bool
 	default y if 64BIT && (CPU_MIPSR2 || CPU_MIPSR6) && !CPU_XLP
-- 
2.34.1



