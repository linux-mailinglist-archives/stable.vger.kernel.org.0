Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCAE3A6374
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhFNLNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233959AbhFNLLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E0CC61455;
        Mon, 14 Jun 2021 10:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667676;
        bh=GuPFsSuib4mnjhLtL2ddfg1ENJrgqkvaZ4q0gRNk1Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjkbMj2wTD8KT5VGo7WzlhIqaI70inWv9V/t2g/nZF1RmACWHMa7W16oQUbodOQD3
         7DK5ZLsf5g3WfG72U8sf2ThQjMT7PZXKSWytdP51rKknPFlJqwM+reOK4qGKzheJ2P
         qLL9yIHcQOdNiwMuPBecV6qQ4Zp2PHjhCGbPP8eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 009/173] net/nfc/rawsock.c: fix a permission check bug
Date:   Mon, 14 Jun 2021 12:25:41 +0200
Message-Id: <20210614102658.469560353@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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
index 9c7eb8455ba8..5f1d438a0a23 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -329,7 +329,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.30.2



