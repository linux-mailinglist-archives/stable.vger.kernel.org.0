Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C02F0D6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbfE3DRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731048AbfE3DRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB8E024667;
        Thu, 30 May 2019 03:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186241;
        bh=92NwOkLdCNElYHc/apYpiDEjEst7XO5x6J6XMfxCnZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQ4xv4kft3g3Qveatj7fByUQuUWT9pEgavUoBIjrjGcVb20GK1+U9QZdHig5KQ6V8
         F1SsfIWwES4kAMf1b1xfbELBb6dDYMhFIp2NjpacyUSz1+ajYMsiV/pXOGLfySHjhv
         Rsbn/hQDOt2jeYrl4xK0edujNNv4bogVeTQr6prU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/276] RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure
Date:   Wed, 29 May 2019 20:05:11 -0700
Message-Id: <20190530030535.131550653@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index a68569ec86bf9..3be6405d9855e 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -458,6 +458,8 @@ static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
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



