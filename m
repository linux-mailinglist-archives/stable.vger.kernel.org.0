Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181491EAB5F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgFASQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgFASQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67526206E2;
        Mon,  1 Jun 2020 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035410;
        bh=scFyBVGxOQAg+8KJ2WS1VhCtq2bkXd2MitdF3sJ9Agc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBc6UpTqmG7W41frGrbCLbhYRzI2MyXizgd2aIqzHtbSKdu9BRYUtVLlyt93CJaPF
         +knuIrBuM3GSGHQ6OQRdrT2updmsBr1njS0AnVrr6kmdSufsLP8dZbMQ+dY+VgWIdy
         cFhSppk7IHTR2wkc38CZg/bdlvmj9AEQGKWYj8G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.6 147/177] xfrm: espintcp: save and call old ->sk_destruct
Date:   Mon,  1 Jun 2020 19:54:45 +0200
Message-Id: <20200601174100.713180516@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit 9f0cadc32d738f0f0c8e30be83be7087c7b85ee5 upstream.

When ESP encapsulation is enabled on a TCP socket, I'm replacing the
existing ->sk_destruct callback with espintcp_destruct. We still need to
call the old callback to perform the other cleanups when the socket is
destroyed. Save the old callback, and call it from espintcp_destruct.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/espintcp.h |    1 +
 net/xfrm/espintcp.c    |    2 ++
 2 files changed, 3 insertions(+)

--- a/include/net/espintcp.h
+++ b/include/net/espintcp.h
@@ -25,6 +25,7 @@ struct espintcp_ctx {
 	struct espintcp_msg partial;
 	void (*saved_data_ready)(struct sock *sk);
 	void (*saved_write_space)(struct sock *sk);
+	void (*saved_destruct)(struct sock *sk);
 	struct work_struct work;
 	bool tx_running;
 };
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -379,6 +379,7 @@ static void espintcp_destruct(struct soc
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
+	ctx->saved_destruct(sk);
 	kfree(ctx);
 }
 
@@ -419,6 +420,7 @@ static int espintcp_init_sk(struct sock
 	sk->sk_socket->ops = &espintcp_ops;
 	ctx->saved_data_ready = sk->sk_data_ready;
 	ctx->saved_write_space = sk->sk_write_space;
+	ctx->saved_destruct = sk->sk_destruct;
 	sk->sk_data_ready = espintcp_data_ready;
 	sk->sk_write_space = espintcp_write_space;
 	sk->sk_destruct = espintcp_destruct;


