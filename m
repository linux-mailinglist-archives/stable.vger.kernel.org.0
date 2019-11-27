Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63A710B7A6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfK0Ufl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:35:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfK0Ufk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D569021569;
        Wed, 27 Nov 2019 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886940;
        bh=7LaErUhJdmTpbtcjeuEhaAeVt66iI+/qbhdzpL30bTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V759+tPrhLH/ikpMwfvmSXTrFTfbrkcixEikcgfYjClGbslPECo3aZpWz5n7W3m4A
         6El4ZnS57FtklalW6OJY6JHD2JnAGIMrGKsakUtVfgISXRlxHhubS6SFdPXAcrNPC0
         KrfMphyty2OpdNKoIwuXBcCeOaxYL3W9/+pceunc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 051/132] sparc: Fix parport build warnings.
Date:   Wed, 27 Nov 2019 21:30:42 +0100
Message-Id: <20191127202949.362119708@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

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
index f005ccac91cc9..e87c0f81b700e 100644
--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -20,6 +20,7 @@
  */
 #define HAS_DMA
 
+#ifdef CONFIG_PARPORT_PC_FIFO
 static DEFINE_SPINLOCK(dma_spin_lock);
 
 #define claim_dma_lock() \
@@ -30,6 +31,7 @@ static DEFINE_SPINLOCK(dma_spin_lock);
 
 #define release_dma_lock(__flags) \
 	spin_unlock_irqrestore(&dma_spin_lock, __flags);
+#endif
 
 static struct sparc_ebus_info {
 	struct ebus_dma_info info;
-- 
2.20.1



