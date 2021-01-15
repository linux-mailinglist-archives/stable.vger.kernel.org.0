Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B5C2F7B80
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbhAONCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731651AbhAOMcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 243672339D;
        Fri, 15 Jan 2021 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713929;
        bh=vzDbLjDdpWdvu5S8k1Zf/+vqpKmaM+lttFnZlmXVDB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbYWS8fAvKQq4vpTHnQ3LHAPp5g7ox1Hl2AR/1hwPK1X2R6tiuiJfxSvMA+Dp9SG0
         SX5ewrnRqgTp36meLS9VoyIdkqU2cA/AfZ9yzg1CTchzyu2+tJYX7rEe1zYZTCQ6k4
         ep2N2we/5xFZ+Sn7kUiZ3ZbWBNrDvKsfx/lUn1Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 13/43] chtls: Replace skb_dequeue with skb_peek
Date:   Fri, 15 Jan 2021 13:27:43 +0100
Message-Id: <20210115121957.686731061@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit a84b2c0d5fa23da6d6c8c0d5f5c93184a2744d3e ]

The skb is unlinked twice, one in __skb_dequeue in function
chtls_reset_synq() and another in cleanup_syn_rcv_conn().
So in this patch using skb_peek() instead of __skb_dequeue(),
so that unlink will be handled only in cleanup_syn_rcv_conn().

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -581,7 +581,7 @@ static void chtls_reset_synq(struct list
 
 	while (!skb_queue_empty(&listen_ctx->synq)) {
 		struct chtls_sock *csk =
-			container_of((struct synq *)__skb_dequeue
+			container_of((struct synq *)skb_peek
 				(&listen_ctx->synq), struct chtls_sock, synq);
 		struct sock *child = csk->sk;
 


