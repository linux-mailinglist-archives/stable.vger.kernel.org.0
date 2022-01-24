Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8562049A310
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366112AbiAXXwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844233AbiAXXIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:08:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E77FC09F4A2;
        Mon, 24 Jan 2022 13:17:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6B8CB811A2;
        Mon, 24 Jan 2022 21:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73DBC340E4;
        Mon, 24 Jan 2022 21:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059057;
        bh=ipmEVIXRYyq7vp4hJryUoLzFfRdVsSjgjmRpnw7mLfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEfjjrRP/8VRbvOKHqKl7jQdQPvZrB00+p7bLoGhtTC6BtIzVScTN4tvvsJWFALgv
         MI1KzaOq2EFI+jal7ulwepY8BKZV74EwBBUHnq5IOa/M87fViKKJrqni+9fxdCf3bz
         UwbPJyvsnm1NF6sr/SNTiknO2bIQXznQ6RuN2izM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0491/1039] mips: fix Kconfig reference to PHYS_ADDR_T_64BIT
Date:   Mon, 24 Jan 2022 19:38:00 +0100
Message-Id: <20220124184141.767752121@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 91ce1c57af005..c5826236d913a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2069,7 +2069,7 @@ config CPU_SUPPORTS_ADDRWINCFG
 	bool
 config CPU_SUPPORTS_HUGEPAGES
 	bool
-	depends on !(32BIT && (ARCH_PHYS_ADDR_T_64BIT || EVA))
+	depends on !(32BIT && (PHYS_ADDR_T_64BIT || EVA))
 config MIPS_PGD_C0_CONTEXT
 	bool
 	depends on 64BIT
-- 
2.34.1



