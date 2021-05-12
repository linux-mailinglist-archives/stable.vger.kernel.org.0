Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D69A37C90A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhELQOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237236AbhELQDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 461C361CE5;
        Wed, 12 May 2021 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833636;
        bh=zI7Y3eoRvSmUAbw0F9EQYAe4yxfzLU+kte5ZhBkqarg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ly+3FeCgttE4wmIZdIOJrmKWHcOifaynmW93Jj8IB8iwAqKRCQ8zIxIeM0CY5gp3a
         4tz+DDC/HNoBHpeWLkhni3PIwWhA4re9pBDlxMusEBBvyvdJ28Ss37KTlSKFktFgl3
         aX+DkiZ+Ljhk0iyXQidihQA4xvRppxy3wsOvG2Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, gexueyuan <gexueyuan@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 230/601] memory: pl353: fix mask of ECC page_size config register
Date:   Wed, 12 May 2021 16:45:07 +0200
Message-Id: <20210512144835.403500500@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: gexueyuan <gexueyuan@gmail.com>

[ Upstream commit 25dcca7fedcd4e31cb368ad846bfd738c0c6307c ]

The mask for page size of ECC Configuration Register should be 0x3,
according to  the datasheet of PL353 smc.

Fixes: fee10bd22678 ("memory: pl353: Add driver for arm pl353 static memory controller")
Signed-off-by: gexueyuan <gexueyuan@gmail.com>
Link: https://lore.kernel.org/r/20210331031056.5326-1-gexueyuan@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/pl353-smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/pl353-smc.c b/drivers/memory/pl353-smc.c
index 73bd3023202f..b42804b1801e 100644
--- a/drivers/memory/pl353-smc.c
+++ b/drivers/memory/pl353-smc.c
@@ -63,7 +63,7 @@
 /* ECC memory config register specific constants */
 #define PL353_SMC_ECC_MEMCFG_MODE_MASK	0xC
 #define PL353_SMC_ECC_MEMCFG_MODE_SHIFT	2
-#define PL353_SMC_ECC_MEMCFG_PGSIZE_MASK	0xC
+#define PL353_SMC_ECC_MEMCFG_PGSIZE_MASK	0x3
 
 #define PL353_SMC_DC_UPT_NAND_REGS	((4 << 23) |	/* CS: NAND chip */ \
 				 (2 << 21))	/* UpdateRegs operation */
-- 
2.30.2



