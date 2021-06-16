Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10ADD3AA013
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbhFPPoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhFPPmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:42:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D204261359;
        Wed, 16 Jun 2021 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857881;
        bh=tZaP+6/s9yOkjDybCztanFkilmzGz5z8nX72fuboOgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffpSje1DcEmn/0gWMvvuybvVTrUJ/invgROVAtNwGgdFQukNqvbMBnhGZ0UsGG6UR
         1XPjLjvzUnQLFR5E/lelAT9hlKiVpuKtQRWs934yuc9dsp0L/wXCHddaZYLfjoeXKt
         EDzomcd4H4KbqtFJlTir9RLPXjHO7kHKVww4p4sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 47/48] net: Return the correct errno code
Date:   Wed, 16 Jun 2021 17:33:57 +0200
Message-Id: <20210616152838.120881967@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index ddd15af3a283..210fc3b4d0d8 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -177,7 +177,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	if (kcmlen > stackbuf_size)
 		kcmsg_base = kcmsg = sock_kmalloc(sk, kcmlen, GFP_KERNEL);
 	if (kcmsg == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	/* Now copy them over neatly. */
 	memset(kcmsg, 0, kcmlen);
-- 
2.30.2



