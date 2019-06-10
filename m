Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1423AE5F
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 06:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387553AbfFJE63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 00:58:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387464AbfFJE63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 00:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:To:From:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pEBfxGTBu2IbZajj+LuaI88i7oYipuXqLbKHV/UmREE=; b=cGdQHFFH5atTRtfdipXv/lzri
        +1hbKTXI/WD5EX0zhQJAJenaZ1L0ML/0JPXnOVzbGb0KQsLTqWy7Be8Gl0Tbd5l9cUwT4Ku3ZEVHn
        ICtgqfIRj4dRKGcr0bG+Ye5Q5g4i9zTmQMU4zT2A+pN5o1C/73lgVW54uUFHBXNffRnw34B/zLcBj
        5mp5HRb9y42ZkFcgjKm88DJ2GS5ZtBiuMWzprzrXRk1JBW8N6TYCjfI6jg1wOkFs1dKNw4B2l1t4A
        CiJTUaI8AotQUWFuzNsUcgfgFsgA3Qt3JtpadT1idHapp8e5KmoLP/kPNw0VbhMbxGxrX5urh6/pE
        fzhb9W/SQ==;
Received: from [2601:647:4800:973f:619c:52d9:37be:b7bd] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haCO4-0000I0-LB
        for stable@vger.kernel.org; Mon, 10 Jun 2019 04:58:28 +0000
From:   Sagi Grimberg <sagi@grimberg.me>
To:     stable@vger.kernel.org
Subject: [PATCH stable-5.0+ 2/3] nvme-tcp: fix possible null deref on a timed out io queue connect
Date:   Sun,  9 Jun 2019 21:58:25 -0700
Message-Id: <20190610045826.13176-2-sagi@grimberg.me>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610045826.13176-1-sagi@grimberg.me>
References: <20190610045826.13176-1-sagi@grimberg.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit: Fixes: d10325e5a9ca ("nvme-tcp: fix possible null deref
on a timed out io queue connect"

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

