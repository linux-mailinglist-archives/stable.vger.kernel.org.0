Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9114A42EB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376531AbiAaLPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:15:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33224 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376871AbiAaLNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:13:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E840B82A68;
        Mon, 31 Jan 2022 11:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78511C340E8;
        Mon, 31 Jan 2022 11:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627602;
        bh=b8wJglF94ze4TyFtxH7NCAIi2wOYVFD8caRZyOa6BtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdIC6KEkTj+PM1J9HJljR3Ce2Co/z2umlGAckYvJerU3Ef/TGTEBPl4bL/miB5Em9
         KVmvdw1z45OVK7zHpyz4ay2dnfsBzSoIpdzxRYnduPfYCBqowmOU+FGeoyASIjkr92
         gKX7K3rVRknQeTl/2mO9VjFooFQPbX6muwB5d+hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/171] SUNRPC: Dont dereference xprt->snd_task if its a cookie
Date:   Mon, 31 Jan 2022 11:56:09 +0100
Message-Id: <20220131105233.569282280@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
index 312507cb341f4..daaf407e9e494 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -936,7 +936,8 @@ TRACE_EVENT(rpc_socket_nospace,
 		{ BIT(XPRT_REMOVE),		"REMOVE" },		\
 		{ BIT(XPRT_CONGESTED),		"CONGESTED" },		\
 		{ BIT(XPRT_CWND_WAIT),		"CWND_WAIT" },		\
-		{ BIT(XPRT_WRITE_SPACE),	"WRITE_SPACE" })
+		{ BIT(XPRT_WRITE_SPACE),	"WRITE_SPACE" },	\
+		{ BIT(XPRT_SND_IS_COOKIE),	"SND_IS_COOKIE" })
 
 DECLARE_EVENT_CLASS(rpc_xprt_lifetime_class,
 	TP_PROTO(
@@ -1133,8 +1134,11 @@ DECLARE_EVENT_CLASS(xprt_writelock_event,
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
 
 	TP_printk("task:%u@%u snd_task:%u",
@@ -1178,8 +1182,12 @@ DECLARE_EVENT_CLASS(xprt_cong_event,
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



