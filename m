Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86BD3C4DB0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhGLHOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241852AbhGLHMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:12:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 751796108B;
        Mon, 12 Jul 2021 07:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073803;
        bh=lgB1aLp/U5w0sgPxn7QfTi2IakF2fw+bqWvJFuxef+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QK6Xu4svxITKMbAZmqmBR7Zj4ju6Gq/yb3Y5oaiRdvBSIMTwRaUjmwAzZ2p3zBE6W
         UrAaIYWJHl5qyQXMArxclknfVz9UdhkiM7uHaNPStolqna98TJtUSDoVosUp0PPlyh
         xEj6pj337wnzxUjiEc4a/7k3UCN0Ovg2ehpowwDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 366/700] net: qrtr: ns: Fix error return code in qrtr_ns_init()
Date:   Mon, 12 Jul 2021 08:07:29 +0200
Message-Id: <20210712061015.322950792@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit a49e72b3bda73d36664a084e47da9727a31b8095 ]

Fix to return a negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: c6e08d6251f3 ("net: qrtr: Allocate workqueue before kernel_bind")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 8d00dfe8139e..1990d496fcfc 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -775,8 +775,10 @@ int qrtr_ns_init(void)
 	}
 
 	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
-	if (!qrtr_ns.workqueue)
+	if (!qrtr_ns.workqueue) {
+		ret = -ENOMEM;
 		goto err_sock;
+	}
 
 	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
 
-- 
2.30.2



