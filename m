Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AADA3A60B9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhFNKhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhFNKf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:35:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB75C613E9;
        Mon, 14 Jun 2021 10:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666756;
        bh=sYYFiaSa6jR7mtASzMjv1fOrQuqDdaSGCKubgqmYfKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anceQe/pH5HlDWhOvu0VQbl66LVOaMkBMTdSRJbvlYEvY6kQqoejauLeIJkukzypd
         Xq2rhhHFj6B0x8DgrSM3v16UoYG1ulv6ns8hZqnb/18qwx2OMYEJ4f8HHOdZfm57ot
         hzdk0LkWMelMlMehV66WnyGtiTlxBXn/FJEfz2dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/49] net/nfc/rawsock.c: fix a permission check bug
Date:   Mon, 14 Jun 2021 12:26:55 +0200
Message-Id: <20210614102641.937122920@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
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
index 57a07ab80d92..bdc72737fe24 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -345,7 +345,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.30.2



