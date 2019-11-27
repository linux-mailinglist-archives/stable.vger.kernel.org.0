Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAAF10BFBB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfK0Vpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfK0UfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A5E72154A;
        Wed, 27 Nov 2019 20:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886916;
        bh=H6bctPRfq8XqJuzYNECQWMiThWRjYOGOSX2ux+jZzI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OY2U8Rd0Plq9Pl8zWWOaiNR+tfjOcTvXsgsaXBh70VNiFnA4vPHTEW+ovEs5u87Id
         WESrRGGhystIPcIQVu92FHzPI3QE5N1gORcXJo2icM3BpugPe8yZHtZ8L9OgES+2CW
         HiJdCOEN+u03aSvITmGLWlKP5y0Z029Des/5tcNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyeongdon Kim <kyeongdon.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 042/132] net: fix warning in af_unix
Date:   Wed, 27 Nov 2019 21:30:33 +0100
Message-Id: <20191127202937.623909833@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
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
index b1a72615fdc30..b5e2ef242efe7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -224,6 +224,8 @@ static inline void unix_release_addr(struct unix_address *addr)
 
 static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
 {
+	*hashp = 0;
+
 	if (len <= sizeof(short) || len > sizeof(*sunaddr))
 		return -EINVAL;
 	if (!sunaddr || sunaddr->sun_family != AF_UNIX)
-- 
2.20.1



