Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E895B70B9
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiIMOZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiIMOYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAE3136;
        Tue, 13 Sep 2022 07:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD1E9614C9;
        Tue, 13 Sep 2022 14:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45A4C433C1;
        Tue, 13 Sep 2022 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078494;
        bh=RTsgS/dWZ26ksw0pvX8+Z5l1Fr6rjNYtwTNY720+CgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p34PB7IVmNxI4/cDQ+vGP9NxKFBlyRzV9MkC4D8ulPtj/mP2ElQLHYqXwSXwr/pGx
         W6mOUD+I8Akmndfq9NiN6djc4tyTno7dsenu37xQeTt45YtspyLCOsYmYcB3DVcDpW
         JDJH9LUcycIOsUrCJ/ig3g1mOiH6IvL8xNmWtIoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Nicklin <jnicklin@blockbridge.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 136/192] nvme-tcp: fix regression that causes sporadic requests to time out
Date:   Tue, 13 Sep 2022 16:04:02 +0200
Message-Id: <20220913140416.790157493@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 3770a42bb8ceb856877699257a43c0585a5d2996 ]

When we queue requests, we strive to batch as much as possible and also
signal the network stack that more data is about to be sent over a socket
with MSG_SENDPAGE_NOTLAST. This flag looks at the pending requests queued
as well as queue->more_requests that is derived from the block layer
last-in-batch indication.

We set more_request=true when we flush the request directly from
.queue_rq submission context (in nvme_tcp_send_all), however this is
wrongly assuming that no other requests may be queued during the
execution of nvme_tcp_send_all.

Due to this, a race condition may happen where:

 1. request X is queued as !last-in-batch
 2. request X submission context calls nvme_tcp_send_all directly
 3. nvme_tcp_send_all is preempted and schedules to a different cpu
 4. request Y is queued as last-in-batch
 5. nvme_tcp_send_all context sends request X+Y, however signals for
    both MSG_SENDPAGE_NOTLAST because queue->more_requests=true.

==> none of the requests is pushed down to the wire as the network
stack is waiting for more data, both requests timeout.

To fix this, we eliminate queue->more_requests and only rely on
the queue req_list and send_list to be not-empty.

Fixes: 122e5b9f3d37 ("nvme-tcp: optimize network stack with setting msg flags according to batch size")
Reported-by: Jonathan Nicklin <jnicklin@blockbridge.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Jonathan Nicklin <jnicklin@blockbridge.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 40bd68ba1040a..daa0e160e1212 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -121,7 +121,6 @@ struct nvme_tcp_queue {
 	struct mutex		send_mutex;
 	struct llist_head	req_list;
 	struct list_head	send_list;
-	bool			more_requests;
 
 	/* recv state */
 	void			*pdu;
@@ -318,7 +317,7 @@ static inline void nvme_tcp_send_all(struct nvme_tcp_queue *queue)
 static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
 {
 	return !list_empty(&queue->send_list) ||
-		!llist_empty(&queue->req_list) || queue->more_requests;
+		!llist_empty(&queue->req_list);
 }
 
 static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
@@ -337,9 +336,7 @@ static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 	 */
 	if (queue->io_cpu == raw_smp_processor_id() &&
 	    sync && empty && mutex_trylock(&queue->send_mutex)) {
-		queue->more_requests = !last;
 		nvme_tcp_send_all(queue);
-		queue->more_requests = false;
 		mutex_unlock(&queue->send_mutex);
 	}
 
-- 
2.35.1



