Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B5A47261F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbhLMJtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38888 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbhLMJqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:46:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3483FCE0E77;
        Mon, 13 Dec 2021 09:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CFEC00446;
        Mon, 13 Dec 2021 09:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388778;
        bh=C88MCJzXDhAZlBJg1u53JQ6H5Sr20zDIjvbrOCYZLhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPWEdxJaS9v7tgFi+rsiuqEXvNcQXt40L6jMjdLShYyw0PQtCvnXZD0flWT3g6ri5
         MUt4qB5XHJbYlBGKA2Dl6MBvJ/XkAE2lDg+M8u18RL30UZlX4LgFffiklx98R3EfxK
         QLqwq7tXrWIiXb5QumNf5G1n3plalHj3MNHGbNp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jeya R <jeyr@codeaurora.org>
Subject: [PATCH 5.4 87/88] misc: fastrpc: fix improper packet size calculation
Date:   Mon, 13 Dec 2021 10:30:57 +0100
Message-Id: <20211213092936.204418355@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeya R <jeyr@codeaurora.org>

commit 3a1bf591e9a410f220b7405a142a47407394a1d5 upstream.

The buffer list is sorted and this is not being considered while
calculating packet size. This would lead to improper copy length
calculation for non-dmaheap buffers which would eventually cause
sending improper buffers to DSP.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Jeya R <jeyr@codeaurora.org>
Link: https://lore.kernel.org/r/1637771481-4299-1-git-send-email-jeyr@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -693,16 +693,18 @@ static int fastrpc_get_meta_size(struct
 static u64 fastrpc_get_payload_size(struct fastrpc_invoke_ctx *ctx, int metalen)
 {
 	u64 size = 0;
-	int i;
+	int oix;
 
 	size = ALIGN(metalen, FASTRPC_ALIGN);
-	for (i = 0; i < ctx->nscalars; i++) {
+	for (oix = 0; oix < ctx->nbufs; oix++) {
+		int i = ctx->olaps[oix].raix;
+
 		if (ctx->args[i].fd == 0 || ctx->args[i].fd == -1) {
 
-			if (ctx->olaps[i].offset == 0)
+			if (ctx->olaps[oix].offset == 0)
 				size = ALIGN(size, FASTRPC_ALIGN);
 
-			size += (ctx->olaps[i].mend - ctx->olaps[i].mstart);
+			size += (ctx->olaps[oix].mend - ctx->olaps[oix].mstart);
 		}
 	}
 


