Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510C737CCDB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbhELQse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243666AbhELQly (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A6D61E4E;
        Wed, 12 May 2021 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835535;
        bh=pQn4RtbVQC/+hQf7/S5wB5A5lZOtoQs3yJW9k/7AM0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvYwkraTieZ+Q/fAub3p2ftaU6e6hhTLvq5kH2POOgWhG6tbXyP2PJj2ASgvSdoLs
         4M7yLkgNnBk7E+VIP0uibAlv6xd8vxVjz41Jds034D+QsKPk7h2sWphMlMlQfwHxwL
         puwEe9uxPxox+UM/p/W80awumlzJ7x5Cah77rDyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 384/677] nvme-tcp: block BH in sk state_change sk callback
Date:   Wed, 12 May 2021 16:47:10 +0200
Message-Id: <20210512144850.091639032@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index a0f00cb8f9f3..d7d7c81d0701 100644
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



