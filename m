Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6211B05B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbfLKPWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731800AbfLKPWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F47A2073D;
        Wed, 11 Dec 2019 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077722;
        bh=MXdq6v4VdAeAT1IaLq5MUg/YDKhiJOWxehovXYVbj9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCqu6FmYmoYh9lXvqt2mQnK9RbMhr4Ki73s+vd9cNAJhiHDgclTlyeDiLuE48zYMU
         COp2bvwTXa9PmJ0CauWfLgXQ5lNslUzFhONM2u0NRyw25x1jkjaxEPLouGLDoYnDWc
         EkBifJwTHl7xbMDeaQPo3XVp1w19V6BPbaQRgcNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/243] net/x25: fix null_x25_address handling
Date:   Wed, 11 Dec 2019 16:05:06 +0100
Message-Id: <20191211150348.887008369@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 06137619f061f498c2924f6543fa45b7d39f0501 ]

o x25_find_listener(): the compare for the null_x25_address was wrong.
   We have to check the x25_addr of the listener socket instead of the
   x25_addr of the incomming call.

 o x25_bind(): it was not possible to bind a socket to null_x25_address

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3150648206b68..20a511398389d 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -288,7 +288,7 @@ static struct sock *x25_find_listener(struct x25_address *addr,
 	sk_for_each(s, &x25_list)
 		if ((!strcmp(addr->x25_addr,
 			x25_sk(s)->source_addr.x25_addr) ||
-				!strcmp(addr->x25_addr,
+				!strcmp(x25_sk(s)->source_addr.x25_addr,
 					null_x25_address.x25_addr)) &&
 					s->sk_state == TCP_LISTEN) {
 			/*
@@ -685,11 +685,15 @@ static int x25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	}
 
-	len = strlen(addr->sx25_addr.x25_addr);
-	for (i = 0; i < len; i++) {
-		if (!isdigit(addr->sx25_addr.x25_addr[i])) {
-			rc = -EINVAL;
-			goto out;
+	/* check for the null_x25_address */
+	if (strcmp(addr->sx25_addr.x25_addr, null_x25_address.x25_addr)) {
+
+		len = strlen(addr->sx25_addr.x25_addr);
+		for (i = 0; i < len; i++) {
+			if (!isdigit(addr->sx25_addr.x25_addr[i])) {
+				rc = -EINVAL;
+				goto out;
+			}
 		}
 	}
 
-- 
2.20.1



