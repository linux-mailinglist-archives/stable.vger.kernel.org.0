Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5C695FF
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbfGOOMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389122AbfGOOMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:12:49 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D96872083D;
        Mon, 15 Jul 2019 14:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199967;
        bh=lOE15GJAkkPs907XzEXCOpEE2O4/Jf4GNtl+bvxUd8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kr6Eb6UmMhNF3U3EntBknwUCN6uSKmYO4sPworlR+r7qMBlcq0BK9nN6H4/S37bT6
         m/DAvdvHC6jLP6/GVqv51y8fU7n/uq6HLa4anFoUYz9K6jMl4w8710p0zJv4yhS8TU
         ghqnzjm7s2aTtzF0n5SaZ6zQGaNASDKwGgq8D/+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 149/219] clocksource/drivers/tegra: Release all IRQ's on request_irq() error
Date:   Mon, 15 Jul 2019 10:02:30 -0400
Message-Id: <20190715140341.6443-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 7a3916706e858ad0bc3b5629c68168e1449de26a ]

Release all requested IRQ's on the request error to properly clean up
allocated resources.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-By: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-tegra20.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-tegra20.c b/drivers/clocksource/timer-tegra20.c
index fdb3d795a409..cc18bb135a17 100644
--- a/drivers/clocksource/timer-tegra20.c
+++ b/drivers/clocksource/timer-tegra20.c
@@ -310,7 +310,7 @@ static int __init tegra_init_timer(struct device_node *np)
 			pr_err("%s: can't map IRQ for CPU%d\n",
 			       __func__, cpu);
 			ret = -EINVAL;
-			goto out;
+			goto out_irq;
 		}
 
 		irq_set_status_flags(cpu_to->clkevt.irq, IRQ_NOAUTOEN);
@@ -320,7 +320,8 @@ static int __init tegra_init_timer(struct device_node *np)
 		if (ret) {
 			pr_err("%s: cannot setup irq %d for CPU%d\n",
 				__func__, cpu_to->clkevt.irq, cpu);
-			ret = -EINVAL;
+			irq_dispose_mapping(cpu_to->clkevt.irq);
+			cpu_to->clkevt.irq = 0;
 			goto out_irq;
 		}
 	}
-- 
2.20.1

