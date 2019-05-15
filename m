Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F091F134
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbfEOLWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbfEOLWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2431921734;
        Wed, 15 May 2019 11:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919322;
        bh=sDiO5l3AAV6W+m0k+TpDaXZsjbUGzwUgt7IamaM5LEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POVofSZQYFNoSDoUHWpeYqeULhvXCQxBSBTOYUBX0J6A9eqIjKB2Ba8BUtBXE53gC
         Thk0VPaFtyfxOePx15jqi5i7HFQEFb8YJutjqeVVUtypmP2s9Vm4qNWYBFQ1/4u0Nc
         +QJPqkABvz2hK3VZqK9GgqPX27R3R8a6SDzFAWOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/113] mISDN: Check address length before reading address family
Date:   Wed, 15 May 2019 12:55:21 +0200
Message-Id: <20190515090655.839119619@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 238ffdc49ef98b15819cfd5e3fb23194e3ea3d39 ]

KMSAN will complain if valid address length passed to bind() is shorter
than sizeof("struct sockaddr_mISDN"->family) bytes.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 18c0a1281914f..b2abc44fa5cb8 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -711,10 +711,10 @@ base_sock_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	struct sock *sk = sock->sk;
 	int err = 0;
 
-	if (!maddr || maddr->family != AF_ISDN)
+	if (addr_len < sizeof(struct sockaddr_mISDN))
 		return -EINVAL;
 
-	if (addr_len < sizeof(struct sockaddr_mISDN))
+	if (!maddr || maddr->family != AF_ISDN)
 		return -EINVAL;
 
 	lock_sock(sk);
-- 
2.20.1



