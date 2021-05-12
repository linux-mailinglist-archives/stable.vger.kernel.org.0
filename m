Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05C237C18C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhELPBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhELO7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC5D613EB;
        Wed, 12 May 2021 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831393;
        bh=zI7Y3eoRvSmUAbw0F9EQYAe4yxfzLU+kte5ZhBkqarg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iL6u8nwh1YHvJAv8UIDiq7QVgzuIwML6CGcnMDWc+ty0cxlc/PIVClUjSIW/enIYb
         2tJqcV7EC3mlMoa50qypXJ0Wr+6Vcm27uwssSgtpuQtqNwe0Tyi7n67P9X8Yg62k3E
         fuHfrzIgN4zNIPGARcHfDKuo1t4/Hbbwl4+XIXdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, gexueyuan <gexueyuan@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/244] memory: pl353: fix mask of ECC page_size config register
Date:   Wed, 12 May 2021 16:47:53 +0200
Message-Id: <20210512144746.296152431@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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



