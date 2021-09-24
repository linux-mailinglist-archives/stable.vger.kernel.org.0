Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7B4173D7
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbhIXNAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345658AbhIXM6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD876613CE;
        Fri, 24 Sep 2021 12:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487969;
        bh=LHv4t25BtC8Hg2SbNsM2UH7UqJaChNUnXkEzrH6BM4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ep86/tI8WNTRH66P4hX+TSibXwLGHx0Arfa+ktRZw153JFQnYig+Vy0XMxtPDnZxi
         ZC7l463ga3dDTJ16/5jo/9DtHJlD/M/esR9cgcznJZl7P+ZhkAwrlnNxMcunAB5eQ1
         qxmS+BZ6XXgEK5kR3gQrqMQFMenLReiKWpS2lFs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 031/100] dmaengine: idxd: clear block on fault flag when clear wq
Date:   Fri, 24 Sep 2021 14:43:40 +0200
Message-Id: <20210924124342.496899043@linuxfoundation.org>
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

[ Upstream commit bd2f4ae5e019efcfadd6b491204fd60adf14f4a3 ]

The block on fault flag is not cleared when we disable or reset wq. This
causes it to remain set if the user does not clear it on the next
configuration load. Add clear of flag in dxd_wq_disable_cleanup()
routine.

Fixes: da32b28c95a7 ("dmaengine: idxd: cleanup workqueue config after disabling")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162803023553.3086015.8158952172068868803.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index c8cf1de72176..9c6760ae5aef 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -401,6 +401,7 @@ static void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	wq->priority = 0;
 	wq->ats_dis = 0;
 	clear_bit(WQ_FLAG_DEDICATED, &wq->flags);
+	clear_bit(WQ_FLAG_BLOCK_ON_FAULT, &wq->flags);
 	memset(wq->name, 0, WQ_NAME_SIZE);
 }
 
-- 
2.33.0



