Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFF4441759
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhKAJfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233610AbhKAJdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6DBF61252;
        Mon,  1 Nov 2021 09:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758714;
        bh=uiPdhiCH8grdiL6+r+cIEZsH16EmT6QcgcHteYY1duw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGipAKIMvwECzitWH4F4o9vM8vpJeKtf7EAB9LeRn9LaPKgTGX6ezRvit7ihRYSIp
         DYMjOiCzAOMU+oaSHLntdJvj3zDTWwImUMyHNVUOJ7tWsWNA8vv16f6OsXU1kg9rmF
         UpsQqAvGobIspmXZU7t0oBGTyZEM45EqDg9yD26c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 27/77] nvme-tcp: fix H2CData PDU send accounting (again)
Date:   Mon,  1 Nov 2021 10:17:15 +0100
Message-Id: <20211101082517.613392908@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 25e1f67eda4a19c91dc05c84d6d413c53efb447b upstream.

We should not access request members after the last send, even to
determine if indeed it was the last data payload send. The reason is
that a completion could have arrived and trigger a new execution of the
request which overridden these members. This was fixed by commit
825619b09ad3 ("nvme-tcp: fix possible use-after-completion").

Commit e371af033c56 broke that assumption again to address cases where
multiple r2t pdus are sent per request. To fix it, we need to record the
request data_sent and data_len and after the payload network send we
reference these counters to determine weather we should advance the
request iterator.

Fixes: e371af033c56 ("nvme-tcp: fix incorrect h2cdata pdu offset accounting")
Reported-by: Keith Busch <kbusch@kernel.org>
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -910,12 +910,14 @@ static void nvme_tcp_fail_request(struct
 static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
+	int req_data_len = req->data_len;
 
 	while (true) {
 		struct page *page = nvme_tcp_req_cur_page(req);
 		size_t offset = nvme_tcp_req_cur_offset(req);
 		size_t len = nvme_tcp_req_cur_length(req);
 		bool last = nvme_tcp_pdu_last_send(req, len);
+		int req_data_sent = req->data_sent;
 		int ret, flags = MSG_DONTWAIT;
 
 		if (last && !queue->data_digest && !nvme_tcp_queue_more(queue))
@@ -942,7 +944,7 @@ static int nvme_tcp_try_send_data(struct
 		 * in the request where we don't want to modify it as we may
 		 * compete with the RX path completing the request.
 		 */
-		if (req->data_sent + ret < req->data_len)
+		if (req_data_sent + ret < req_data_len)
 			nvme_tcp_advance_req(req, ret);
 
 		/* fully successful last send in current PDU */


