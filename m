Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10ACFCAB31
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389157AbfJCRTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387531AbfJCQVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:21:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E529A20865;
        Thu,  3 Oct 2019 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119690;
        bh=ou04+K90P77FEjz3NVJiDUkWPy03xWDaNgpyoEq38D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDp6Q36fTgUooBwpG39/M2SguPfiUsvqmVtOeLIAVxaKdfBig18WAvmlwpG2364mF
         W/hIb3YSkCNBdnHV/KhCxLcXvHG4mSXCk1UIe9tTPtf3HEMbYXrABub54sfzWvS81I
         dGBLQoAMAhElYWBcBAm6Qd3AY/hYyjdFFT4pK98c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jinyu Qi <jinyuqi@huawei.com>, Joerg Roedel <jroedel@suse.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/211] iommu/iova: Avoid false sharing on fq_timer_on
Date:   Thu,  3 Oct 2019 17:53:04 +0200
Message-Id: <20191003154514.237490697@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9a576ae837dcb..da4516fbf5425 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -580,7 +580,9 @@ void queue_iova(struct iova_domain *iovad,
 
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



