Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCEE126CE6
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfLSSnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbfLSSnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F2024679;
        Thu, 19 Dec 2019 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781021;
        bh=WDAv1/Hs3vgVMKQa4Q1D+5K3JxAHNBT6LqJMOQRfuIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q9qADI8a1r+w9tFqiHf/szKt2gi7pU1lQpHQsrbHKsjDHPcoauvnAvRw4J49xWiV
         Ow8vdU2F0epbNmM4qjkkB4L1PYJ7zt9jnOUIaI/1ftjci832hr8vhn7jZzqyDMF4vI
         SIZ1zfi71boXhhAfj7cM6YsR1AaG9fDsz7gTDum4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/199] net/x25: fix null_x25_address handling
Date:   Thu, 19 Dec 2019 19:32:13 +0100
Message-Id: <20191219183217.788248478@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
index ebd9c5f50a571..6c2560f3f95bd 100644
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
@@ -684,11 +684,15 @@ static int x25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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



