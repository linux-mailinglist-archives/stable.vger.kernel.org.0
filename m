Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BE510BD55
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfK0U6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfK0U6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C79215B2;
        Wed, 27 Nov 2019 20:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888316;
        bh=kAqtKWCDZXsE9YhDOOmXD4HFJ72pPiA6mcNcJzI0bfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOwlJ3wzz8UJ++fmE886uAOT5krvZlvTfkvYykiWjjE28M+ZwNnFfAPeMi8a6MAzw
         QInT732MFL6PCEmyl63ZjTMR0IK5OSmbfCAhrnRHT92TEeOY2PavjImQ5W2zdVPNE5
         ea2SIi9HaRsNxelE/7LrcXVjTwJEvSmeBVGWnv1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyeongdon Kim <kyeongdon.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/306] net: fix warning in af_unix
Date:   Wed, 27 Nov 2019 21:28:56 +0100
Message-Id: <20191127203121.210938544@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index 231b6c032d2c3..d2d6ff0c6265d 100644
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



