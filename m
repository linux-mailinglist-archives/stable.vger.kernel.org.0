Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDD7BA4F3
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393729AbfIVSxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393614AbfIVSxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:53:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7197E21D79;
        Sun, 22 Sep 2019 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178392;
        bh=9SO459Tx95hQLcr6M3fZdhK5p3dMn/Dz2ldcdyi20Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0kb8t8cso9QRkDSS5PvuCLEbeGnak6pvLrqn6w5+VkAlSgP83iKdUHXaSdG2en8Z
         WhOJwQYSpdY9XX1aFiCcHUopKBKmdZKWAuhmfFsxadMMn82HXSEjRP4BH/K64bRAn3
         tkMAvvvJ6FntjyydQfN2KRlPqFIIjOpCcBsQSln4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Jinyu Qi <jinyuqi@huawei.com>,
        Joerg Roedel <jroedel@suse.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.2 138/185] iommu/iova: Avoid false sharing on fq_timer_on
Date:   Sun, 22 Sep 2019 14:48:36 -0400
Message-Id: <20190922184924.32534-138-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0d87308cca2c124f9bce02383f1d9632c9be89c4 ]

In commit 14bd9a607f90 ("iommu/iova: Separate atomic variables
to improve performance") Jinyu Qi identified that the atomic_cmpxchg()
in queue_iova() was causing a performance loss and moved critical fields
so that the false sharing would not impact them.

However, avoiding the false sharing in the first place seems easy.
We should attempt the atomic_cmpxchg() no more than 100 times
per second. Adding an atomic_read() will keep the cache
line mostly shared.

This false sharing came with commit 9a005a800ae8
("iommu/iova: Add flush timer").

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 9a005a800ae8 ('iommu/iova: Add flush timer')
Cc: Jinyu Qi <jinyuqi@huawei.com>
Cc: Joerg Roedel <jroedel@suse.de>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iova.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 3e1a8a6755723..41c605b0058f9 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -577,7 +577,9 @@ void queue_iova(struct iova_domain *iovad,
 
 	spin_unlock_irqrestore(&fq->lock, flags);
 
-	if (atomic_cmpxchg(&iovad->fq_timer_on, 0, 1) == 0)
+	/* Avoid false sharing as much as possible. */
+	if (!atomic_read(&iovad->fq_timer_on) &&
+	    !atomic_cmpxchg(&iovad->fq_timer_on, 0, 1))
 		mod_timer(&iovad->fq_timer,
 			  jiffies + msecs_to_jiffies(IOVA_FQ_TIMEOUT));
 }
-- 
2.20.1

