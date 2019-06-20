Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6564D740
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfFTSRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729671AbfFTSRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:17:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7221C205F4;
        Thu, 20 Jun 2019 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054628;
        bh=mK45/Xbhgfwdi2FZYz42Tj69FVZGZYKwaWYPZwqd6P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjbysLiuYbtNIYXVciAv1atfSA+D1MxMEX22PO/8iB3L5TO9ZbC78zfWYl+RYZ2Mu
         T0HT1uH+f3Ak3WA/dq/h1drsIeuZh/zbe2Z5b6d58fVuyeU1DA7UWNpQLBtIxcaf6T
         Sle76NbsKoy7a2wRFnHAHujOzDarUSgoVZ6XMWMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Minwoo Im <minwoo.im@samsung.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.1 95/98] nvme-tcp: rename function to have nvme_tcp prefix
Date:   Thu, 20 Jun 2019 19:58:02 +0200
Message-Id: <20190620174354.182824738@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit efb973b19b88642bb7e08b8ce8e03b0bbd2a7e2a upstream.

usually nvme_ prefix is for core functions.
While we're cleaning up, remove redundant empty lines

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Minwoo Im <minwoo.im@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/tcp.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -473,7 +473,6 @@ static int nvme_tcp_handle_c2h_data(stru
 	}
 
 	return 0;
-
 }
 
 static int nvme_tcp_handle_comp(struct nvme_tcp_queue *queue,
@@ -634,7 +633,6 @@ static inline void nvme_tcp_end_request(
 	nvme_end_request(rq, cpu_to_le16(status << 1), res);
 }
 
-
 static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 			      unsigned int *offset, size_t *len)
 {
@@ -1535,7 +1533,7 @@ out_free_queue:
 	return ret;
 }
 
-static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
+static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	int i, ret;
 
@@ -1565,7 +1563,7 @@ static unsigned int nvme_tcp_nr_io_queue
 	return nr_io_queues;
 }
 
-static int nvme_alloc_io_queues(struct nvme_ctrl *ctrl)
+static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	unsigned int nr_io_queues;
 	int ret;
@@ -1582,7 +1580,7 @@ static int nvme_alloc_io_queues(struct n
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
-	return nvme_tcp_alloc_io_queues(ctrl);
+	return __nvme_tcp_alloc_io_queues(ctrl);
 }
 
 static void nvme_tcp_destroy_io_queues(struct nvme_ctrl *ctrl, bool remove)
@@ -1599,7 +1597,7 @@ static int nvme_tcp_configure_io_queues(
 {
 	int ret;
 
-	ret = nvme_alloc_io_queues(ctrl);
+	ret = nvme_tcp_alloc_io_queues(ctrl);
 	if (ret)
 		return ret;
 


