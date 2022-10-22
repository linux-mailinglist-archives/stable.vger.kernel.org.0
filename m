Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D93C608947
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiJVIcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiJVIa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:30:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF7029C3E2;
        Sat, 22 Oct 2022 01:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48DDB60B81;
        Sat, 22 Oct 2022 07:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD4EC433D7;
        Sat, 22 Oct 2022 07:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425258;
        bh=PxotsaKLlKY7b4HcUMIZ3OuGfX1704mNrjuqwc66VrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxayVuqs/L4dWh00aiaXEIOxKMGSn5CHPmXJXXC1vYHwj5xjLsen9GI0wU1LfxSUs
         6opnJFfCDPwFjvUK3F0FFb0wiqTwKkGVozbJ0gw0nMtAM979TF0zDAySvnss/0HMRr
         yeGcDF/0sNL1Hmezpou4yWhWB/kr8aFyNv7OpBHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 442/717] RDMA/cm: Use SLID in the work completion as the DLID in responder side
Date:   Sat, 22 Oct 2022 09:25:21 +0200
Message-Id: <20221022072517.860151769@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit b7d95040c13f61a4a6a859c5355faf583eff9658 ]

The responder should always use WC's SLID as the dlid, to follow the
IB SPEC section "13.5.4.2 COMMON RESPONSE ACTIONS":
A responder always takes the following actions in constructing a
response packet:
- The SLID of the received packet is used as the DLID in the response
  packet.

Fixes: ac3a949fb2ff ("IB/CM: Set appropriate slid and dlid when handling CM request")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Link: https://lore.kernel.org/r/cd17c240231e059d2fc07c17dfe555d548b917eb.1662631201.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index b985e0d9bc05..5c910f5c01b3 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1632,14 +1632,13 @@ static void cm_path_set_rec_type(struct ib_device *ib_device, u32 port_num,
 
 static void cm_format_path_lid_from_req(struct cm_req_msg *req_msg,
 					struct sa_path_rec *primary_path,
-					struct sa_path_rec *alt_path)
+					struct sa_path_rec *alt_path,
+					struct ib_wc *wc)
 {
 	u32 lid;
 
 	if (primary_path->rec_type != SA_PATH_REC_TYPE_OPA) {
-		sa_path_set_dlid(primary_path,
-				 IBA_GET(CM_REQ_PRIMARY_LOCAL_PORT_LID,
-					 req_msg));
+		sa_path_set_dlid(primary_path, wc->slid);
 		sa_path_set_slid(primary_path,
 				 IBA_GET(CM_REQ_PRIMARY_REMOTE_PORT_LID,
 					 req_msg));
@@ -1676,7 +1675,8 @@ static void cm_format_path_lid_from_req(struct cm_req_msg *req_msg,
 
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 				     struct sa_path_rec *primary_path,
-				     struct sa_path_rec *alt_path)
+				     struct sa_path_rec *alt_path,
+				     struct ib_wc *wc)
 {
 	primary_path->dgid =
 		*IBA_GET_MEM_PTR(CM_REQ_PRIMARY_LOCAL_PORT_GID, req_msg);
@@ -1734,7 +1734,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 		if (sa_path_is_roce(alt_path))
 			alt_path->roce.route_resolved = false;
 	}
-	cm_format_path_lid_from_req(req_msg, primary_path, alt_path);
+	cm_format_path_lid_from_req(req_msg, primary_path, alt_path, wc);
 }
 
 static u16 cm_get_bth_pkey(struct cm_work *work)
@@ -2148,7 +2148,7 @@ static int cm_req_handler(struct cm_work *work)
 	if (cm_req_has_alt_path(req_msg))
 		work->path[1].rec_type = work->path[0].rec_type;
 	cm_format_paths_from_req(req_msg, &work->path[0],
-				 &work->path[1]);
+				 &work->path[1], work->mad_recv_wc->wc);
 	if (cm_id_priv->av.ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE)
 		sa_path_set_dmac(&work->path[0],
 				 cm_id_priv->av.ah_attr.roce.dmac);
-- 
2.35.1



