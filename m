Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4906E62CB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbjDRMf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjDRMfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569F2125BC
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9BEC629EA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A513C433EF;
        Tue, 18 Apr 2023 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821322;
        bh=P7ZuACcIa2HspGuV6cg3lJz4794sq1Wj+a1QOGAQrN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK5IpRL03NcdR5JxUIEwk69BavLgjZIkKdryQSfzwMFdRKR8i216Vq1I4kwqFavPw
         H/Ej/6xBjmsucpLOA1JdBMjdOfRonxn1+Qu4MeezptpJAFiOugtpvXJodcW/dGOQ3f
         R2tUxF5RkTSvzQdoDjz6Exa0xVKYTmaYckgyRka0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/124] RDMA/core: Fix GID entry ref leak when create_ah fails
Date:   Tue, 18 Apr 2023 14:21:41 +0200
Message-Id: <20230418120312.848506462@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit aca3b0fa3d04b40c96934d86cc224cccfa7ea8e0 ]

If AH create request fails, release sgid_attr to avoid GID entry
referrence leak reported while releasing GID table

Fixes: 1a1f460ff151 ("RDMA: Hold the sgid_attr inside the struct ib_ah/qp")
Link: https://lore.kernel.org/r/20230401063424.342204-1-saravanan.vajravel@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5123be0ab02f5..4fcabe5a84bee 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -535,6 +535,8 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 
 	ret = device->ops.create_ah(ah, &init_attr, udata);
 	if (ret) {
+		if (ah->sgid_attr)
+			rdma_put_gid_attr(ah->sgid_attr);
 		kfree(ah);
 		return ERR_PTR(ret);
 	}
-- 
2.39.2



