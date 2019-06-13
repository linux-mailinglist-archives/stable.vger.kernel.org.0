Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EB244024
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391057AbfFMQDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731382AbfFMIrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F9A206BA;
        Thu, 13 Jun 2019 08:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415643;
        bh=LC8O5udZCLaZ8jZmYSRFYyGAk/b9k69zvK5jhojZ45M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buU4YLTSt5zhyrfPOigYjvq4cRy9jWVYUoktXlHP5ptStykvBShpzNyHMAjMnkxNU
         3/8K9dy6zfkZfavbRFdYoPW/BlEoUBY66nSNCV22Hp1uaLgvOgXTSzR+4e9uz+DaY0
         2a+Yagf7TBSe0ClsuMPulcvoHuoPGQi9XZBoROps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 075/155] nvme-pci: unquiesce admin queue on shutdown
Date:   Thu, 13 Jun 2019 10:33:07 +0200
Message-Id: <20190613075657.179216321@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c8e9e9b7646ebe1c5066ddc420d7630876277eb4 ]

Just like IO queues, the admin queue also will not be restarted after a
controller shutdown. Unquiesce this queue so that we do not block
request dispatch on a permanently disabled controller.

Reported-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a90cf5d63aac..e5dcc769ab8f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2438,8 +2438,11 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 	 * must flush all entered requests to their failed completion to avoid
 	 * deadlocking blk-mq hot-cpu notifier.
 	 */
-	if (shutdown)
+	if (shutdown) {
 		nvme_start_queues(&dev->ctrl);
+		if (dev->ctrl.admin_q && !blk_queue_dying(dev->ctrl.admin_q))
+			blk_mq_unquiesce_queue(dev->ctrl.admin_q);
+	}
 	mutex_unlock(&dev->shutdown_lock);
 }
 
-- 
2.20.1



