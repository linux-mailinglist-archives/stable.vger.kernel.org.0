Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFB8323CF7
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhBXNAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235420AbhBXMzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8B1564F36;
        Wed, 24 Feb 2021 12:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171108;
        bh=0yegYpsZG9GaKTZcXqT7YupMuvs+SaXzGC220Pjnm1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBncq2l3ZBWmOvxGKJCu7YRbWPsffcQjkgCjFPJLF3KtfCxbBKAWFSC3ZT7LGEDeh
         OAUsF8uHmms8XW0ZF/P6ua/hS7yQBYfE6a9okhFBkLQlMCiJbp+oaBExENEVON+rmC
         Kdke7Jum1pbig3Fwk6MS77O/7ZU366Mw0CAaLeH9WoXhwvSRUP4TRADRrGUum6rZb+
         3Ue41wpK/Ws/qtLzdRqexZk7UNVSjBV0TRKNYAJO/3HFepNs+dPc8S7aZv034cyODZ
         tN9mCkugwWBUM7XXU3YlUmA/oQZndjXgBXvdGWSm3kcHark9uHdz0E6MtdH23z5d4M
         +yzb8HPTaEFJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 61/67] parisc: Bump 64-bit IRQ stack size to 64 KB
Date:   Wed, 24 Feb 2021 07:50:19 -0500
Message-Id: <20210224125026.481804-61-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index 49cd6d2caefb7..1dfb439b06928 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -373,7 +373,11 @@ static inline int eirr_to_irq(unsigned long eirr)
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

