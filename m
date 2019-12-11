Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5235D11B00F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfLKPTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731908AbfLKPTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D24D208C3;
        Wed, 11 Dec 2019 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077543;
        bh=nMiRvwjy9pgZJOq79CVsdSrU7++n8S1+JfDq94pQgRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4e3Qli++3vyoLRf+avBmPS/FYAvg9s3e2vfkF0L92Lf7xK20d9raZg8EJQR++1kx
         rpclBu8+xX0lpM3oOA4BXmVkUmBGXh9tIY7yNxkQj0GFjn+H38pYpdJ8wm5zWtkyLl
         rkUVUXO5lIvS9QXVvOytzFyR7CEbfjXcFet5C1Gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/243] iw_cxgb4: only reconnect with MPAv1 if the peer aborts
Date:   Wed, 11 Dec 2019 16:04:01 +0100
Message-Id: <20191211150344.441786407@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

[ Upstream commit 9828ca654b52848e7eb7dcc9b0994ff130dd4546 ]

Only retry connection setup with MPAv1 if the peer actually aborted the
connection upon receiving the MPAv2 start message.  This avoids retrying
with MPAv1 in the case where the connection was aborted due to retransmit
timeouts.

Fixes: d2fe99e86bb2 ("RDMA/cxgb4: Add support for MPAv2 Enhanced RDMA Negotiation")
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a5ff1f0f2073e..4dcc92d116097 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2798,7 +2798,8 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		break;
 	case MPA_REQ_SENT:
 		(void)stop_ep_timer(ep);
-		if (mpa_rev == 1 || (mpa_rev == 2 && ep->tried_with_mpa_v1))
+		if (status != CPL_ERR_CONN_RESET || mpa_rev == 1 ||
+		    (mpa_rev == 2 && ep->tried_with_mpa_v1))
 			connect_reply_upcall(ep, -ECONNRESET);
 		else {
 			/*
-- 
2.20.1



