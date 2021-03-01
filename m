Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0978328F00
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbhCATlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:41:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241605AbhCATcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FF4F651C0;
        Mon,  1 Mar 2021 17:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619014;
        bh=RV8g4zPGhyVksuOuGdwPcWVihQ7QmaeHewtOzMzPGZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1L3454vrPvgxpPQF3bJtFBDb+eZcMMRuGwcxTpB5ZZc0LPAqY6mlpSx0vBocmSPM9
         mePMQP5cmpHomAh/HcGwBWvtev2AYgdnme70aXvMLsAFUxtobqcRgcrJjUZoQQRPjV
         4HrtjGkdDkNoS2gHBsOxosPKD/mmlznwKzpUlWDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/663] RDMA/rtrs-srv: Init wr_cnt as 1
Date:   Mon,  1 Mar 2021 17:09:01 +0100
Message-Id: <20210301161156.331476349@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 6f5d1b3016d650f351e65c645a5eee5394547dd0 ]

Fix up wr_avail accounting. if wr_cnt is 0, then we do SIGNAL for first
wr, in completion we add queue_depth back, which is not right in the
sense of tracking for available wr.

So fix it by init wr_cnt to 1.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-19-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index aac710764b44f..f3f4b640b0970 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1620,7 +1620,7 @@ static int create_con(struct rtrs_srv_sess *sess,
 	con->c.cm_id = cm_id;
 	con->c.sess = &sess->s;
 	con->c.cid = cid;
-	atomic_set(&con->wr_cnt, 0);
+	atomic_set(&con->wr_cnt, 1);
 
 	if (con->c.cid == 0) {
 		/*
-- 
2.27.0



