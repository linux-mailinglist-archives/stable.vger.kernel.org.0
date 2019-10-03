Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11DCA47E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbfJCQZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388107AbfJCQZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:25:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90077215EA;
        Thu,  3 Oct 2019 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119914;
        bh=TVLXiu/Wu0XFZ4nGnunWANHINoWqCjOOWL8M5FUu7eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GohcpjuP5umf4oce/iX+G4yosDCzTI3WBflpViQY94tQ2Xm0j3jBDaXkXUEcjrjvF
         /4pEhMg6f8uLE3vcF5l34c64yhNfgFPJeFkm4mMxAiU35oFeWk0aYtwSrvkDB1b8Xi
         fd5soagXf1F575XzuZQN+1SZzCfFC2st05FsRpAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ori Nimron <orinimron123@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 028/313] mISDN: enforce CAP_NET_RAW for raw sockets
Date:   Thu,  3 Oct 2019 17:50:06 +0200
Message-Id: <20191003154536.107367952@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ori Nimron <orinimron123@gmail.com>

[ Upstream commit b91ee4aa2a2199ba4d4650706c272985a5a32d80 ]

When creating a raw AF_ISDN socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/mISDN/socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -754,6 +754,8 @@ base_sock_create(struct net *net, struct
 
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
 
 	sk = sk_alloc(net, PF_ISDN, GFP_KERNEL, &mISDN_proto, kern);
 	if (!sk)


