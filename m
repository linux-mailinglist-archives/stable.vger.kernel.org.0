Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4078960A2CB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiJXLr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiJXLrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:47:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1355176546;
        Mon, 24 Oct 2022 04:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3164FB8117B;
        Mon, 24 Oct 2022 11:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86282C433D6;
        Mon, 24 Oct 2022 11:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611762;
        bh=qYfc8472eOJ6mLmVF7VSLElhyX+9s5NbjPjxIy6+y+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4cZLlb+1thyFfN0wHO464YRmUIXhAhhcqRbagzWd71d4bbjXNwltDGqVFKcuHgGc
         ghZfKXsqSm9k8mR23lALEZu/WCpR2aW0HxdmghXwpRM1VWUWYNNdBKjs0ZAUMe0lpo
         E1/ac1pHwLnzFXLRQvlzVExbaw4cze+81faYL3UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 101/159] RDMA/rxe: Fix the error caused by qp->sk
Date:   Mon, 24 Oct 2022 13:30:55 +0200
Message-Id: <20221024112953.125890105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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

[ Upstream commit 548ce2e66725dcba4e27d1e8ac468d5dd17fd509 ]

When sock_create_kern in the function rxe_qp_init_req fails,
qp->sk is set to NULL.

Then the function rxe_create_qp will call rxe_qp_do_cleanup
to handle allocated resource.

Before handling qp->sk, this variable should be checked.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20220822011615.805603-3-yanjun.zhu@linux.dev
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index d41728397bd2..4c91062ff247 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -864,6 +864,8 @@ void rxe_qp_cleanup(void *arg)
 
 	free_rd_atomic_resources(qp);
 
-	kernel_sock_shutdown(qp->sk, SHUT_RDWR);
-	sock_release(qp->sk);
+	if (qp->sk) {
+		kernel_sock_shutdown(qp->sk, SHUT_RDWR);
+		sock_release(qp->sk);
+	}
 }
-- 
2.35.1



