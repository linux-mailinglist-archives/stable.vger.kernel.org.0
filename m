Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FB3CA246
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbfJCQDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbfJCQDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:03:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A17C621848;
        Thu,  3 Oct 2019 16:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118612;
        bh=3D7JlMLXuSw8WycHbvY81UgjIJZwL4MmJMz3WIxlpkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2HMdVxIJEe5NqjH4OlzsI+ymdgqQryVXIvxo9+V9WSNyaoKzdaxDrukYM6PYXSb1
         eBeraSGiUuJqQmogNlN2tmiX1uxJ1ZQRY0sEBWonCkdlXyfhQ6ZhT3enxUyjN9Emyg
         6qAeOz+AKXHSfAajNCdxRTzljDDPA8PaC7HkYvVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ori Nimron <orinimron123@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 038/129] nfc: enforce CAP_NET_RAW for raw sockets
Date:   Thu,  3 Oct 2019 17:52:41 +0200
Message-Id: <20191003154335.275063316@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ori Nimron <orinimron123@gmail.com>

[ Upstream commit 3a359798b176183ef09efb7a3dc59abad1cc7104 ]

When creating a raw AF_NFC socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -1011,10 +1011,13 @@ static int llcp_sock_create(struct net *
 	    sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
 
-	if (sock->type == SOCK_RAW)
+	if (sock->type == SOCK_RAW) {
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		sock->ops = &llcp_rawsock_ops;
-	else
+	} else {
 		sock->ops = &llcp_sock_ops;
+	}
 
 	sk = nfc_llcp_sock_alloc(sock, sock->type, GFP_ATOMIC, kern);
 	if (sk == NULL)


