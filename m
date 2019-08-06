Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024A483C70
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfHFVfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbfHFVfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:35:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31B08217D9;
        Tue,  6 Aug 2019 21:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127335;
        bh=hnjPdept+35vMcFmZGvmNQcR4/QsLjxDNRb8z2SIzBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yN1jEisrw3+8W85T9HRqmOlb60qgOmvLlQsRl1LnucOkam9gPLKzu+U4vplOpv5PH
         uj8GZr5hnqc8p9BYUWVjTfQrZo/Wqc8SPPrUgWRA3ERqcu456xun7lRVcXkGKhS9wB
         KQQ5scvPZhmmgosPUPkD68uxu6H/WMnUG3Y3rJjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nianyao Tang <tangnianyao@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 06/32] irqchip/gic-v3-its: Free unused vpt_page when alloc vpe table fail
Date:   Tue,  6 Aug 2019 17:34:54 -0400
Message-Id: <20190806213522.19859-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213522.19859-1-sashal@kernel.org>
References: <20190806213522.19859-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nianyao Tang <tangnianyao@huawei.com>

[ Upstream commit 34f8eb92ca053cbba2887bb7e4dbf2b2cd6eb733 ]

In its_vpe_init, when its_alloc_vpe_table fails, we should free
vpt_page allocated just before, instead of vpe->vpt_page.
Let's fix it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ee30e8965d1be..9ba73e11757d9 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2883,7 +2883,7 @@ static int its_vpe_init(struct its_vpe *vpe)
 
 	if (!its_alloc_vpe_table(vpe_id)) {
 		its_vpe_id_free(vpe_id);
-		its_free_pending_table(vpe->vpt_page);
+		its_free_pending_table(vpt_page);
 		return -ENOMEM;
 	}
 
-- 
2.20.1

