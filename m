Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538C63A6288
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhFNLBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234907AbhFNK7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4128261628;
        Mon, 14 Jun 2021 10:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667344;
        bh=GuPFsSuib4mnjhLtL2ddfg1ENJrgqkvaZ4q0gRNk1Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=En/h0YyeI/mQtRWk4TMcuf1Rpmf1iUm6qPsj3pBhdqSj+ubFDMFsseMktUmKQz22y
         ZhJi26h0g3mGA2u/Lb1bBlNeiNz8CQU6aSC0SCuykBbnj7fRwUIQocTvRl1WYlsCAP
         nL7aLk3doqq/rbdZWRnuav7HLe0jOIL/z1geAV7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/131] net/nfc/rawsock.c: fix a permission check bug
Date:   Mon, 14 Jun 2021 12:26:08 +0200
Message-Id: <20210614102653.218539315@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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



