Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19168603E21
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiJSJK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbiJSJJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:09:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E2D6888F;
        Wed, 19 Oct 2022 02:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 850CD617D6;
        Wed, 19 Oct 2022 09:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936E1C433D6;
        Wed, 19 Oct 2022 09:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170024;
        bh=DC/OKbNo75HLtAcJhoT1fSpScx56M0NZEY5Sod8yCsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipiV0pNldvy3tHL1xW0Clo/SHkJ14GJu2uqloFlWH+q74dvK7jYR3iKgzdxNly6LS
         4Ijxbggo5ARj+bWHqp6zSijhk7rh+A/MGVbFH8OGDyyDebIR9WsxT9NId9pd7B7gtQ
         Wni5XU0zqISztn3/w1SMSUSxPMBaI7k1SSxm7x3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 499/862] RDMA/rxe: Fix the error caused by qp->sk
Date:   Wed, 19 Oct 2022 10:29:46 +0200
Message-Id: <20221019083312.029376671@linuxfoundation.org>
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
index fda03f9f03ed..d776dfda43b1 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -835,8 +835,10 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 
 	free_rd_atomic_resources(qp);
 
-	kernel_sock_shutdown(qp->sk, SHUT_RDWR);
-	sock_release(qp->sk);
+	if (qp->sk) {
+		kernel_sock_shutdown(qp->sk, SHUT_RDWR);
+		sock_release(qp->sk);
+	}
 }
 
 /* called when the last reference to the qp is dropped */
-- 
2.35.1



