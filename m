Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43D34C8D2
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhC2IYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232411AbhC2IHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 645E161976;
        Mon, 29 Mar 2021 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005236;
        bh=vrO7KwDpMMsX+cWn8BeQo8ANif15unkmHNpJ8fJCPBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+e9XyM5gC6YXMsWRtNWWhHMW7/o+b9QKCpAa70l0Qt/uN8LKuhH/+U9cmg5hLhlJ
         zfyPNSjaRCEvcHQS/cBduCy4BsJBQxqRRYB6nJ/btJBYXkBeNUgVz1MsaXipL+ryh2
         vLCMYFmkCgE3G24Q7I/ZlGfDD/YCcAYzZuWS00H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/72] net: wan: fix error return code of uhdlc_init()
Date:   Mon, 29 Mar 2021 09:57:50 +0200
Message-Id: <20210329075610.749731111@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
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
index 9ab04ef532f3..5df6e85e7ccb 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -201,14 +201,18 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
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



