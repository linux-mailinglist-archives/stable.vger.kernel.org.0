Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8873A88A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387577AbfFIRBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388099AbfFIRBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:01:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECFBE206DF;
        Sun,  9 Jun 2019 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099696;
        bh=PH8GAvkw+iJdAsXGp8BOIiBkfy7m1it3hmLcSuLdv/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rgza+wsEmxbG4myMWz21aWWEAY+axMvl79P7FUm54pOKJfTMJ4ajpjXu7feZBsus3
         egyCMIs2Lrf6G79Z3+0P/g9blKcjCnopdQx5Ei8BXuaHOzqLl6PzKfbn3F7y2xnifx
         owy7PTncp+8cUcq8XNLnxLLohmASuXKZJVBJCeBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 131/241] RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure
Date:   Sun,  9 Jun 2019 18:41:13 +0200
Message-Id: <20190609164151.577557026@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
index c9cffced00ca1..54fd4d81a3f1f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -360,6 +360,8 @@ static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
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



