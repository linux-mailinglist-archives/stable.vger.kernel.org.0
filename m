Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3413C604117
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiJSKhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiJSKg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:36:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE58F01B;
        Wed, 19 Oct 2022 03:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60429CE21B3;
        Wed, 19 Oct 2022 09:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E266C433C1;
        Wed, 19 Oct 2022 09:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170811;
        bh=2vttJVL/wGU2aeD9rhWr5CzNN4oH2sKTlJIu2eSZwmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KkITEmOv1iZFOs1p5SurGBmrFbRt6U4LM15r+l/FKUlS73G8qVTgpF9AM0Dz6B+P
         uE2lV5DggZiWt9+UR2kheqYIjryejgHDNVwJOMP23BW0HcVxZ5W+LorQWxVabjSrBZ
         JR2y5V6sLcVK1mZ2NCBc3gS4JHnR8dMCJHkQU6zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 796/862] RDMA/rxe: Delete error messages triggered by incoming Read requests
Date:   Wed, 19 Oct 2022 10:34:43 +0200
Message-Id: <20221019083325.076112879@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



