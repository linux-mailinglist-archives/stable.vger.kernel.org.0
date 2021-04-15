Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6BC360C42
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhDOOto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhDOOtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E050E613BB;
        Thu, 15 Apr 2021 14:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498153;
        bh=xxEN5lmT6fNYoXJc/39awdH4LWsZcGDNLtcprYrvuic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUGURnlO8XCEDUzK3rBQd6VH59ZvUdlFBBnMYOTPmWBY3sxpL/CKCC5+3zcy+9Oo1
         JgCvkn+SnLzq1VPUNQl7L5cWju4j4W5GyDxbnbG/ApxnAk+Rx0hPnPEFiaMaVM09e8
         Y34Ff/4gQ/q5ft+FlKFt8oiztP8+N/Vk+6eh+UUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/38] RDMA/cxgb4: check for ipv6 address properly while destroying listener
Date:   Thu, 15 Apr 2021 16:47:14 +0200
Message-Id: <20210415144413.990730754@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit 603c4690b01aaffe3a6c3605a429f6dac39852ae ]

ipv6 bit is wrongly set by the below which causes fatal adapter lookup
engine errors for ipv4 connections while destroying a listener.  Fix it to
properly check the local address for ipv6.

Fixes: 3408be145a5d ("RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server")
Link: https://lore.kernel.org/r/20210331135715.30072-1-bharat@chelsio.com
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8d75161854ee..f422a8a2528b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3447,7 +3447,8 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
 		c4iw_init_wr_wait(&ep->com.wr_wait);
 		err = cxgb4_remove_server(
 				ep->com.dev->rdev.lldi.ports[0], ep->stid,
-				ep->com.dev->rdev.lldi.rxq_ids[0], true);
+				ep->com.dev->rdev.lldi.rxq_ids[0],
+				ep->com.local_addr.ss_family == AF_INET6);
 		if (err)
 			goto done;
 		err = c4iw_wait_for_reply(&ep->com.dev->rdev, &ep->com.wr_wait,
-- 
2.30.2



