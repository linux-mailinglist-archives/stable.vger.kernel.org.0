Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E065D4174B7
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345827AbhIXNKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346698AbhIXNHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3FBA60EE7;
        Fri, 24 Sep 2021 12:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488213;
        bh=QiuKuW73Wh8feZh+0sz1O5hDzl5n8fQfeSkHMrFLOUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McxPPWeFbAVJopGwkO1aQasZ6ZSfLCSdbcmYgnZzPaopZpVETqntWDc/87UIxt6Wv
         Py5LjkPGeouB1U8/GmIg5KMdm4EjboW5x9pJCKeiijo+1mC/pEMGKmfqnC2HA8F0Xg
         J/SyRy6sH8NpdX9VZdU0OliGGq1nrsnqJHP1ogI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/63] dmaengine: idxd: fix wq slot allocation index check
Date:   Fri, 24 Sep 2021 14:44:27 +0200
Message-Id: <20210924124335.194549760@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 673d812d30be67942762bb9e8548abb26a3ba4a7 ]

The sbitmap wait and allocate routine checks the index that is returned
from sbitmap_queue_get(). It should be idxd >= 0 as 0 is also a valid
index. This fixes issue where submission path hangs when WQ size is 1.

Fixes: 0705107fcc80 ("dmaengine: idxd: move submission to sbitmap_queue")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162697645067.3478714.506720687816951762.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 417048e3c42a..0368c5490788 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -45,7 +45,7 @@ struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq, enum idxd_op_type optype)
 		if (signal_pending_state(TASK_INTERRUPTIBLE, current))
 			break;
 		idx = sbitmap_queue_get(sbq, &cpu);
-		if (idx > 0)
+		if (idx >= 0)
 			break;
 		schedule();
 	}
-- 
2.33.0



