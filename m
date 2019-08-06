Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10283CC7
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfHFVp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfHFVdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:33:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAB5217D7;
        Tue,  6 Aug 2019 21:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127215;
        bh=7PacgezBhWgl49FGiKUsGiEA921Ao2dsp7XTPPO661U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+ZXhAj2hKVEJW8KIgJdC55VEzMpYZjoF+DuoAiatx0vIl7kPOZokAoIFCh/pMWuP
         re22MSlsJbwdNR9q1riIggxdKxEJ0t5IEEkjn4ITZMn+/9PyN7+qtqHNJ07YvAMZto
         6BKGnj0R9iU5+FbCmoLsEhnAxrD5dC5t1fSL2NQ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nianyao Tang <tangnianyao@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 12/59] irqchip/gic-v3-its: Free unused vpt_page when alloc vpe table fail
Date:   Tue,  6 Aug 2019 17:32:32 -0400
Message-Id: <20190806213319.19203-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
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
index 35500801dc2b5..20e5482d91b94 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3010,7 +3010,7 @@ static int its_vpe_init(struct its_vpe *vpe)
 
 	if (!its_alloc_vpe_table(vpe_id)) {
 		its_vpe_id_free(vpe_id);
-		its_free_pending_table(vpe->vpt_page);
+		its_free_pending_table(vpt_page);
 		return -ENOMEM;
 	}
 
-- 
2.20.1

