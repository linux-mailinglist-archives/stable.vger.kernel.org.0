Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320964173C7
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344488AbhIXM7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345584AbhIXM6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F73B613AC;
        Fri, 24 Sep 2021 12:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487961;
        bh=eRwTP9+CfOkFr1m7yfu12YeSXoLiGgtFZ0l1brQ+nso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMp/bf/Epc04reqaM5TUgxWu3IDd88Me8KhRQxC9b62FphPWugL0bDaO3jK7w2KTu
         13ZPAk9PuZltBYE5jIQq7f1NCwnymXxmQCMm8H8BwgPGmE/nqmMLdRmyTIY04gPCE6
         a3ipe8tygz+GE9FfV+9EMTMKVDOpYqLcIWeOYKJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 029/100] dmaengine: idxd: fix wq slot allocation index check
Date:   Fri, 24 Sep 2021 14:43:38 +0200
Message-Id: <20210924124342.430077478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
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
index 36c9c1a89b7e..196d6cf11965 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -67,7 +67,7 @@ struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq, enum idxd_op_type optype)
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



