Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD6C6E63E4
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjDRMoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjDRMoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55F415625
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33B24630E5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4221AC433EF;
        Tue, 18 Apr 2023 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821849;
        bh=RMeRXrSJRI8PF8BNwa2iWA7Pbx/glA+7XOCtG4ajn+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2F7NNwcdrsjKZEkRd+WxRunalAAGCGWNot91wsIaOr8o7wIAQrwaQhXwsgvTpk0J
         vTiBIg5Rznna5aNWsPkNBETtgB9/1YjaZ0MDp7/1Bsl43KCnvnOkw/O7k1BiTf9oqS
         GKJcS8C3USyn7rl+5n291CeJsOLj51UMB5y6u3T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/134] RDMA/core: Fix GID entry ref leak when create_ah fails
Date:   Tue, 18 Apr 2023 14:22:00 +0200
Message-Id: <20230418120315.188875533@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
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
index 11b1c1603aeb4..b99b3cc283b65 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -532,6 +532,8 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 	else
 		ret = device->ops.create_ah(ah, &init_attr, NULL);
 	if (ret) {
+		if (ah->sgid_attr)
+			rdma_put_gid_attr(ah->sgid_attr);
 		kfree(ah);
 		return ERR_PTR(ret);
 	}
-- 
2.39.2



