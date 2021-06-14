Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D31A3A61C4
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhFNKvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234208AbhFNKtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD7C6145D;
        Mon, 14 Jun 2021 10:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667085;
        bh=+BrbsSpcV0YHKhcT8tRvGzL/1htIb260PmyXA1JnjVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zk3fr0BqHDbdKnFyMO3qojjtU4v1FnS9UcB54Xc2sBUEPuMQw/ot0qgR8yjo2QX+8
         vNKNv2h/2g8AYTlY98oNuRgyND5grvw7Xiv0pASWrg88haMo3UTDwqNAj3RD6cRLq2
         Z+pyMu0xmrFXNwGAt14UI19WqB3QKOcI8Dvxq0uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/84] net/nfc/rawsock.c: fix a permission check bug
Date:   Mon, 14 Jun 2021 12:26:42 +0200
Message-Id: <20210614102646.487490190@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeimon <jjjinmeng.zhou@gmail.com>

[ Upstream commit 8ab78863e9eff11910e1ac8bcf478060c29b379e ]

The function rawsock_create() calls a privileged function sk_alloc(), which requires a ns-aware check to check net->user_ns, i.e., ns_capable(). However, the original code checks the init_user_ns using capable(). So we replace the capable() with ns_capable().

Signed-off-by: Jeimon <jjjinmeng.zhou@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/rawsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 23d5e56306a4..8d649f4aee79 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -333,7 +333,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.30.2



