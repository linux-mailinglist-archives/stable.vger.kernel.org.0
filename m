Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54F21D0CED
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbgEMJsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733092AbgEMJsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:48:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6246320575;
        Wed, 13 May 2020 09:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363315;
        bh=POszdWqf52iHnSEcZ1/M2tizmB0GPGEJzJOE5linjRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FScN+siwSAIoX0gXyOtTBQeuHLjLSM93baQy/GHKIGeANfqD4+X+tqPVXNmw+mIld
         jltWY8cJjTS7niM52Za8Ew8O47pxH94TNZPrzc3wCHk5Gi0uveH5u5emwyJtAgXnEY
         FrrGtNOwiKqoxEi5JFbDnGHnciJTq/MU9O7SHAts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 24/90] net/tls: Fix sk_psock refcnt leak when in tls_data_ready()
Date:   Wed, 13 May 2020 11:44:20 +0200
Message-Id: <20200513094411.176123869@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 62b4011fa7bef9fa00a6aeec26e69685dc1cc21e ]

tls_data_ready() invokes sk_psock_get(), which returns a reference of
the specified sk_psock object to "psock" with increased refcnt.

When tls_data_ready() returns, local variable "psock" becomes invalid,
so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
tls_data_ready(). When "psock->ingress_msg" is empty but "psock" is not
NULL, the function forgets to decrease the refcnt increased by
sk_psock_get(), causing a refcnt leak.

Fix this issue by calling sk_psock_put() on all paths when "psock" is
not NULL.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2078,8 +2078,9 @@ static void tls_data_ready(struct sock *
 	strp_data_ready(&ctx->strp);
 
 	psock = sk_psock_get(sk);
-	if (psock && !list_empty(&psock->ingress_msg)) {
-		ctx->saved_data_ready(sk);
+	if (psock) {
+		if (!list_empty(&psock->ingress_msg))
+			ctx->saved_data_ready(sk);
 		sk_psock_put(sk, psock);
 	}
 }


