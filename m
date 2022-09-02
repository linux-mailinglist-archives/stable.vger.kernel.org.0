Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85ADB5AAF00
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbiIBMci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiIBMbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:31:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C516EE1AB9;
        Fri,  2 Sep 2022 05:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37B7662178;
        Fri,  2 Sep 2022 12:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C78C433C1;
        Fri,  2 Sep 2022 12:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121628;
        bh=kbqhYeilcXusCl2mgIc1i1PvjLcthAyrfbJIfvIOEj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuDpzGb8XWWjG0GNaKGC1fjwzIV8V/h/uqv9ifn/e1uCiMT0d5pjnvRQO8TxjI9KF
         GVR73UIT1qF34ScWmVtyqEgDU03DXrduB6/1m8BvlgY/bFO5GpFGd4G69/vzRvPAIV
         m0HJ3MTCXMGu6r2LhQVDfsNCzPLkAftJgkltYdd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/77] SUNRPC: RPC level errors should set task->tk_rpc_status
Date:   Fri,  2 Sep 2022 14:18:23 +0200
Message-Id: <20220902121404.110025520@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
index 08e1ccc01e983..1893203cc94fc 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1896,7 +1896,7 @@ call_encode(struct rpc_task *task)
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



