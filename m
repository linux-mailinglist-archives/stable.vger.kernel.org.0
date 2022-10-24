Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486DD60A92F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiJXNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbiJXNOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:14:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02119A2A84;
        Mon, 24 Oct 2022 05:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E742612DA;
        Mon, 24 Oct 2022 12:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C86AC433C1;
        Mon, 24 Oct 2022 12:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614305;
        bh=A2cmLKhgaLuOHRm03hf+NAzBffCw+SrwMhodahhuDxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMCLksyBBQkQzXMMcDQ930DM7S37KLQyGEcH4rimJUHe0jG5wgJTIHlCIF8qFjR7A
         Pj64KKlAcd1kUhtJtfXS7eDt2GS237uOaej4kjFP+5nOsoASnVMELJ0mfJG2HhaSOH
         3nE15zeeirh/A9cL1oDFPrGsIoVSmcOBTRA3RILM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ab99dc4c6e961eed8b8e@syzkaller.appspotmail.com,
        Zhu Yanjun <yanjun.zhu@linux.dev>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/390] RDMA/rxe: Fix "kernel NULL pointer dereference" error
Date:   Mon, 24 Oct 2022 13:30:07 +0200
Message-Id: <20221024113031.725302420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit a625ca30eff806395175ebad3ac1399014bdb280 ]

When rxe_queue_init in the function rxe_qp_init_req fails,
both qp->req.task.func and qp->req.task.arg are not initialized.

Because of creation of qp fails, the function rxe_create_qp will
call rxe_qp_do_cleanup to handle allocated resource.

Before calling __rxe_do_task, both qp->req.task.func and
qp->req.task.arg should be checked.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20220822011615.805603-2-yanjun.zhu@linux.dev
Reported-by: syzbot+ab99dc4c6e961eed8b8e@syzkaller.appspotmail.com
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 2847ab4d9a5f..6acef6e923de 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -775,7 +775,9 @@ void rxe_qp_destroy(struct rxe_qp *qp)
 	rxe_cleanup_task(&qp->comp.task);
 
 	/* flush out any receive wr's or pending requests */
-	__rxe_do_task(&qp->req.task);
+	if (qp->req.task.func)
+		__rxe_do_task(&qp->req.task);
+
 	if (qp->sq.queue) {
 		__rxe_do_task(&qp->comp.task);
 		__rxe_do_task(&qp->req.task);
-- 
2.35.1



