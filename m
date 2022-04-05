Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274A94F2D82
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbiDEJhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbiDEJCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA2613D1D;
        Tue,  5 Apr 2022 01:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B971CB81B92;
        Tue,  5 Apr 2022 08:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CED3C385A0;
        Tue,  5 Apr 2022 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148854;
        bh=ABlTf+N6DH9ccUXpUU8Fl2Nw2NUrzJf1hK0bocX+03s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Assyde6JZhc49T7GdI8ZtDE7cAt0fJcfGf/VMhWbDx4MXtI06nbvOwcRsFaWDyMtg
         VS9MthIIj2BuK3GonxEXadZvSYYgNgE3Yskf+SSwVTe7dLBZVcHOnfqfJcPvksvDLX
         0f8CdxhignlFmtnRfjP/vobSdhnBrhhVoqMvdlwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Avneesh Pant <avneesh.pant@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0504/1017] IB/cma: Allow XRC INI QPs to set their local ACK timeout
Date:   Tue,  5 Apr 2022 09:23:37 +0200
Message-Id: <20220405070409.259809614@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 41ec05c4b0d0..80a8e31e5b38 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2642,7 +2642,7 @@ int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout)
 {
 	struct rdma_id_private *id_priv;
 
-	if (id->qp_type != IB_QPT_RC)
+	if (id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_INI)
 		return -EINVAL;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-- 
2.34.1



