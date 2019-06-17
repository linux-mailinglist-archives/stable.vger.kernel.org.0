Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03348A2D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 19:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfFQRd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 13:33:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQRd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 13:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:To:From:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e0MNs+XlB5VWniwvhml+7GQwreklQeGuPL0yJFBxJHI=; b=BgB6veJd9VLkSQBhKPomDdt/v
        GqH4zPks7oCnOZXO0CiR4Oh8hocg0wMhc6pbLhAPntNqkpl+RrIaIoO+rbCxl/aaVc7Vi1vn/AAv5
        2Ko+TX9eEMqj5GrEtlO9QoSN90pQCyJKk7dJOcem301ValyWGwmfRI7QCuGsrNI3BvZfm+kvW4kB+
        JB3lewVQDKcJyZDftfBOhwbmN1ERNpvAjbW+0PdOcS+MJNlqGEDf4tv3CPvmcIOHZqJEsR2DfW+eQ
        ePCwQ2sI/z8/jaeTG1W4fuATlHoQPQUPCGAVp2Ys4VXmlWHrAj5K1lWhjMB/tqJeUnnn1CtYt8PN9
        9GMfW2PUA==;
Received: from [2600:1700:65a0:78e0:514:7862:1503:8e4d] (helo=sagi-Latitude-E7470.lbits)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcvVz-0001jN-Uw
        for stable@vger.kernel.org; Mon, 17 Jun 2019 17:33:56 +0000
From:   Sagi Grimberg <sagi@grimberg.me>
To:     stable@vger.kernel.org
Subject: [PATCH stable-5.0+ v2 2/3] nvme-tcp: fix possible null deref on a timed out io queue connect
Date:   Mon, 17 Jun 2019 10:33:51 -0700
Message-Id: <20190617173352.1902-2-sagi@grimberg.me>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617173352.1902-1-sagi@grimberg.me>
References: <20190617173352.1902-1-sagi@grimberg.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit: Fixes: f34e25898a60 ("nvme-tcp: fix possible null deref
on a timed out io queue connect")

If I/O queue connect times out, we might have freed the queue socket
already, so check for that on the error path in nvme_tcp_start_queue.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 2405bb9c63cc..2b107a1d152b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1423,7 +1423,8 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 	if (!ret) {
 		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
 	} else {
-		__nvme_tcp_stop_queue(&ctrl->queues[idx]);
+		if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
+			__nvme_tcp_stop_queue(&ctrl->queues[idx]);
 		dev_err(nctrl->device,
 			"failed to connect queue: %d ret=%d\n", idx, ret);
 	}
-- 
2.17.1

