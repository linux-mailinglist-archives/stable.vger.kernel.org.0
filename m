Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550A61D8359
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbgERSEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbgERSEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D55D20715;
        Mon, 18 May 2020 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825045;
        bh=kr4mAYS/7C1SqnmoS4djr0Ui+8MkF6b6y+xXe2x6Wy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEqWni0oL3Xy2HPwVFlzJJ7ZfZ/nqjS5X7ZEZZOEwuEuKhcbP2TZJecTcH77b87oI
         gSj70x0vCkCEzE1V8nttYBnfrCqubdTnOX2RMpH5ZT/4AyBTVfFiGvdG6PZtdSeL29
         ilBFmMivBTVEMzj6dQd1+Y3df1ox9VuuFqz7GT8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 107/194] SUNRPC: Signalled ASYNC tasks need to exit
Date:   Mon, 18 May 2020 19:36:37 +0200
Message-Id: <20200518173540.755420559@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ce99aa62e1eb793e259d023c7f6ccb7c4879917b ]

Ensure that signalled ASYNC rpc_tasks exit immediately instead of
spinning until a timeout (or forever).

To avoid checking for the signal flag on every scheduler iteration,
the check is instead introduced in the client's finite state
machine.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Fixes: ae67bd3821bb ("SUNRPC: Fix up task signalling")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7324b21f923e6..3ceaefb2f0bcf 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2416,6 +2416,11 @@ rpc_check_timeout(struct rpc_task *task)
 {
 	struct rpc_clnt	*clnt = task->tk_client;
 
+	if (RPC_SIGNALLED(task)) {
+		rpc_call_rpcerror(task, -ERESTARTSYS);
+		return;
+	}
+
 	if (xprt_adjust_timeout(task->tk_rqstp) == 0)
 		return;
 
-- 
2.20.1



