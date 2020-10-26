Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C09299BD7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410168AbgJZXxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410166AbgJZXxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0E920882;
        Mon, 26 Oct 2020 23:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756423;
        bh=4en1etJbfMcAJ0pImQlkn1Yva9agtXtlts5g62gS6Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVkC67tcWyOHG6tUNjGFCRjs0lRjeOU3l3akm2mSVD7XGGdG4Cu0pPlgXRrOa01Ai
         HaiuQknw/qXl9xsNYRlUcDxkbklhl+ADsJjXyLqUX9Iu0iU+s5i8hyTMAkcmkbk9sF
         cJITpF5yOJbN1a9mlN75zZbVJwwUkFWi9JVvN+lw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 079/132] genirq: Add stub for set_handle_irq() when !GENERIC_IRQ_MULTI_HANDLER
Date:   Mon, 26 Oct 2020 19:51:11 -0400
Message-Id: <20201026235205.1023962-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
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
index 1b7f4dfee35b3..b167baef88c0b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -1252,6 +1252,12 @@ int __init set_handle_irq(void (*handle_irq)(struct pt_regs *));
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

