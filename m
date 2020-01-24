Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDB2147C1C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgAXJtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:49:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbgAXJtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:49:15 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B26206D5;
        Fri, 24 Jan 2020 09:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859355;
        bh=de6GOiqLAJaWWG2EvgMbPEP2AjO6yvDcHgRQ+i6nb18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcGfN5TyxiiC94Mq7g4NYGy13GQF1z1+ebyuosdFyoZ4pDSh1D65FmfstDMypfC9W
         LQWRaRQsKNWC6QIN3GF5vn2aekAdJjKuVqtYXbif/WMz6sj89+dXfvbvctUSYYiKQF
         T18ui/9c/ZIGuHLf3G0RCmWB1f2KvjwE01cEoNE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/343] iw_cxgb4: use tos when finding ipv6 routes
Date:   Fri, 24 Jan 2020 10:28:36 +0100
Message-Id: <20200124092932.952839916@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

[ Upstream commit c8a7eb554a83214c3d8ee5cb322da8c72810d2dc ]

When IPv6 support was added, the correct tos was not passed to
cxgb_find_route6(). This potentially results in the wrong route entry.

Fixes: 830662f6f032 ("RDMA/cxgb4: Add support for active and passive open connection with IPv6 address")
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 942403e42dd0f..7eb1cc1b1aa04 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2147,7 +2147,8 @@ static int c4iw_reconnect(struct c4iw_ep *ep)
 					   laddr6->sin6_addr.s6_addr,
 					   raddr6->sin6_addr.s6_addr,
 					   laddr6->sin6_port,
-					   raddr6->sin6_port, 0,
+					   raddr6->sin6_port,
+					   ep->com.cm_id->tos,
 					   raddr6->sin6_scope_id);
 		iptype = 6;
 		ra = (__u8 *)&raddr6->sin6_addr;
@@ -3298,7 +3299,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 					   laddr6->sin6_addr.s6_addr,
 					   raddr6->sin6_addr.s6_addr,
 					   laddr6->sin6_port,
-					   raddr6->sin6_port, 0,
+					   raddr6->sin6_port, cm_id->tos,
 					   raddr6->sin6_scope_id);
 	}
 	if (!ep->dst) {
-- 
2.20.1



