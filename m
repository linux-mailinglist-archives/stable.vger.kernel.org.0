Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953C84A44FB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343965AbiAaLf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350765AbiAaLbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89686C0619C4;
        Mon, 31 Jan 2022 03:21:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 279DF61120;
        Mon, 31 Jan 2022 11:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D40C340E8;
        Mon, 31 Jan 2022 11:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628101;
        bh=WmmmOwqTvv7mWAhmZL3Z+Dtmrc7D9pi6+R17v57TzT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDOB+UiACfncDuxy21yYCsU7km8LQNVE7oWo+ykfMpt3bcU/2kZPgzgXRvyGy52Lj
         WH9nXh8BoT4ACWAK7vDK1kqW6H1J/iLgUyHXnjQMyFD7Os8TGwF/ERwHURzKveKStg
         cjC6lBoXWB/8jKb7p/IpHfnUzv228OoZLsGgcGuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 124/200] SUNRPC: Dont dereference xprt->snd_task if its a cookie
Date:   Mon, 31 Jan 2022 11:56:27 +0100
Message-Id: <20220131105237.727631058@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit aed28b7a2d620cb5cd0c554cb889075c02e25e8e ]

Fixes: e26d9972720e ("SUNRPC: Clean up scheduling of autoclose")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 7b5dcff84cf27..54eb1654d9ecc 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -953,7 +953,8 @@ TRACE_EVENT(rpc_socket_nospace,
 		{ BIT(XPRT_REMOVE),		"REMOVE" },		\
 		{ BIT(XPRT_CONGESTED),		"CONGESTED" },		\
 		{ BIT(XPRT_CWND_WAIT),		"CWND_WAIT" },		\
-		{ BIT(XPRT_WRITE_SPACE),	"WRITE_SPACE" })
+		{ BIT(XPRT_WRITE_SPACE),	"WRITE_SPACE" },	\
+		{ BIT(XPRT_SND_IS_COOKIE),	"SND_IS_COOKIE" })
 
 DECLARE_EVENT_CLASS(rpc_xprt_lifetime_class,
 	TP_PROTO(
@@ -1150,8 +1151,11 @@ DECLARE_EVENT_CLASS(xprt_writelock_event,
 			__entry->task_id = -1;
 			__entry->client_id = -1;
 		}
-		__entry->snd_task_id = xprt->snd_task ?
-					xprt->snd_task->tk_pid : -1;
+		if (xprt->snd_task &&
+		    !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
+			__entry->snd_task_id = xprt->snd_task->tk_pid;
+		else
+			__entry->snd_task_id = -1;
 	),
 
 	TP_printk(SUNRPC_TRACE_TASK_SPECIFIER
@@ -1196,8 +1200,12 @@ DECLARE_EVENT_CLASS(xprt_cong_event,
 			__entry->task_id = -1;
 			__entry->client_id = -1;
 		}
-		__entry->snd_task_id = xprt->snd_task ?
-					xprt->snd_task->tk_pid : -1;
+		if (xprt->snd_task &&
+		    !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
+			__entry->snd_task_id = xprt->snd_task->tk_pid;
+		else
+			__entry->snd_task_id = -1;
+
 		__entry->cong = xprt->cong;
 		__entry->cwnd = xprt->cwnd;
 		__entry->wait = test_bit(XPRT_CWND_WAIT, &xprt->state);
-- 
2.34.1



