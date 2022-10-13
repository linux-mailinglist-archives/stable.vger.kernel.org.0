Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7495FCF3E
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJMAQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJMAQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C7BD2CE7;
        Wed, 12 Oct 2022 17:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2CED616B6;
        Thu, 13 Oct 2022 00:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF06C433C1;
        Thu, 13 Oct 2022 00:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620173;
        bh=2vttJVL/wGU2aeD9rhWr5CzNN4oH2sKTlJIu2eSZwmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAZSV6AMD0UHS1LoIOrLIxWghhoiEUhwwYws8cTbcbIjNISXyQ+08vMdI/9ZScE7J
         XNnGBIDMDVxslYcM34wgUqa6YXDDDMI5YjcX8I0vlU3pM6m5LgO4tA6q8i6MwQ2yJI
         7hZCEDvC1RRah9oohJ6047kn+Cl0SIbxg14SkhAyaaHRM0eVZ8T2m1QTQnryStBDXu
         KzdelqOvXnU2Hy14842LvOFy91TGoAVkUJN4tz9OwRRpF3fRkqO6WCYBPuuiHKzUy1
         LjXYAOc4rAGsk4VzG0MQaoTxtG01lNibjv2prwpAKe67BCmqPJK9Mq1Rnw9k3z7qf4
         jg3g6qU++lMgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 06/67] RDMA/rxe: Delete error messages triggered by incoming Read requests
Date:   Wed, 12 Oct 2022 20:14:47 -0400
Message-Id: <20221013001554.1892206-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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
index b36ec5c4d5e0..7c336db5cb54 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -809,10 +809,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
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
 
@@ -823,10 +821,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
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

