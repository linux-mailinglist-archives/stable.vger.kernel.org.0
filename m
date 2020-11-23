Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D222C09C5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgKWNMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732749AbgKWMqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A4720888;
        Mon, 23 Nov 2020 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135590;
        bh=dGCvM+zu20OUpkcz5yyUlPA2KaoN7yINe5RQIVbBoHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbHUuLI0+GtyPPDUMe81IAZwZS2ADcEJeQFRj18lIileAg36esBuYfB8rB6S7JQne
         rDDc4Lp2xsbavO0yVdma1gknjQmxim92ySa0u+xZrWzqZPm/Lm4WjZF873SOzVQiPQ
         Om32lx3In9uvsQI1VHdbKh0ddGBBv0qgp8uV8MyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 124/252] SUNRPC: Fix oops in the rpc_xdr_buf event class
Date:   Mon, 23 Nov 2020 13:21:14 +0100
Message-Id: <20201123121841.576489630@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit c3213d260a23e263ef85ba21ac68c9e7578020b5 ]

Backchannel rpc tasks don't have task->tk_client set, so it's necessary
to check it for NULL before dereferencing.

Fixes: c509f15a5801 ("SUNRPC: Split the xdr_buf event class")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index ca2f27b9f919d..1652cc32aebcd 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -68,7 +68,8 @@ DECLARE_EVENT_CLASS(rpc_xdr_buf_class,
 
 	TP_fast_assign(
 		__entry->task_id = task->tk_pid;
-		__entry->client_id = task->tk_client->cl_clid;
+		__entry->client_id = task->tk_client ?
+				     task->tk_client->cl_clid : -1;
 		__entry->head_base = xdr->head[0].iov_base;
 		__entry->head_len = xdr->head[0].iov_len;
 		__entry->tail_base = xdr->tail[0].iov_base;
-- 
2.27.0



