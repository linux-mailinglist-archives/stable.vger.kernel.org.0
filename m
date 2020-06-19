Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023932015E8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390404AbgFSQYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390396AbgFSO63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:58:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8194121852;
        Fri, 19 Jun 2020 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578709;
        bh=kzpiE8BnnJAqi9y9l9F3C8tiBJxNS1qKQy7aQb0V88Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAZgBkP9cpZK7/s0MlXfp848D6IyyAu72HLLaZNBZtEEC+qhGh3eQlA9lLukEj2KQ
         P6koLkEizxV1Yh9taQ/Zibw8Gsp72pwp1ohktbW3BKwsb7/qT4vyt67Uoxo4hk+An8
         7h77Bq4IyQfJb/c2e8HnXAI8AOlictzNGd7jmCJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/267] net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()
Date:   Fri, 19 Jun 2020 16:31:44 +0200
Message-Id: <20200619141654.554894031@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 3e1c6846b9e108740ef8a37be80314053f5dd52a ]

The value adapter->rss_conf is stored in DMA memory, and it is assigned
to rssConf, so rssConf->indTableSize can be modified at anytime by
malicious hardware. Because rssConf->indTableSize is assigned to n,
buffer overflow may occur when the code "rssConf->indTable[n]" is
executed.

To fix this possible bug, n is checked after being used.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 559db051a500..88d18ab83e54 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -692,6 +692,8 @@ vmxnet3_get_rss(struct net_device *netdev, u32 *p, u8 *key, u8 *hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
 	if (!p)
 		return 0;
+	if (n > UPT1_RSS_MAX_IND_TABLE_SIZE)
+		return 0;
 	while (n--)
 		p[n] = rssConf->indTable[n];
 	return 0;
-- 
2.25.1



