Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D536AEB2A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjCGRkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjCGRkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:40:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D49E64A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:36:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CD0161514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621E7C433D2;
        Tue,  7 Mar 2023 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210600;
        bh=r74qzv206EakRA3oQ31TZZP6Q5nPJwU5jb7SK+MfzJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gN0CRTjtz0XJA8V3eNxpeVjTMFxglXVllnz5NZf3pprMS92b9rpKUjOU0w3kO4TP/
         bSOcR67yox4pFo1D+VBkdfsQHuPVpr4NvbfW3o+t0nuxttWjekTRHVhbqMSefhKzyt
         lJw7ZXVRq8KXqFNnysejZmxuRTrrllqf+Aa4dIDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0562/1001] iw_cxgb4: Fix potential NULL dereference in c4iw_fill_res_cm_id_entry()
Date:   Tue,  7 Mar 2023 17:55:34 +0100
Message-Id: <20230307170045.872477227@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 4ca446b127c568b59cb8d9748b6f70499624bb18 ]

This condition needs to match the previous "if (epcp->state == LISTEN) {"
exactly to avoid a NULL dereference of either "listen_ep" or "ep". The
problem is that "epcp" has been re-assigned so just testing
"if (epcp->state == LISTEN) {" a second time is not sufficient.

Fixes: 116aeb887371 ("iw_cxgb4: provide detailed provider-specific CM_ID information")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y+usKuWIKr4dimZh@kili
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/restrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/restrack.c b/drivers/infiniband/hw/cxgb4/restrack.c
index ff645b955a082..fd22c85d35f4f 100644
--- a/drivers/infiniband/hw/cxgb4/restrack.c
+++ b/drivers/infiniband/hw/cxgb4/restrack.c
@@ -238,7 +238,7 @@ int c4iw_fill_res_cm_id_entry(struct sk_buff *msg,
 	if (rdma_nl_put_driver_u64_hex(msg, "history", epcp->history))
 		goto err_cancel_table;
 
-	if (epcp->state == LISTEN) {
+	if (listen_ep) {
 		if (rdma_nl_put_driver_u32(msg, "stid", listen_ep->stid))
 			goto err_cancel_table;
 		if (rdma_nl_put_driver_u32(msg, "backlog", listen_ep->backlog))
-- 
2.39.2



