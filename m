Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0A5FD03E
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiJMAZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiJMAYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CD4104D31;
        Wed, 12 Oct 2022 17:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08883616BE;
        Thu, 13 Oct 2022 00:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A22C43470;
        Thu, 13 Oct 2022 00:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620343;
        bh=7La2O9nGNKQitcBs24OLPlXs/LRT+Ca0fFDBGqHMwGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXAib9E3DXiyqok0Vg17JuYJU15JvFQcB+pEKn/6ECNA1AnIq2/9C1MGyIfatQUTY
         WLYogr1MS6+GUBJ9JXopzeFDeKo37DuoAN8P7AylgUX5kp/Auy92mjBga44MXdXZO+
         6otjfmsJX2s4dZbxE8FAnfem2C3K3nd7JbvJPuWaQX0l+lgdgIAwKZFVmlYabp0/DU
         dMUPfjc9BFYE8pvng9iT2TjAz1RY1fHoQhTlt9CqDAkiE3sTb77JEcje1yB5dq+jBY
         xplPuGUad+B69sEjYwqCicuhNFStf44ODl31BqjibA0Gh3OaQ8AH+xpIHoQtyGEYw2
         BmjA/MG/oVlcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 06/63] RDMA/rxe: Delete error messages triggered by incoming Read requests
Date:   Wed, 12 Oct 2022 20:17:40 -0400
Message-Id: <20221013001842.1893243-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>

[ Upstream commit 2c02249fcbfc066bd33e2a7375c7006d4cb367f6 ]

An incoming Read request causes multiple Read responses. If a user MR to
copy data from is unavailable or responder cannot send a reply, then the
error messages can be printed for each response attempt, resulting in
message overflow.

Link: https://lore.kernel.org/r/20220829071218.1639065-1-matsuda-daisuke@fujitsu.com
Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index e38bf958ab48..2ef21a1cba81 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -787,10 +787,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	if (!skb)
 		return RESPST_ERR_RNR;
 
-	err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
-			  payload, RXE_FROM_MR_OBJ);
-	if (err)
-		pr_err("Failed copying memory\n");
+	rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
+		    payload, RXE_FROM_MR_OBJ);
 	if (mr)
 		rxe_put(mr);
 
@@ -801,10 +799,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	}
 
 	err = rxe_xmit_packet(qp, &ack_pkt, skb);
-	if (err) {
-		pr_err("Failed sending RDMA reply.\n");
+	if (err)
 		return RESPST_ERR_RNR;
-	}
 
 	res->read.va += payload;
 	res->read.resid -= payload;
-- 
2.35.1

