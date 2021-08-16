Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328673ED4BD
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhHPNFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236927AbhHPNFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9478F63290;
        Mon, 16 Aug 2021 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119072;
        bh=5wZ6rwtvq3DuYxsbG8bxgohiG7P9IpTzLPLxnfj57So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKLSI8tEql6n//IJ03XdKNr0o2mQ9+cp+EPDL+/PabUPf8Is0fhi++FYfhbqTdZ2e
         jaFKkrakF3D6ek+T52DzpttvySVct+HgRUDuYBJVDaTQ0o392yjwA+u1O4dWuhigX2
         fhYbLq4ljW0rCYjS+sIrJnkS4x07HBwCR9+6ctFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiang Yadong <jiangyadong@bytedance.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/62] nbd: Aovid double completion of a request
Date:   Mon, 16 Aug 2021 15:02:12 +0200
Message-Id: <20210816125429.568841964@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
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
index 839364371f9a..25e81b1a59a5 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -797,6 +797,10 @@ static bool nbd_clear_req(struct request *req, void *data, bool reserved)
 {
 	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(req);
 
+	/* don't abort one completed request */
+	if (blk_mq_request_completed(req))
+		return true;
+
 	mutex_lock(&cmd->lock);
 	cmd->status = BLK_STS_IOERR;
 	mutex_unlock(&cmd->lock);
@@ -2009,15 +2013,19 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
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



