Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89BC37C1E3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhELPFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232710AbhELPDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:03:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEFF461920;
        Wed, 12 May 2021 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831520;
        bh=wM7W8vJqyzOkzXeBH+DSBLWG1jLPHZtb3ibpHzV+fKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUlHHOMJsfH7AH2bODvEFAI2R9qTN1ePUMl9wF3VpDI/eCPyG6QHoZcS9sAO5Hvrh
         fW/nZOKktIWfF19rFI2+X4kwFOEjcSw56M1ZLW7u3Un29pCzTVPRmlaUZercDNRk6i
         Z374UlJfI4fCVTqOjE5E80ovGPRK1Q/2vVJkFbko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 151/244] nvme-tcp: block BH in sk state_change sk callback
Date:   Wed, 12 May 2021 16:48:42 +0200
Message-Id: <20210512144747.842787249@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index ac3503ea54c4..718152adc625 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -816,7 +816,7 @@ static void nvme_tcp_state_change(struct sock *sk)
 {
 	struct nvme_tcp_queue *queue;
 
-	read_lock(&sk->sk_callback_lock);
+	read_lock_bh(&sk->sk_callback_lock);
 	queue = sk->sk_user_data;
 	if (!queue)
 		goto done;
@@ -838,7 +838,7 @@ static void nvme_tcp_state_change(struct sock *sk)
 
 	queue->state_change(sk);
 done:
-	read_unlock(&sk->sk_callback_lock);
+	read_unlock_bh(&sk->sk_callback_lock);
 }
 
 static inline void nvme_tcp_done_send_req(struct nvme_tcp_queue *queue)
-- 
2.30.2



