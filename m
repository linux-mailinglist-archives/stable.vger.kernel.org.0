Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C3B621A7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbfGHPSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbfGHPSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F97221537;
        Mon,  8 Jul 2019 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599088;
        bh=Bw4rCkcWV7YQElstxkPBsPUJaLfwFXLBLmUmxql+ido=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUPT6LAGI0DRF11TRJzc1/Djs5ogR8lRiXOtBiQBPxU2peciIoyw8gowr4uJXSSfA
         O8CT6Zw9QrkjelaySqV/nF9pjRoA3BUz6TrmYZPzj9ellgWDGGQjKqctK9P2NnFAS9
         YVHmx5Syugwfawi06V7FNV+wGZVTM8AIy8wuIlE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 31/73] 9p/rdma: do not disconnect on down_interruptible EAGAIN
Date:   Mon,  8 Jul 2019 17:12:41 +0200
Message-Id: <20190708150522.837472615@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8b894adb2b7e1d1e64b8954569c761eaf3d51ab5 ]

9p/rdma would sometimes drop the connection and display errors in
recv_done when the user does ^C.
The errors were caused by recv buffers that were posted at the time
of disconnect, and we just do not want to disconnect when
down_interruptible is... interrupted.

Link: http://lkml.kernel.org/r/1535625307-18019-1-git-send-email-asmadeus@codewreck.org
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index f42550dd3560..f3a9254b6df9 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -476,7 +476,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	err = post_recv(client, rpl_context);
 	if (err) {
-		p9_debug(P9_DEBUG_FCALL, "POST RECV failed\n");
+		p9_debug(P9_DEBUG_ERROR, "POST RECV failed: %d\n", err);
 		goto recv_error;
 	}
 	/* remove posted receive buffer from request structure */
@@ -544,7 +544,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
  recv_error:
 	kfree(rpl_context);
 	spin_lock_irqsave(&rdma->req_lock, flags);
-	if (rdma->state < P9_RDMA_CLOSING) {
+	if (err != -EINTR && rdma->state < P9_RDMA_CLOSING) {
 		rdma->state = P9_RDMA_CLOSING;
 		spin_unlock_irqrestore(&rdma->req_lock, flags);
 		rdma_disconnect(rdma->cm_id);
-- 
2.20.1



