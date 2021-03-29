Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B03E34C61B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhC2IE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhC2IEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:04:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21F0C61938;
        Mon, 29 Mar 2021 08:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005062;
        bh=fyZ1ZSaaU2VAVPJMoW4W66mZdGkVec3swcOb/IRYutE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXJsXwbMVsaE7Fz/ghHDzlxmGVbjaxrgXD+/ucCMeOAITJxsYI5ZKT30nRb1YtXjO
         YmwIv21SRu/fb0tdT7xORyAEPx9iIZigVbT7ZGvd1G90OkZh+8uMfKmpN66IZL6IKf
         MJsHIOREuxC9rq0jW27rywfxpnxtShJ1xfba9Gck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/59] net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
Date:   Mon, 29 Mar 2021 09:57:52 +0200
Message-Id: <20210329075609.301888066@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 143c253f42bad20357e7e4432087aca747c43384 ]

When hns_assemble_skb() returns NULL to skb, no error return code of
hns_nic_clear_all_rx_fetch() is assigned.
To fix this bug, ret is assigned with -ENOMEM in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index af832929ae28..5ddc09e9b5a6 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1812,8 +1812,10 @@ static int hns_nic_clear_all_rx_fetch(struct net_device *ndev)
 			for (j = 0; j < fetch_num; j++) {
 				/* alloc one skb and init */
 				skb = hns_assemble_skb(ndev);
-				if (!skb)
+				if (!skb) {
+					ret = -ENOMEM;
 					goto out;
+				}
 				rd = &tx_ring_data(priv, skb->queue_mapping);
 				hns_nic_net_xmit_hw(ndev, skb, rd);
 
-- 
2.30.1



