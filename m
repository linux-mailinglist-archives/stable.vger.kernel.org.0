Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E0310656B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfKVGYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:24:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbfKVFv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F05E520730;
        Fri, 22 Nov 2019 05:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401886;
        bh=TvnrklSzh6sXwmGAPCZ0w0s7Anb3NdKGb5fXdATgkoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjBRgD5vn3SiH6VbMmCocfyJxrFm1QCi1oEPmPP5/dm9fpCyEEC+YrQiBNnzD6U4t
         LhJ1TyM3a2SAA3XstJEvCNZIgdMp34tWMgSBXMcRtFsZhNnXhiqmKL/oEL6WLMIfyn
         MBVV2usZJFScR2iaw9HXAW+kWrL0/1q/DzlDF3xg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 120/219] powerpc/prom: fix early DEBUG messages
Date:   Fri, 22 Nov 2019 00:47:32 -0500
Message-Id: <20191122054911.1750-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit b18f0ae92b0a1db565c3e505fa87b6971ad3b641 ]

This patch fixes early DEBUG messages in prom.c:
- Use %px instead of %p to see the addresses
- Cast memblock_phys_mem_size() with (unsigned long long) to
avoid build failure when phys_addr_t is not 64 bits.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index c4d7078e5295f..8e88f78e57dba 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -129,7 +129,7 @@ static void __init move_device_tree(void)
 		p = __va(memblock_alloc(size, PAGE_SIZE));
 		memcpy(p, initial_boot_params, size);
 		initial_boot_params = p;
-		DBG("Moved device tree to 0x%p\n", p);
+		DBG("Moved device tree to 0x%px\n", p);
 	}
 
 	DBG("<- move_device_tree\n");
@@ -689,7 +689,7 @@ void __init early_init_devtree(void *params)
 {
 	phys_addr_t limit;
 
-	DBG(" -> early_init_devtree(%p)\n", params);
+	DBG(" -> early_init_devtree(%px)\n", params);
 
 	/* Too early to BUG_ON(), do it by hand */
 	if (!early_init_dt_verify(params))
@@ -749,7 +749,7 @@ void __init early_init_devtree(void *params)
 	memblock_allow_resize();
 	memblock_dump_all();
 
-	DBG("Phys. mem: %llx\n", memblock_phys_mem_size());
+	DBG("Phys. mem: %llx\n", (unsigned long long)memblock_phys_mem_size());
 
 	/* We may need to relocate the flat tree, do it now.
 	 * FIXME .. and the initrd too? */
-- 
2.20.1

