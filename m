Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527C55C01FD
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiIUPqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiIUPqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:46:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CE37A752;
        Wed, 21 Sep 2022 08:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C924B81D4E;
        Wed, 21 Sep 2022 15:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC60C433C1;
        Wed, 21 Sep 2022 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775193;
        bh=g1RKYksMN4B918rVOxEEsGtuG8Q/r3hPQIjUx2+npIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wARFgvBxwQwsRZnPahr88JTfdMM7OuLlVkUq8yORI9RIn2GigmXcbSi7nMfBrxv1m
         1UM/Ov1FMcvoGOPR5DpOTp1bfa7hlg8cZsOzXdwuQGBl/9lZ4krtvhkn325seeVYp8
         HnH9ugH5wzskatkj7pvnDXLYb7wGGuwgk7ijBcxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan.aloni@vastdata.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 10/38] Revert "SUNRPC: Remove unreachable error condition"
Date:   Wed, 21 Sep 2022 17:45:54 +0200
Message-Id: <20220921153646.626147278@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan.aloni@vastdata.com>

[ Upstream commit 13bd9014180425f5a35eaf3735971d582c299292 ]

This reverts commit efe57fd58e1cb77f9186152ee12a8aa4ae3348e0.

The assumption that it is impossible to return an ERR pointer from
rpc_run_task() no longer holds due to commit 25cf32ad5dba ("SUNRPC:
Handle allocation failure in rpc_new_task()").

Fixes: 25cf32ad5dba ('SUNRPC: Handle allocation failure in rpc_new_task()')
Fixes: efe57fd58e1c ('SUNRPC: Remove unreachable error condition')
Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index c1a01947530f..db8c0de1de42 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2858,6 +2858,9 @@ int rpc_clnt_test_and_add_xprt(struct rpc_clnt *clnt,
 
 	task = rpc_call_null_helper(clnt, xprt, NULL, RPC_TASK_ASYNC,
 			&rpc_cb_add_xprt_call_ops, data);
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
 	data->xps->xps_nunique_destaddr_xprts++;
 	rpc_put_task(task);
 success:
-- 
2.35.1



