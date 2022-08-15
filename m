Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D6E59452E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345040AbiHOWTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348783AbiHOWQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:16:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A660721AD;
        Mon, 15 Aug 2022 12:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38A0DB80EA7;
        Mon, 15 Aug 2022 19:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A62BC433C1;
        Mon, 15 Aug 2022 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592414;
        bh=NHPrvVnto3EMCBY8LbHNdEtDFe8etvb83mdQkSrVy8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJuAK5syT0w9ayFyu4eFZzmc/Y9/CwIUsEzIoQtznnel/lqTGlg30TYMmlpcmOiCT
         CRvH6rj/epAUV8eFd+p+ntX0X4wEldJ9wVQgQrA5UuGja7QjgijR1ERwbouMiAfl26
         lh5MTA5h4T1aGhWjSHsZdyq+6bcbutCbn7f+SUoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0783/1095] RDMA/rxe: Fix mw bind to allow any consumer key portion
Date:   Mon, 15 Aug 2022 20:03:02 +0200
Message-Id: <20220815180501.656208317@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 1603f89935ec86d40a7667e1250392626976ccc2 ]

The current implementation of rxe_check_bind_mw() in rxe_mw.c is incorrect
since it requires the new key portion provided by the mw consumer to be
different than the previous key portion. This is not required by the
IBA. Remove the test.

Link: https://lore.kernel.org/linux-rdma/fb4614e7-4cac-0dc7-3ef7-766dfd10e8f2@gmail.com/
Fixes: 32a577b4c3a9 ("Add support for bind MW work requests")
Link: https://lore.kernel.org/r/20220714204619.13396-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mw.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index c86b2efd58f2..fc1416fc7feb 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -69,8 +69,6 @@ int rxe_dealloc_mw(struct ib_mw *ibmw)
 static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 			 struct rxe_mw *mw, struct rxe_mr *mr)
 {
-	u32 key = wqe->wr.wr.mw.rkey & 0xff;
-
 	if (mw->ibmw.type == IB_MW_TYPE_1) {
 		if (unlikely(mw->state != RXE_MW_STATE_VALID)) {
 			pr_err_once(
@@ -108,11 +106,6 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		}
 	}
 
-	if (unlikely(key == (mw->rkey & 0xff))) {
-		pr_err_once("attempt to bind MW with same key\n");
-		return -EINVAL;
-	}
-
 	/* remaining checks only apply to a nonzero MR */
 	if (!mr)
 		return 0;
-- 
2.35.1



