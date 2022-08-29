Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17F45A48C1
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiH2LPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiH2LOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200A071BCB;
        Mon, 29 Aug 2022 04:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D301E611F8;
        Mon, 29 Aug 2022 11:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E8CC433D6;
        Mon, 29 Aug 2022 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771427;
        bh=w7yZ9TALBK8/li3U2l9zjEx9kdTG3BBKn5dq1MRRWwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCYv6zolbzGwh4Svd1gAf2yO1Gy7dtPuKf7YJGJS+64blCJFxDVWpPkB59Zx/whvJ
         0Z6oWqm7XPjK8feOVrtv4QF/XbcthyuLzBP34eLi/k3xxEpt3RTHeLUpg2vizsWxGb
         HgJqbJKQFLwxxU3b1Kki49l+u2s/wEaMMpXuNouA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 020/158] SUNRPC: RPC level errors should set task->tk_rpc_status
Date:   Mon, 29 Aug 2022 12:57:50 +0200
Message-Id: <20220829105809.669024448@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ed06fce0b034b2e25bd93430f5c4cbb28036cc1a ]

Fix up a case in call_encode() where we're failing to set
task->tk_rpc_status when an RPC level error occurred.

Fixes: 9c5948c24869 ("SUNRPC: task should be exit if encode return EKEYEXPIRED more times")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 733f9f2260926..c1a01947530f0 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1888,7 +1888,7 @@ call_encode(struct rpc_task *task)
 			break;
 		case -EKEYEXPIRED:
 			if (!task->tk_cred_retry) {
-				rpc_exit(task, task->tk_status);
+				rpc_call_rpcerror(task, task->tk_status);
 			} else {
 				task->tk_action = call_refresh;
 				task->tk_cred_retry--;
-- 
2.35.1



