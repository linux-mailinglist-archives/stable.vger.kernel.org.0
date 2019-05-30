Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C771C2EE11
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731757AbfE3DU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732390AbfE3DU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2698C24986;
        Thu, 30 May 2019 03:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186457;
        bh=V5ybFUQ7mgHxpcAmowZsiBRQ2RSIJZL5rVuS2pWA+kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lT7MSW4d+s2MB1hVkb8Y21Hpkvm+1qoCImT0PA4h/mu3ZYtELNn0cFG4xHuuGj/K6
         P9DeoWI9oIqWwLZ+9XD4UHt6rrD6eKpNkNm7Fqi6Hl8jFdwx+4XFq8iN3nx0Q1StMK
         p5eUQYKGVe0W4K6VmPEw9AKUMUnbIL29Q+dpnSiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 071/128] RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure
Date:   Wed, 29 May 2019 20:06:43 -0700
Message-Id: <20190530030447.468743696@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a6d2a5a92e67d151c98886babdc86d530d27111c ]

Currently if alloc_skb fails to allocate the skb a null skb is passed to
t4_set_arp_err_handler and this ends up dereferencing the null skb.  Avoid
the NULL pointer dereference by checking for a NULL skb and returning
early.

Addresses-Coverity: ("Dereference null return")
Fixes: b38a0ad8ec11 ("RDMA/cxgb4: Set arp error handler for PASS_ACCEPT_RPL messages")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a2322b2dbd82c..e5752352e0fb1 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -455,6 +455,8 @@ static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 		skb_reset_transport_header(skb);
 	} else {
 		skb = alloc_skb(len, gfp);
+		if (!skb)
+			return NULL;
 	}
 	t4_set_arp_err_handler(skb, NULL, NULL);
 	return skb;
-- 
2.20.1



