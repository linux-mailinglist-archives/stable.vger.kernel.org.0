Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F7610B8FF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbfK0Usz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:48:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbfK0Usx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:48:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60F121787;
        Wed, 27 Nov 2019 20:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887733;
        bh=2KBB84b10gJqMmfdG4V8Z+ln6G26XwMY73MG7KwkykA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9tRArzcC6Tac0UX2EbUOAbO9xcCbvHerv5X+6DuKSU2icrYmgNGOEsjqS0Enqx+V
         n5/TVJdh9+7pMaJu+TU5DTa4Q3+aqxC+ahh6um2+cooz020+7YvqgbAKH0aoQd0IQX
         eCTQcvMqoQ7BS/viz4ikpJk51jiRx9WEGFjOaEH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 073/211] sparc: Fix parport build warnings.
Date:   Wed, 27 Nov 2019 21:30:06 +0100
Message-Id: <20191127203100.742434887@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
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



