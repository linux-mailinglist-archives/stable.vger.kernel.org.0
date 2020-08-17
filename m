Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83B1246A6E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgHQPfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbgHQPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D6982173E;
        Mon, 17 Aug 2020 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678533;
        bh=7eBUO9yRTxRtWqOM8/7Dm8BPgRXn/w2CD3hOKUBtd/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pXh1iMhj2CjTEWi54eLGNZnZLPe1uihW2sionIPJh6blgQ09TWEZN245vIEkX+cY
         nf/ZqwIFV/KmAWMV4BbCsWjRCiEjTBIIq4KB4Ebka07K1jMFXYoqHnukdMnWrT/b/S
         JWkqV2/3yJQ7FacujB/AO1o5kJ38z+fwHjiLxLAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 368/464] dpaa2-eth: Fix passing zero to PTR_ERR warning
Date:   Mon, 17 Aug 2020 17:15:21 +0200
Message-Id: <20200817143851.400030695@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 02afa9c66bb954c6959877c70d9e128dcf0adce7 ]

Fix smatch warning:

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2419
 alloc_channel() warn: passing zero to 'ERR_PTR'

setup_dpcon() should return ERR_PTR(err) instead of zero in error
handling case.

Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 89c43401f2889..a4b2b18009c1d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2207,7 +2207,7 @@ static struct fsl_mc_device *setup_dpcon(struct dpaa2_eth_priv *priv)
 free:
 	fsl_mc_object_free(dpcon);
 
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static void free_dpcon(struct dpaa2_eth_priv *priv,
@@ -2231,8 +2231,8 @@ alloc_channel(struct dpaa2_eth_priv *priv)
 		return NULL;
 
 	channel->dpcon = setup_dpcon(priv);
-	if (IS_ERR_OR_NULL(channel->dpcon)) {
-		err = PTR_ERR_OR_ZERO(channel->dpcon);
+	if (IS_ERR(channel->dpcon)) {
+		err = PTR_ERR(channel->dpcon);
 		goto err_setup;
 	}
 
-- 
2.25.1



