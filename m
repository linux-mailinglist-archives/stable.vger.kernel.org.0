Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0219323A613
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgHCM2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728694AbgHCM2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84197207DF;
        Mon,  3 Aug 2020 12:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457688;
        bh=ZebsgRlP8hn5P1mHLwhnSzCiMqdPoQ97ZpjFWDWGEwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpBjlJmHWK+JMYLQp+lmHEmOY3TcbfUWs6k3q7mKXao7/nhqUNtnYJRXpq7Mzemcp
         q+POqLUm3veBqxy1UHmM7cCqosqppGRbJ81HKV6S9QHJCVWzrUr+MXZtoSN5Neen0Y
         r7wvsjOWDnmkXQ7KHg76NaxqLzLhZ3OzJYw6WhpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/90] nvme-tcp: fix possible hang waiting for icresp response
Date:   Mon,  3 Aug 2020 14:19:01 +0200
Message-Id: <20200803121859.509164023@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit adc99fd378398f4c58798a1c57889872967d56a6 ]

If the controller died exactly when we are receiving icresp
we hang because icresp may never return. Make sure to set a
high finite limit.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 7900814355c28..53e113a18a549 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1319,6 +1319,9 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 		}
 	}
 
+	/* Set 10 seconds timeout for icresp recvmsg */
+	queue->sock->sk->sk_rcvtimeo = 10 * HZ;
+
 	queue->sock->sk->sk_allocation = GFP_ATOMIC;
 	if (!qid)
 		n = 0;
-- 
2.25.1



