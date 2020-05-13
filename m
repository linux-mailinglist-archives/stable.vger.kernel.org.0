Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4181D0D91
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388055AbgEMJyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388053AbgEMJyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B42B20575;
        Wed, 13 May 2020 09:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363648;
        bh=wVQB35DVJkUTTN5UUzYKgILYjZl1UWPiepEnvyRw1Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3j71y3tMs0N/iL0fhkmJLShe1oD06ghvDNSvo91HiAx0LBHXwPZ4h5ijgV6l6UvJ
         O17n4wHRTDlRA3dnyH946T/UvjB27ks4kyfJY+8h3p46V40N3DUyl6HSQZ6RWP3wtV
         aaDBH2EJ28lMj5QWn+ALPZYJZHsxSBQ85RfP217Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 032/118] net/tls: Fix sk_psock refcnt leak when in tls_data_ready()
Date:   Wed, 13 May 2020 11:44:11 +0200
Message-Id: <20200513094420.336676639@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
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
@@ -2083,8 +2083,9 @@ static void tls_data_ready(struct sock *
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


