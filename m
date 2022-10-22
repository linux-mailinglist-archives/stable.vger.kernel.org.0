Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B27608A7E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiJVI5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiJVI47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF565DEF35;
        Sat, 22 Oct 2022 01:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E95160ADC;
        Sat, 22 Oct 2022 08:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73773C433C1;
        Sat, 22 Oct 2022 08:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425957;
        bh=7La2O9nGNKQitcBs24OLPlXs/LRT+Ca0fFDBGqHMwGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZF9gjC1/emEg6mDqXRWhxHirYxfLBcv+AtcdYWuUEt9eCJklZ3PqVPg0nYsJa2NgF
         gebTaQ3u7tbe8Ej6r9DGsmlYwpFIPuEFrugNPnpRXS0P0M+MU8IWB8b9VeQPHjJJ+a
         WDsNjnSf4YaQDtC8gw73G/1wkKYBZGwVHdUpzl64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 654/717] RDMA/rxe: Delete error messages triggered by incoming Read requests
Date:   Sat, 22 Oct 2022 09:28:53 +0200
Message-Id: <20221022072527.341237628@linuxfoundation.org>
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



