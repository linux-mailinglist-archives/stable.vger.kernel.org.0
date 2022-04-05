Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8404F37A6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359415AbiDELSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349123AbiDEJtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698B5AA033;
        Tue,  5 Apr 2022 02:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 240BCB81B7F;
        Tue,  5 Apr 2022 09:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824DAC385A2;
        Tue,  5 Apr 2022 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151664;
        bh=30UmqNFwoai9wgFjVcF4BvLOQMim/OFKlunka15uq0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOGHZfgwIzRsYpnx9LOMeSdUdMs3cF5z5QgxTRx0HzhbmqqxvexC1ZkP6LfAQMNva
         Y4AtC+X1q87d85AShPJ1M8ymJOliK9yiIW5TAoQdZef59Pq80StJlQ6zZdvuYuVpU0
         pSBHSBZTRMhaPNFmj+kz53TVx/kzo4VC6+TrSM0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Avneesh Pant <avneesh.pant@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 459/913] IB/cma: Allow XRC INI QPs to set their local ACK timeout
Date:   Tue,  5 Apr 2022 09:25:21 +0200
Message-Id: <20220405070353.607388366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 748663c8ccf6b2e5a800de19127c2cc1c4423fd2 ]

XRC INI QPs should be able to adjust their local ACK timeout.

Fixes: 2c1619edef61 ("IB/cma: Define option to set ack timeout and pack tos_set")
Link: https://lore.kernel.org/r/1644421175-31943-1-git-send-email-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Suggested-by: Avneesh Pant <avneesh.pant@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index db7b5de3bc76..a814dabcdff4 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2640,7 +2640,7 @@ int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout)
 {
 	struct rdma_id_private *id_priv;
 
-	if (id->qp_type != IB_QPT_RC)
+	if (id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_INI)
 		return -EINVAL;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-- 
2.34.1



