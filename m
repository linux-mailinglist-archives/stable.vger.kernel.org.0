Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133C538EEC6
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhEXPzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234585AbhEXPwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:52:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CFC61622;
        Mon, 24 May 2021 15:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870747;
        bh=F5+Y0KYYN8GX/sZgkCchlexqW7ylrqjZ/vqpeMbnaDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXmrI9iYF332ZsoDdl9si633u9fC1wLn+bakwja763voKUwK7tLLiK6VXUsWideG6
         wE/R4G+WI4OjSMzzdr88XtCPDEwqOO4DU8v5xsVodLK3mObQn4cPLePZEWHfpEjxzr
         l3A4mh9bP9Bxesl4s6tPMHwyI6rW1K5+JjXiVDfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/104] nvme-tcp: rerun io_work if req_list is not empty
Date:   Mon, 24 May 2021 17:25:11 +0200
Message-Id: <20210524152333.366112978@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
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
index 4cf81f3841ae..7346a05d395b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1140,7 +1140,8 @@ static void nvme_tcp_io_work(struct work_struct *w)
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



