Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F82323D93
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhBXNNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235207AbhBXNCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:02:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 626FF64F57;
        Wed, 24 Feb 2021 12:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171199;
        bh=UKgn+pvbjZLOcPTUi1E151tthHmDUppbf+8RgI/xYSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSV7xbzdp8CsizS5uW53qn9/coISNpt9mWc+Vun8JwqTqddD+FsTWbtFqO+tFb2zF
         lgIfOV1yO0qRvxDjPuzUpOzswW/sObTgGihoY+z/3r4NiAWlQu9kqzpvdwrSpZG1/D
         QH3AFTXfrBV766W/uaXd++TUw/1HGMr6/rQhdjjdR3M1KRxmCyqaBF3oGfzCcvhTPY
         BaHzZ4RYUXyMJqztgDjpemunTf4xZQf9eH5ZjS1ly6ayY1hVrml7X2nN9UWTRGCIw9
         kT/6/SXGDu2L32uSAKY0cX+jTJzsU4oDwy7eCwrKxmV2j179RizgqWeyCBOl/sAFCA
         WVJhwsPHuhQhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 50/56] parisc: Bump 64-bit IRQ stack size to 64 KB
Date:   Wed, 24 Feb 2021 07:52:06 -0500
Message-Id: <20210224125212.482485-50-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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
index e76c866199493..60f5829d476f5 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -376,7 +376,11 @@ static inline int eirr_to_irq(unsigned long eirr)
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

