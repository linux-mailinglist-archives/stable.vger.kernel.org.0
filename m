Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815F8441DA
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391987AbfFMQRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731137AbfFMIk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 716272147A;
        Thu, 13 Jun 2019 08:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415257;
        bh=2Tcx6BWg/k+OG1W2ZXwS6fr8VVdUDGUa6XHdSmUb8vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JY9wQLTxjjHOVVjkb8T41RT9/ku6xS06cbu6/1xhxxH1TnSpYlbJVTQVfQYoxZ19d
         sOwTDf2tzGWOD2I00qwYvuAOWvjeISfZLy38bblDLuKHMXFm9jTObVPr/dd0VMIeWh
         kkCOsLQnDnsmKlCdKp3YUxm9J9PP/scvtppE0Wi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/118] nvme-pci: shutdown on timeout during deletion
Date:   Thu, 13 Jun 2019 10:33:18 +0200
Message-Id: <20190613075647.341186537@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9dc1a38ef1925d23c2933c5867df816386d92ff8 ]

We do not restart a controller in a deleting state for timeout errors.
When in this state, unblock potential request dispatchers with failed
completions by shutting down the controller on timeout detection.

Reported-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 377f6fff420d..c8eeecc58115 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1132,6 +1132,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 	struct nvme_dev *dev = nvmeq->dev;
 	struct request *abort_req;
 	struct nvme_command cmd;
+	bool shutdown = false;
 	u32 csts = readl(dev->bar + NVME_REG_CSTS);
 
 	/* If PCI error recovery process is happening, we cannot reset or
@@ -1168,12 +1169,14 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 	 * shutdown, so we return BLK_EH_DONE.
 	 */
 	switch (dev->ctrl.state) {
+	case NVME_CTRL_DELETING:
+		shutdown = true;
 	case NVME_CTRL_CONNECTING:
 	case NVME_CTRL_RESETTING:
 		dev_warn_ratelimited(dev->ctrl.device,
 			 "I/O %d QID %d timeout, disable controller\n",
 			 req->tag, nvmeq->qid);
-		nvme_dev_disable(dev, false);
+		nvme_dev_disable(dev, shutdown);
 		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
 		return BLK_EH_DONE;
 	default:
-- 
2.20.1



