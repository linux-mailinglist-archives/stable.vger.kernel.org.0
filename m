Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815EA323DCD
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhBXNTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234150AbhBXNIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E43964F14;
        Wed, 24 Feb 2021 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171305;
        bh=1YK8oSAN7rQInznGmAOuKCx15FokfzKFU8CdTji2RAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fReEpa4kIta+8XZk2FBo645tG9yRa7B7bRdjU28Y0y54efYR+VDhc2HLHpGwWbTQS
         D0y3QZpLNTmkEUaHcyOPJCZOlXnclKQ/oo2C12CXQC6DzqYZcpyHayNZRUbh/enP46
         mKBRBZ6ww5Vu03gJoX8V5ziedWJd2RXahTfBsXBv6jUGpfY4q2sM64Aml3Faqxoq5o
         XxFjOFFhqg7zgzgLT022liGrvDEtnsWkyDehT6QbTLWnYq1VrkHY1ekSoO18PwB/I7
         8JpVhSsm/C6S6Y944ZvbWdn6koH24ryPoSFN2/eqkWKvlJeqzZAv7t0H3/y2uoO1Fm
         xj8SRYEV5/8KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/26] parisc: Bump 64-bit IRQ stack size to 64 KB
Date:   Wed, 24 Feb 2021 07:54:31 -0500
Message-Id: <20210224125435.483539-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
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

