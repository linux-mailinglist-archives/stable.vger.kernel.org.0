Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C237C586
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhELPlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235794AbhELPgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 055FB61C3A;
        Wed, 12 May 2021 15:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832685;
        bh=tqYKzZCh4SWAyuqWLZ6JZo96wNFd1JHdJX52HyHsvAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNFpZ9dUGqcVvYyUEXGUS7+JS2GLOH7Hg32fOXCtB5xJodNRY4yVhy+EjEchLYeuv
         9CEe0HDRujR/swSPYsFIC+5P6b9O66KyCbak7JOymlR9wxfdMkzhd1rdSM7lQKAtTZ
         hB5nYcaoyjhh+R0v6YHNTH1X1gqZ96is9/hfTL/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/530] net/tipc: fix missing destroy_workqueue() on error in tipc_crypto_start()
Date:   Wed, 12 May 2021 16:48:12 +0200
Message-Id: <20210512144832.327381466@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ac1db7acea67777be1ba86e36e058c479eab6508 ]

Add the missing destroy_workqueue() before return from
tipc_crypto_start() in the error handling case.

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 86eb6d679225..2301b66280de 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1485,6 +1485,8 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	/* Allocate statistic structure */
 	c->stats = alloc_percpu_gfp(struct tipc_crypto_stats, GFP_ATOMIC);
 	if (!c->stats) {
+		if (c->wq)
+			destroy_workqueue(c->wq);
 		kfree_sensitive(c);
 		return -ENOMEM;
 	}
-- 
2.30.2



