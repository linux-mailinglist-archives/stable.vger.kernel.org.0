Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109A43ED597
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbhHPNMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236662AbhHPNKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D62C26108D;
        Mon, 16 Aug 2021 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119390;
        bh=/3aOrcSRj79GJM70NNcPVKcjGt9YpxUdGhrIU2TcTnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Il/iTSojFLQTQQbazxDK2zJAiuhKtfNfU1WcQYfHM6hKRgWBP69gAi5DkxAXwznqH
         A0pQ46WrDLSq6UrH3xd7ka/XlQEJFZr6bcJ+ETsOlKtvzuGONAfC6eM9hRKxgIi/iT
         OO6y403E4co5W045NI2VEHA01cigEmyIGgpcKtDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiang Yadong <jiangyadong@bytedance.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 67/96] nbd: Aovid double completion of a request
Date:   Mon, 16 Aug 2021 15:02:17 +0200
Message-Id: <20210816125437.199006485@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit cddce01160582a5f52ada3da9626c052d852ec42 ]

There is a race between iterating over requests in
nbd_clear_que() and completing requests in recv_work(),
which can lead to double completion of a request.

To fix it, flush the recv worker before iterating over
the requests and don't abort the completed request
while iterating.

Fixes: 96d97e17828f ("nbd: clear_sock on netlink disconnect")
Reported-by: Jiang Yadong <jiangyadong@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20210813151330.96-1-xieyongji@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 9a70eab7edbf..59c452fff835 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -812,6 +812,10 @@ static bool nbd_clear_req(struct request *req, void *data, bool reserved)
 {
 	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(req);
 
+	/* don't abort one completed request */
+	if (blk_mq_request_completed(req))
+		return true;
+
 	mutex_lock(&cmd->lock);
 	cmd->status = BLK_STS_IOERR;
 	mutex_unlock(&cmd->lock);
@@ -2024,15 +2028,19 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 {
 	mutex_lock(&nbd->config_lock);
 	nbd_disconnect(nbd);
-	nbd_clear_sock(nbd);
-	mutex_unlock(&nbd->config_lock);
+	sock_shutdown(nbd);
 	/*
 	 * Make sure recv thread has finished, so it does not drop the last
 	 * config ref and try to destroy the workqueue from inside the work
-	 * queue.
+	 * queue. And this also ensure that we can safely call nbd_clear_que()
+	 * to cancel the inflight I/Os.
 	 */
 	if (nbd->recv_workq)
 		flush_workqueue(nbd->recv_workq);
+	nbd_clear_que(nbd);
+	nbd->task_setup = NULL;
+	mutex_unlock(&nbd->config_lock);
+
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
 			       &nbd->config->runtime_flags))
 		nbd_config_put(nbd);
-- 
2.30.2



