Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A07540807
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbiFGRxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350180AbiFGRv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F42143840;
        Tue,  7 Jun 2022 10:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29A8861499;
        Tue,  7 Jun 2022 17:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34416C385A5;
        Tue,  7 Jun 2022 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623524;
        bh=fzyvPfZ+ti4QPxz21VI+b5/oRwIhz37nEWqk4JcZc8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4SdBqqkmMiT2rPsi7wdrFdD0quPxl7ZPwNZRJxkSR7jeJKZ0z4oQM5TNUu2y7OGX
         n1oP/BbiSGSJKj+z6RkdxZ3iGuhvdUVm2Z+CtEdHJGNYMOIiM9kyCmuUpCi9k5QDfW
         Kq92/TRMOAs2c/z7sEVkBTsC1+EOd3wEzChxAH4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 448/452] RDMA/rxe: Generate a completion for unsupported/invalid opcode
Date:   Tue,  7 Jun 2022 19:05:05 +0200
Message-Id: <20220607164921.920610632@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
@@ -650,7 +650,7 @@ next_wqe:
 	opcode = next_opcode(qp, wqe, wqe->wr.opcode);
 	if (unlikely(opcode < 0)) {
 		wqe->status = IB_WC_LOC_QP_OP_ERR;
-		goto exit;
+		goto err;
 	}
 
 	mask = rxe_opcode[opcode].mask;


