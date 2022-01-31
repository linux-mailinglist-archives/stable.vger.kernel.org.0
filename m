Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEDB4A42EA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359825AbiAaLPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:15:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33200 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376817AbiAaLNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:13:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E973B82A61;
        Mon, 31 Jan 2022 11:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644A0C340E8;
        Mon, 31 Jan 2022 11:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627599;
        bh=VVFlRxXq3A5E85ti0MGg4WcaiubDLDuQRc9Mef1tSPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhynsmbYhmflOvhWvl+MML98YJRa89wg+jvnNoAzij97BHGCH2A3XlEyZA0ouWRsW
         it7C/gpJy30lPTgzOp87iumgb1Pci4ti6Ir4Mqmy5U5LQT4UNysNfyGZuXVe7/8CFU
         tW7QYxP7fwpRvLBfpyI4aznWP1mNXHMEIKAZ0aQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/171] SUNRPC: Use BIT() macro in rpc_show_xprt_state()
Date:   Mon, 31 Jan 2022 11:56:08 +0100
Message-Id: <20220131105233.538017557@linuxfoundation.org>
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

[ Upstream commit 76497b1adb89175eee85afc437f08a68247314b3 ]

Clean up: BIT() is preferred over open-coding the shift.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 2d04eb96d4183..312507cb341f4 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -925,18 +925,18 @@ TRACE_EVENT(rpc_socket_nospace,
 
 #define rpc_show_xprt_state(x)						\
 	__print_flags(x, "|",						\
-		{ (1UL << XPRT_LOCKED),		"LOCKED"},		\
-		{ (1UL << XPRT_CONNECTED),	"CONNECTED"},		\
-		{ (1UL << XPRT_CONNECTING),	"CONNECTING"},		\
-		{ (1UL << XPRT_CLOSE_WAIT),	"CLOSE_WAIT"},		\
-		{ (1UL << XPRT_BOUND),		"BOUND"},		\
-		{ (1UL << XPRT_BINDING),	"BINDING"},		\
-		{ (1UL << XPRT_CLOSING),	"CLOSING"},		\
-		{ (1UL << XPRT_OFFLINE),	"OFFLINE"},		\
-		{ (1UL << XPRT_REMOVE),		"REMOVE"},		\
-		{ (1UL << XPRT_CONGESTED),	"CONGESTED"},		\
-		{ (1UL << XPRT_CWND_WAIT),	"CWND_WAIT"},		\
-		{ (1UL << XPRT_WRITE_SPACE),	"WRITE_SPACE"})
+		{ BIT(XPRT_LOCKED),		"LOCKED" },		\
+		{ BIT(XPRT_CONNECTED),		"CONNECTED" },		\
+		{ BIT(XPRT_CONNECTING),		"CONNECTING" },		\
+		{ BIT(XPRT_CLOSE_WAIT),		"CLOSE_WAIT" },		\
+		{ BIT(XPRT_BOUND),		"BOUND" },		\
+		{ BIT(XPRT_BINDING),		"BINDING" },		\
+		{ BIT(XPRT_CLOSING),		"CLOSING" },		\
+		{ BIT(XPRT_OFFLINE),		"OFFLINE" },		\
+		{ BIT(XPRT_REMOVE),		"REMOVE" },		\
+		{ BIT(XPRT_CONGESTED),		"CONGESTED" },		\
+		{ BIT(XPRT_CWND_WAIT),		"CWND_WAIT" },		\
+		{ BIT(XPRT_WRITE_SPACE),	"WRITE_SPACE" })
 
 DECLARE_EVENT_CLASS(rpc_xprt_lifetime_class,
 	TP_PROTO(
-- 
2.34.1



