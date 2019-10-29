Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13A9E84B2
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfJ2JvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:51:17 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:58028 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbfJ2JvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 05:51:17 -0400
X-Greylist: delayed 2250 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2019 05:51:17 EDT
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iPNZM-00048S-N4; Tue, 29 Oct 2019 09:13:40 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iPNZJ-0000q5-3w; Tue, 29 Oct 2019 09:13:38 +0000
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
To:     linux-um@lists.infradead.org
Cc:     richard@nod.at, rrs@researchut.com, axboe@kernel.dk, hch@lst.de,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Subject: [PATCH v2] um: Entrust re-queue to the upper layers
Date:   Tue, 29 Oct 2019 09:13:34 +0000
Message-Id: <20191029091334.3095-1-anton.ivanov@cambridgegreys.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes crashes due to ubd requeue logic conflicting with the block-mq
logic. Crash is reproducible in 5.0 - 5.3.

Fixes: 53766defb8c860a47e2a965f5b4b05ed2848e2d0
Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
---
 arch/um/drivers/ubd_kern.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 33c1cd6a12ac..40ab9ad7aa96 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1403,8 +1403,12 @@ static blk_status_t ubd_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	spin_unlock_irq(&ubd_dev->lock);
 
-	if (ret < 0)
-		blk_mq_requeue_request(req, true);
+	if (ret < 0) {
+		if (ret == -ENOMEM)
+			res = BLK_STS_RESOURCE;
+		else
+			res = BLK_STS_DEV_RESOURCE;
+	}
 
 	return res;
 }
-- 
2.20.1

