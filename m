Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D928408DD7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbhIMNaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241979AbhIMN23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:28:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 558D761213;
        Mon, 13 Sep 2021 13:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539421;
        bh=AbnGdYKQC5qqiEOoKwJTjXRBceh5WyClv3tpWA0VNFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3nTwWVhU6Fy6L0rziYAFptbLgoF5haTW3P5E7e/ChQp8TEt3XpX0RQXgfnzyeBrM
         rlawJu4yz7IYRdCpDjrUyn4ItAnEe8ICd/gmFq0X/64rv9BgdEvGr74wuaI335X1fO
         2qvPmFf0hFJFWqT+mF/aJsTNty4QU/KqEE1SJpQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruozhu Li <liruozhu@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/236] nvme-tcp: dont update queue count when failing to set io queues
Date:   Mon, 13 Sep 2021 15:12:04 +0200
Message-Id: <20210913131100.981636070@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruozhu Li <liruozhu@huawei.com>

[ Upstream commit 664227fde63844d69e9ec9e90a8a7801e6ff072d ]

We update ctrl->queue_count and schedule another reconnect when io queue
count is zero.But we will never try to create any io queue in next reco-
nnection, because ctrl->queue_count already set to zero.We will end up
having an admin-only session in Live state, which is exactly what we try
to avoid in the original patch.
Update ctrl->queue_count after queue_count zero checking to fix it.

Signed-off-by: Ruozhu Li <liruozhu@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 82b2611d39a2..5b11d8a23813 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1755,13 +1755,13 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ctrl->queue_count = nr_io_queues + 1;
-	if (ctrl->queue_count < 2) {
+	if (nr_io_queues == 0) {
 		dev_err(ctrl->device,
 			"unable to set any I/O queues\n");
 		return -ENOMEM;
 	}
 
+	ctrl->queue_count = nr_io_queues + 1;
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
-- 
2.30.2



