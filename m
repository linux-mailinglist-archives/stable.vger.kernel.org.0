Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1433238EF7C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhEXP56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235423AbhEXP4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8AC061209;
        Mon, 24 May 2021 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870981;
        bh=UFlC+LfaNg5QCjGzHQJXyOwrWTkb6L1wA1OyiI1Ofv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOI8eO57kAimySRnYte07bfLxqyl5yz3vD/SjUOPTmJ+BrUEZqayoQtL3l3f1A4Rc
         Ls1Hbhe2qn+77fO8SFcvoE8tuUofPchAY2r1o1vMyHx9p80U/0a9AeQn+0v4yqUMFD
         d8fA9mIasStTLgx3ziakfU/xSUCW7Rc9yV5T2rqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 019/127] nvme-tcp: rerun io_work if req_list is not empty
Date:   Mon, 24 May 2021 17:25:36 +0200
Message-Id: <20210524152335.509055269@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a0fdd1418007f83565d3f2e04b47923ba93a9b8c ]

A possible race condition exists where the request to send data is
enqueued from nvme_tcp_handle_r2t()'s will not be observed by
nvme_tcp_send_all() if it happens to be running. The driver relies on
io_work to send the enqueued request when it is runs again, but the
concurrently running nvme_tcp_send_all() may not have released the
send_mutex at that time. If no future commands are enqueued to re-kick
the io_work, the request will timeout in the SEND_H2C state, resulting
in a timeout error like:

  nvme nvme0: queue 1: timeout request 0x3 type 6

Ensure the io_work continues to run as long as the req_list is not empty.

Fixes: db5ad6b7f8cdd ("nvme-tcp: try to send request in queue_rq context")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d7d7c81d0701..f8ef1faaf5e4 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1137,7 +1137,8 @@ static void nvme_tcp_io_work(struct work_struct *w)
 				pending = true;
 			else if (unlikely(result < 0))
 				break;
-		}
+		} else
+			pending = !llist_empty(&queue->req_list);
 
 		result = nvme_tcp_try_recv(queue);
 		if (result > 0)
-- 
2.30.2



