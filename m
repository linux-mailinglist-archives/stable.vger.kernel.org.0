Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C639F5A496A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiH2LYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiH2LXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE811260D;
        Mon, 29 Aug 2022 04:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5642B80F03;
        Mon, 29 Aug 2022 11:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4AAC433C1;
        Mon, 29 Aug 2022 11:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771081;
        bh=/2TgZp9/QnELkEnYvXdcofmDRuWGi0Sg490D9xcwBWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdYMmUww0Kg/LyiS6AslzoMbp2EpywNReTzrZyK3qPcQKGkpBrY/rVSfszJKjlMjI
         5wAcLsFGzUjrcNgOtrnh3u6BkcHf7lLIbIV9fAqkFEJ2/YDRRoui2+pSx0lbPDov4S
         SQaWKt2oa0ZyQ8T8+w+jz0tn8gB9Tmc19M1BZtu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/86] SUNRPC: RPC level errors should set task->tk_rpc_status
Date:   Mon, 29 Aug 2022 12:58:44 +0200
Message-Id: <20220829105757.266541903@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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
index c5af31312e0cf..78c6648af7827 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1867,7 +1867,7 @@ call_encode(struct rpc_task *task)
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



