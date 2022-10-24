Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A2B60A5F2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiJXMbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiJXM3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAB386FA1;
        Mon, 24 Oct 2022 05:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59E5DB8120C;
        Mon, 24 Oct 2022 12:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8B6C433D6;
        Mon, 24 Oct 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612817;
        bh=oW7cK+FgFeRGM8uvw9N6ZCn4rBD7IY418OcUHQF2Ln4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hkht0Y9ST+iEJk0Z1cuNJ9KhYf/9kcHxQfVLRbwvVMzsOLr5HiGqPSQ6R384PaIcm
         vG9me0VGO8FlK4ORTutPiuFbrr8cWypdUiVdMhPRQ+YbUT103tMRUGPIWWFrZhoMKj
         AkQj8zz3ncTYAUz0GMOJ2HF+XhJq6cL+tDIDResc=
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
Subject: [PATCH 4.19 131/229] RDMA/rxe: Fix "kernel NULL pointer dereference" error
Date:   Mon, 24 Oct 2022 13:30:50 +0200
Message-Id: <20221024113003.240809208@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
index a4b5374deac8..476871c8ae44 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -799,7 +799,9 @@ void rxe_qp_destroy(struct rxe_qp *qp)
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



