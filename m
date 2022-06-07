Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB22A5410BD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352602AbiFGT3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356167AbiFGT0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:26:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0764A19FF4B;
        Tue,  7 Jun 2022 11:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 274DB6191F;
        Tue,  7 Jun 2022 18:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34180C385A2;
        Tue,  7 Jun 2022 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625383;
        bh=qewUsOd+zR9pD4CwTK2yUgE2uCsGhLzD/qKdKnBcm90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQaJ2Bh3vKyXHpF1g+7pBFKz9lbk9euuie3rI4Y5SYKuLqjSjTD2pWEQOjSQFEOW5
         nfsq86CxDE+pMPfjRi+dSmGkOv0XFpBWhTKz4f3wuhUJYpZkbm55GXEqNi1VRKbXJi
         eNtVqJc91QUGmisBSmOnL0wFbR85GiOZ7eEclUpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 656/667] RDMA/rxe: Generate a completion for unsupported/invalid opcode
Date:   Tue,  7 Jun 2022 19:05:21 +0200
Message-Id: <20220607164954.321795938@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Yang <yangx.jy@fujitsu.com>

commit 2f917af777011c88e977b9b9a5d00b280d3a59ce upstream.

Current rxe_requester() doesn't generate a completion when processing an
unsupported/invalid opcode. If rxe driver doesn't support a new opcode
(e.g. RDMA Atomic Write) and RDMA library supports it, an application
using the new opcode can reproduce this issue. Fix the issue by calling
"goto err;".

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20220410113513.27537-1-yangx.jy@fujitsu.com
Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -683,7 +683,7 @@ next_wqe:
 	opcode = next_opcode(qp, wqe, wqe->wr.opcode);
 	if (unlikely(opcode < 0)) {
 		wqe->status = IB_WC_LOC_QP_OP_ERR;
-		goto exit;
+		goto err;
 	}
 
 	mask = rxe_opcode[opcode].mask;


