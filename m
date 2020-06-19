Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A57200BBF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387734AbgFSOh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387721AbgFSOh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:37:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 486812070A;
        Fri, 19 Jun 2020 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577445;
        bh=o23A9+aPsDsblHRk7bpNwsM+EWR1GnGWmRJdBz1zUDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bfe4XjLGGX5Vg2fkuUNceGypa2GvqFi4PJ1o/Yy6dBHEx5DKFTtDcsEodvNsznJiK
         N7lt6/LqUxkQPA04HqXt7HIpRivMJ1Hm5M/zgW/tDbYjJbZMvzqYnXC2vG7DBFEctw
         JUzzfFJPInMedI1TWPpZQzo7q6HuwyCBFuqUPuL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 053/101] net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()
Date:   Fri, 19 Jun 2020 16:32:42 +0200
Message-Id: <20200619141616.837699856@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
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
index 9ba11d737753..f35597c44e3c 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -664,6 +664,8 @@ vmxnet3_get_rss(struct net_device *netdev, u32 *p, u8 *key, u8 *hfunc)
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



