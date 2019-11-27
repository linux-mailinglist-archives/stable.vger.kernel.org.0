Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E592810B8EC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfK0UsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:48:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbfK0UsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:48:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37BA421845;
        Wed, 27 Nov 2019 20:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887688;
        bh=wm40pxxZ59JGzonob8Ges0kmf+882DncGH3d04jzJGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foW6wZxlCBQcKpIJy1Zeb2EnhBZ3dcRfi5rv/4FaUR/XC83xlWJhe8BSX1UZg73++
         vOur9qImODc+sNeg/MxJCa7SkdnpVRM6wOZhtwsOemzuFxPuDKtFJB/6uaYLZXCKHr
         HHA8owrhgK9dgV1ro9GuMLhyI6VNw0Vq4qtRkMw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyeongdon Kim <kyeongdon.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 057/211] net: fix warning in af_unix
Date:   Wed, 27 Nov 2019 21:29:50 +0100
Message-Id: <20191127203059.494818272@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyeongdon Kim <kyeongdon.kim@lge.com>

[ Upstream commit 33c4368ee2589c165aebd8d388cbd91e9adb9688 ]

This fixes the "'hash' may be used uninitialized in this function"

net/unix/af_unix.c:1041:20: warning: 'hash' may be used uninitialized in this function [-Wmaybe-uninitialized]
  addr->hash = hash ^ sk->sk_type;

Signed-off-by: Kyeongdon Kim <kyeongdon.kim@lge.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4de9dfd14d09d..99f581a61cfac 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -225,6 +225,8 @@ static inline void unix_release_addr(struct unix_address *addr)
 
 static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
 {
+	*hashp = 0;
+
 	if (len <= sizeof(short) || len > sizeof(*sunaddr))
 		return -EINVAL;
 	if (!sunaddr || sunaddr->sun_family != AF_UNIX)
-- 
2.20.1



