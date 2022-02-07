Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386B54ABCBA
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387079AbiBGLjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385786AbiBGLcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C24C043188;
        Mon,  7 Feb 2022 03:32:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D870960B20;
        Mon,  7 Feb 2022 11:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF29C004E1;
        Mon,  7 Feb 2022 11:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233554;
        bh=c1+xPpj9w6ih7bgu3DWcQoQVtxFuv7Z/aEH2fqPUAlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wuy6jr3/sYTq5hdluXS7r3O7xi2F1+qaAabUoG5eqh+A1bu7938fHhh0WZ6kHNHU4
         /gcLCB9FH9hK4Vum7sCl62jjhpmrOCDEoOrthUWR0+qaLMh+i0fDGEP6vDMKNXwbdo
         sGjAyIpT9YxPr3kq4Ext9+KiqEUs67fNjOe2gIpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.16 048/126] RDMA/cma: Use correct address when leaving multicast group
Date:   Mon,  7 Feb 2022 12:06:19 +0100
Message-Id: <20220207103805.779925636@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Maor Gottlieb <maorg@nvidia.com>

commit d9e410ebbed9d091b97bdf45b8a3792e2878dc48 upstream.

In RoCE we should use cma_iboe_set_mgid() and not cma_set_mgid to generate
the mgid, otherwise we will generate an IGMP for an incorrect address.

Fixes: b5de0c60cc30 ("RDMA/cma: Fix use after free race in roce multicast join")
Link: https://lore.kernel.org/r/913bc6783fd7a95fe71ad9454e01653ee6fb4a9a.1642491047.git.leonro@nvidia.com
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -67,8 +67,8 @@ static const char * const cma_events[] =
 	[RDMA_CM_EVENT_TIMEWAIT_EXIT]	 = "timewait exit",
 };
 
-static void cma_set_mgid(struct rdma_id_private *id_priv, struct sockaddr *addr,
-			 union ib_gid *mgid);
+static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid,
+			      enum ib_gid_type gid_type);
 
 const char *__attribute_const__ rdma_event_msg(enum rdma_cm_event_type event)
 {
@@ -1846,17 +1846,19 @@ static void destroy_mc(struct rdma_id_pr
 		if (dev_addr->bound_dev_if)
 			ndev = dev_get_by_index(dev_addr->net,
 						dev_addr->bound_dev_if);
-		if (ndev) {
+		if (ndev && !send_only) {
+			enum ib_gid_type gid_type;
 			union ib_gid mgid;
 
-			cma_set_mgid(id_priv, (struct sockaddr *)&mc->addr,
-				     &mgid);
-
-			if (!send_only)
-				cma_igmp_send(ndev, &mgid, false);
-
-			dev_put(ndev);
+			gid_type = id_priv->cma_dev->default_gid_type
+					   [id_priv->id.port_num -
+					    rdma_start_port(
+						    id_priv->cma_dev->device)];
+			cma_iboe_set_mgid((struct sockaddr *)&mc->addr, &mgid,
+					  gid_type);
+			cma_igmp_send(ndev, &mgid, false);
 		}
+		dev_put(ndev);
 
 		cancel_work_sync(&mc->iboe_join.work);
 	}


