Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC7323DA7
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhBXNOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235807AbhBXNHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:07:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0564A64F7F;
        Wed, 24 Feb 2021 12:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171266;
        bh=n3+hBgB3Bu9tSf0VgVIejY8VIc+GhbJStIOOgD2WTaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMlKH+sIC9D714dMdp1re+nwYNRpCxXMSumlwLl3jOmyZYci/Y21A8uAzs+qCBNmf
         wWmfsiyqPFRNcLQnAva4/EjvSbqdaCwkHt1QFhoUL3ngwAvnieU15MMfchgTyiXehp
         kbUQN2ktU3bu/vCmegC7r8fX1W2OKPEcHh+XDk7keCdZlA1qTFn/xBkTkmoh/F/zSs
         SNNyfsS6O01iV1H9W6oLzmIZYTuVkdd8wuM5kMMw6CUx+sva+CQQ1X+fiBrGHrNHuL
         TcElFxJoC/jsHbbvK8qz6pLI0TFYgLebI1Fc/XYUOBI+k1VS1C/3bdQV3Igrh+LjkL
         vqlT5JD59xwIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 35/40] parisc: Bump 64-bit IRQ stack size to 64 KB
Date:   Wed, 24 Feb 2021 07:53:35 -0500
Message-Id: <20210224125340.483162-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
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
index e5fcfb70cc7c0..4d54aa70ea5f3 100644
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

