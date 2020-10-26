Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF5A299CF7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgJ0ACw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411063AbgJZX4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1BA32222C;
        Mon, 26 Oct 2020 23:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756573;
        bh=T9ukAjORjEUpFo1dtup9GpXhoavLAgNSdh3cC+7TZtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tON3J4x7ftCv8wJTgxOdYTE0WpNKuVKDt/eMYCeWC5MV+L52ILPdDR8YGSZJCp72C
         Gk5gcUn2Taif9EeVDrU/dSmmfuwoVmdjevUxR3oudK/tPHY7kH22TUcVEYxLH29k/p
         4tFg9Z+qUCtoBWqfcq6s9RiVo53KE6Ziyd55y1cI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 47/80] genirq: Add stub for set_handle_irq() when !GENERIC_IRQ_MULTI_HANDLER
Date:   Mon, 26 Oct 2020 19:54:43 -0400
Message-Id: <20201026235516.1025100-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit ea0c80d1764449acf2f70fdb25aec33800cd0348 ]

In order to avoid compilation errors when a driver references set_handle_irq(),
but that the architecture doesn't select GENERIC_IRQ_MULTI_HANDLER,
add a stub function that will just WARN_ON_ONCE() if ever used.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
[maz: commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200924071754.4509-2-thunder.leizhen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index e9e69c511ea92..437eb143f9f44 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -1235,6 +1235,12 @@ int __init set_handle_irq(void (*handle_irq)(struct pt_regs *));
  * top-level IRQ handler.
  */
 extern void (*handle_arch_irq)(struct pt_regs *) __ro_after_init;
+#else
+#define set_handle_irq(handle_irq)		\
+	do {					\
+		(void)handle_irq;		\
+		WARN_ON(1);			\
+	} while (0)
 #endif
 
 #endif /* _LINUX_IRQ_H */
-- 
2.25.1

