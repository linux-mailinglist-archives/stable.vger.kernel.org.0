Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07EC4F445C
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380483AbiDEMNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358066AbiDEK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB9B37BC7;
        Tue,  5 Apr 2022 03:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7671661562;
        Tue,  5 Apr 2022 10:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87449C385A1;
        Tue,  5 Apr 2022 10:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153656;
        bh=4+SY162WN04MNbANkR6cbdC7zaRPcARggpU/2SxLkDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN0KHLa154BCvQkSXFIbhMKk0Gxl3fdJfm7L0t6MazaRHF8s8cdkl4KjAzBwheKvp
         qk371v0EY+4cY87Zqn2wueSnCwbZW68aZvgMrkc5bn2A+tMtdwnSnxXZCL7C/fP/B1
         NMMDlDU8uv59w7mfP/ssrkvOyMSVw451UAbQz+n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Avneesh Pant <avneesh.pant@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 301/599] IB/cma: Allow XRC INI QPs to set their local ACK timeout
Date:   Tue,  5 Apr 2022 09:29:55 +0200
Message-Id: <20220405070307.791000825@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index fbb0efbe25f8..3c40aa50cd60 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2635,7 +2635,7 @@ int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout)
 {
 	struct rdma_id_private *id_priv;
 
-	if (id->qp_type != IB_QPT_RC)
+	if (id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_INI)
 		return -EINVAL;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-- 
2.34.1



