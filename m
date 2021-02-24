Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA14323E25
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhBXNZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236096AbhBXNNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:13:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B733E64FA9;
        Wed, 24 Feb 2021 12:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171335;
        bh=1YK8oSAN7rQInznGmAOuKCx15FokfzKFU8CdTji2RAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeMPw3d9QF5XWitKWWo5yCjcGhE5t7C76nLOTnHUCLUI6JbIo7gTcAIQAvj1+4Oc7
         mqR9VTR/am6rcP8EbLbzZcx6rSFwwJ+sX+x9D+mBaFMHm+eQjVIVPXgG98tfp4QceH
         XT3EQ7yMQEkKknnwqYVRFYDZTFQYk0p7QpEqql2l7B26SAJ0q/BAWIw4rLzkfXeoHw
         my+m4UQkdDbQm0DJ8kxippo3xKa0vnriGycN+GhViMk+l9OWlcT+WHtM5yQ1ZGXOTK
         Zb7vQIySf3pkZofc3Goj8+cfLYvjCjrclhIVXFXnve28jzcVMjGkhAb2Hnc+TvZupe
         9g6olbGOjStcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/16] parisc: Bump 64-bit IRQ stack size to 64 KB
Date:   Wed, 24 Feb 2021 07:55:13 -0500
Message-Id: <20210224125514.483935-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit 31680c1d1595a59e17c14ec036b192a95f8e5f4a ]

Bump 64-bit IRQ stack size to 64 KB.

I had a kernel IRQ stack overflow on the mx3210 debian buildd machine.  This patch increases the
64-bit IRQ stack size to 64 KB.  The 64-bit stack size needs to be larger than the 32-bit stack
size since registers are twice as big.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 0ca254085a662..c152c30c2d06d 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -380,7 +380,11 @@ static inline int eirr_to_irq(unsigned long eirr)
 /*
  * IRQ STACK - used for irq handler
  */
+#ifdef CONFIG_64BIT
+#define IRQ_STACK_SIZE      (4096 << 4) /* 64k irq stack size */
+#else
 #define IRQ_STACK_SIZE      (4096 << 3) /* 32k irq stack size */
+#endif
 
 union irq_stack_union {
 	unsigned long stack[IRQ_STACK_SIZE/sizeof(unsigned long)];
-- 
2.27.0

