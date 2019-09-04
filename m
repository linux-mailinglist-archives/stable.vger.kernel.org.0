Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886A6A8FDD
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388432AbfIDSGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389408AbfIDSGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E81A523400;
        Wed,  4 Sep 2019 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620374;
        bh=/W9B7Sno1Cvi2aD3B8vReKUaPG7Au4vT5P3cEEHE2l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFV9wuQWWSsmckZBB9Cy47dyxw9sDoIkEihgUVVSmzbV/00GX7sxDUo4Jn42zd9oe
         XUJZWLQE5wmSO8uqMRBQFBaNY7CcoePGZ46uagnZTjJXJiAI96pOPfTI4WdY/M04nu
         WqPA2BkFW6r6C7SceIgifAX2bU1wjD9imWGmWWno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 33/93] net: tls, fix sk_write_space NULL write when tx disabled
Date:   Wed,  4 Sep 2019 19:53:35 +0200
Message-Id: <20190904175306.180232159@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit d85f01775850a35eae47a0090839baf510c1ef12 ]

The ctx->sk_write_space pointer is only set when TLS tx mode is enabled.
When running without TX mode its a null pointer but we still set the
sk sk_write_space pointer on close().

Fix the close path to only overwrite sk->sk_write_space when the current
pointer is to the tls_write_space function indicating the tls module should
clean it up properly as well.

Reported-by: Hillf Danton <hdanton@sina.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Fixes: 57c722e932cfb ("net/tls: swap sk_write_space on close")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -301,7 +301,8 @@ static void tls_sk_proto_close(struct so
 #else
 	{
 #endif
-		sk->sk_write_space = ctx->sk_write_space;
+		if (sk->sk_write_space == tls_write_space)
+			sk->sk_write_space = ctx->sk_write_space;
 		tls_ctx_free(ctx);
 		ctx = NULL;
 	}


