Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560EAFF310
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfKPQXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbfKPPnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:00 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E43A20740;
        Sat, 16 Nov 2019 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918980;
        bh=G198HjGEWxt/kMMfYKLq7qrRGUBrAdqtBeP+Wdaj69s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXNhpDwgx3UL4wDz2980pDVItD/GYB6h4PBDkb35bGLIQNQneDVyO8lnxsxIwhhyB
         rqBwQb1u5BafU+BNCL+oz0g34fG/umJVUYCHKG8jNK76bLEmsJN6j2qrMy4EDy+1KV
         eYqCOvMy052R7WrbupgI2GYGaJ4Qw4GOVmrdm664=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 089/237] sparc: Fix parport build warnings.
Date:   Sat, 16 Nov 2019 10:38:44 -0500
Message-Id: <20191116154113.7417-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 46b8306480fb424abd525acc1763da1c63a27d8a ]

If PARPORT_PC_FIFO is not enabled, do not provide the dma lock
macros and lock definition.  Otherwise:

./arch/sparc/include/asm/parport.h:24:24: warning: ‘dma_spin_lock’ defined but not used [-Wunused-variable]
 static DEFINE_SPINLOCK(dma_spin_lock);
                        ^~~~~~~~~~~~~
./include/linux/spinlock_types.h:81:39: note: in definition of macro ‘DEFINE_SPINLOCK’
 #define DEFINE_SPINLOCK(x) spinlock_t x = __SPIN_LOCK_UNLOCKED(x)

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/parport.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/include/asm/parport.h b/arch/sparc/include/asm/parport.h
index 05df5f0430535..3c5a1c620f0f7 100644
--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -21,6 +21,7 @@
  */
 #define HAS_DMA
 
+#ifdef CONFIG_PARPORT_PC_FIFO
 static DEFINE_SPINLOCK(dma_spin_lock);
 
 #define claim_dma_lock() \
@@ -31,6 +32,7 @@ static DEFINE_SPINLOCK(dma_spin_lock);
 
 #define release_dma_lock(__flags) \
 	spin_unlock_irqrestore(&dma_spin_lock, __flags);
+#endif
 
 static struct sparc_ebus_info {
 	struct ebus_dma_info info;
-- 
2.20.1

