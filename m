Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6487437C519
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhELPiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhELP3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:29:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A8976144C;
        Wed, 12 May 2021 15:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832505;
        bh=BowfIlNbND07qhj7tCfKfdEs8T/IQ6U7ydVTT94mZS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fNAOQDvmU6VFbQdmG3l9cxBLqBIO0d48Ol5WIdY2GEDXGeuUSpKITiK6lpqkfsdP
         Y/PczjzEGV3hgLAux+rXzP+5DhBZYfO3ddopdgJVUeYr6XWOs9LgfrRriU+L/g8GOM
         GbdnX4uwZU1LqBIZqGVxSSU6LxfoXCqCTjWOCXQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/530] nvme-tcp: block BH in sk state_change sk callback
Date:   Wed, 12 May 2021 16:46:58 +0200
Message-Id: <20210512144829.919424583@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 8b73b45d54a14588f86792869bfb23098ea254cb ]

The TCP stack can run from process context for a long time
so we should disable BH here.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 9444e5e2a95b..4cf81f3841ae 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -874,7 +874,7 @@ static void nvme_tcp_state_change(struct sock *sk)
 {
 	struct nvme_tcp_queue *queue;
 
-	read_lock(&sk->sk_callback_lock);
+	read_lock_bh(&sk->sk_callback_lock);
 	queue = sk->sk_user_data;
 	if (!queue)
 		goto done;
@@ -895,7 +895,7 @@ static void nvme_tcp_state_change(struct sock *sk)
 
 	queue->state_change(sk);
 done:
-	read_unlock(&sk->sk_callback_lock);
+	read_unlock_bh(&sk->sk_callback_lock);
 }
 
 static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
-- 
2.30.2



