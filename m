Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8185E34C723
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhC2INB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231687AbhC2ILY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE8356196D;
        Mon, 29 Mar 2021 08:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005484;
        bh=5rv8c7kyMAxRJg+yYsF27054nnZTHkRMZa1i7Aw+PRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0V9t8lojbM4aFmuvn1YugToeln5A//XWDlAgO+l4Xz+r7E9Gt9fnPAnQpD0g9Zfn
         zclZsjwX+XHWaYVwTUYHWsK3FqVgCUuR7LYC3aDj2jUJySt5nKxVLsCFDdtOWQ/spp
         NFNJI8xPckdIAvxeIO5YL3fmlmCPOqaoRB4LPo6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/111] net: wan: fix error return code of uhdlc_init()
Date:   Mon, 29 Mar 2021 09:57:27 +0200
Message-Id: <20210329075615.828225746@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 62765d39553cfd1ad340124fe1e280450e8c89e2 ]

When priv->rx_skbuff or priv->tx_skbuff is NULL, no error return code of
uhdlc_init() is assigned.
To fix this bug, ret is assigned with -ENOMEM in these cases.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 4ad0a0c33d85..034eb6535ab7 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -204,14 +204,18 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 	priv->rx_skbuff = kcalloc(priv->rx_ring_size,
 				  sizeof(*priv->rx_skbuff),
 				  GFP_KERNEL);
-	if (!priv->rx_skbuff)
+	if (!priv->rx_skbuff) {
+		ret = -ENOMEM;
 		goto free_ucc_pram;
+	}
 
 	priv->tx_skbuff = kcalloc(priv->tx_ring_size,
 				  sizeof(*priv->tx_skbuff),
 				  GFP_KERNEL);
-	if (!priv->tx_skbuff)
+	if (!priv->tx_skbuff) {
+		ret = -ENOMEM;
 		goto free_rx_skbuff;
+	}
 
 	priv->skb_curtx = 0;
 	priv->skb_dirtytx = 0;
-- 
2.30.1



