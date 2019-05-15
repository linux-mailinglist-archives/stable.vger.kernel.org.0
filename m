Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DFD1EFC7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfEOLgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730842AbfEOLci (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:32:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2812053B;
        Wed, 15 May 2019 11:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919957;
        bh=tNIhxY8N0aSxd42ZQzJBvBfueaEFS+wqtYU5w+0ZFnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMzkXaTKUUjmqpFsOMW8noY3oSmXK1FfuBP8Mnn0tsKpJDfDpUuHjgk83CyYRQoXx
         TaU8lnpiOjmRJ26YRUr8rh4KmP/9ULGO1fmCz4QTkB/NBcfIsJW1I8RFIcbEnSqa8Y
         +UULtyQOo7Dpe7lIHy8fXbiwJmar8Dhe7UVgXnKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 20/46] net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filtering
Date:   Wed, 15 May 2019 12:56:44 +0200
Message-Id: <20190515090623.902014753@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit d4c26eb6e721683a0f93e346ce55bc8dc3cbb175 ]

When adding more MAC addresses to a dwmac-sun8i interface, the device goes
directly in promiscuous mode.
This is due to IFF_UNICAST_FLT missing flag.

So since the hardware support unicast filtering, let's add IFF_UNICAST_FLT.

Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1015,6 +1015,8 @@ static struct mac_device_info *sun8i_dwm
 	mac->mac = &sun8i_dwmac_ops;
 	mac->dma = &sun8i_dwmac_dma_ops;
 
+	priv->dev->priv_flags |= IFF_UNICAST_FLT;
+
 	/* The loopback bit seems to be re-set when link change
 	 * Simply mask it each time
 	 * Speed 10/100/1000 are set in BIT(2)/BIT(3)


