Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A603AE5D
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 06:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbfFJE63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 00:58:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387452AbfFJE63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 00:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Message-Id:Date:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oLtHpHblnCuEnJo47mu80dY5Cp9ZyPWNtrRU3921CdU=; b=n1WMy0V3D2NKpO4zoAqW91WrE
        aHKNBl2kKaGixALVDpN0+TmdPW0OC2tmnLl7K+e09pyVXcSi/7LCmPXx2PzgbNyXht+tvqHud89as
        eg/Q4pKAehs6nAUiysMwRp7wz1DSqLBn9thQCM6yrNYVw9G48EuIwFFrfZW2OYlzk88CuZ4mEUVPE
        NgOUcyGIOwMHGL5VATj57QYztZiSEPHR/YlmOGrfgKF7gYiF5EBthGz8bX3W/Jx/HEYjVKa3s7f4o
        2cEbrXZRr0kXUlbvjv2+4BVpywGeY9ywuciebE0BCsfs66lmxQvBXq7H7v7i5N5BFd0W09XNcL23P
        o75g+O04g==;
Received: from [2601:647:4800:973f:619c:52d9:37be:b7bd] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haCO4-0000I0-IM
        for stable@vger.kernel.org; Mon, 10 Jun 2019 04:58:28 +0000
From:   Sagi Grimberg <sagi@grimberg.me>
To:     stable@vger.kernel.org
Subject: [PATCH stable-5.0+ 1/3] nvme-tcp: rename function to have nvme_tcp prefix
Date:   Sun,  9 Jun 2019 21:58:24 -0700
Message-Id: <20190610045826.13176-1-sagi@grimberg.me>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit: 7e6e5ffa7ed2 ("nvme-tcp: rename function to have nvme_tcp prefix")

usually nvme_ prefix is for core functions.
While we're cleaning up, remove redundant empty lines

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Minwoo Im <minwoo.im@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/tcp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index aae5374d2b93..2405bb9c63cc 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -473,7 +473,6 @@ static int nvme_tcp_handle_c2h_data(struct nvme_tcp_queue *queue,
 	}
 
 	return 0;
-
 }
 
 static int nvme_tcp_handle_comp(struct nvme_tcp_queue *queue,
@@ -634,7 +633,6 @@ static inline void nvme_tcp_end_request(struct request *rq, u16 status)
 	nvme_end_request(rq, cpu_to_le16(status << 1), res);
 }
 
-
 static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 			      unsigned int *offset, size_t *len)
 {
@@ -1535,7 +1533,7 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
 	return ret;
 }
 
-static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
+static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	int i, ret;
 
@@ -1565,7 +1563,7 @@ static unsigned int nvme_tcp_nr_io_queues(struct nvme_ctrl *ctrl)
 	return nr_io_queues;
 }
 
-static int nvme_alloc_io_queues(struct nvme_ctrl *ctrl)
+static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	unsigned int nr_io_queues;
 	int ret;
@@ -1582,7 +1580,7 @@ static int nvme_alloc_io_queues(struct nvme_ctrl *ctrl)
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
-	return nvme_tcp_alloc_io_queues(ctrl);
+	return __nvme_tcp_alloc_io_queues(ctrl);
 }
 
 static void nvme_tcp_destroy_io_queues(struct nvme_ctrl *ctrl, bool remove)
@@ -1599,7 +1597,7 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 {
 	int ret;
 
-	ret = nvme_alloc_io_queues(ctrl);
+	ret = nvme_tcp_alloc_io_queues(ctrl);
 	if (ret)
 		return ret;
 
-- 
2.17.1

