Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528D46AF04D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjCGS35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbjCGS3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CDF23DB5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E3C614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3D0C433EF;
        Tue,  7 Mar 2023 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213353;
        bh=r74qzv206EakRA3oQ31TZZP6Q5nPJwU5jb7SK+MfzJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRD3qEsADVqDQkkqtK/BLcsfzzg6VsKypqH1V6omAKUtBK2uCGfDi2YNNTnoMpD9F
         zf9EVwk11EpIfmy/oDeWB3TNJG1y6Jt2s6knxK6Fs1akqc09EEvfl8Cbl74mZxbcHL
         uL/vDCyzNkm/VTm67kF3YleWGhDb/leljbhAFIEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 481/885] iw_cxgb4: Fix potential NULL dereference in c4iw_fill_res_cm_id_entry()
Date:   Tue,  7 Mar 2023 17:56:55 +0100
Message-Id: <20230307170023.384056804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



