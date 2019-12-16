Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 754D3121951
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfLPSsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfLPRyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2034620733;
        Mon, 16 Dec 2019 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518842;
        bh=nKlEQuyx9OU3F7MpnfXzCGoKkM3bM6UtxtePuYeJZ3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcF4x6KjuSWjfBJAHFV2wngJ+O0DUT089irvhIx4uTpfJslo330DZ/VG1Uf2iqHjh
         00GbhtKIu3lfhdS+dtuXELOyOBYF/0hEYqrBDgPSfbocrt8+v6ru2vobiaDqh59pji
         brRagzHKqrWYZCTT3FPqADGZlMWiT0wOcs2M8B7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/267] net/x25: fix null_x25_address handling
Date:   Mon, 16 Dec 2019 18:46:55 +0100
Message-Id: <20191216174857.933627671@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index 6e7ad4c6f83c8..a156b6dc3a724 100644
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



