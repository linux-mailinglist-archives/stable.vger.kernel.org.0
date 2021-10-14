Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C184B42DD5F
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbhJNPGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhJNPFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21A5161222;
        Thu, 14 Oct 2021 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223666;
        bh=fEl8BJgrezmtg7ruCQ4UqWxbxPp54n7YB32+vPu8PqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbwFp3+uVn5I1QI4IHZgL6AoqADRGRuBQgRm+IvL7RfvDHJBlMPlxQSYJR9z4bJb7
         QjnuAemccZZBGBmnPP5VUQwG55M2CgBMeqvW6s7IU0jEJyERTCVAXwA/eSis5EKyB0
         EiUWWsRMTe4yI5+Hqr3HtoB5d82dkqq0cpgvq6bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 20/30] net: bgmac-platform: handle mac-address deferral
Date:   Thu, 14 Oct 2021 16:54:25 +0200
Message-Id: <20211014145210.187922037@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit 763716a55cb1f480ffe1a9702e6b5d9ea1a80a24 ]

This patch is a replication of Christian Lamparter's "net: bgmac-bcma:
handle deferred probe error due to mac-address" patch for the
bgmac-platform driver [1].

As is the case with the bgmac-bcma driver, this change is to cover the
scenario where the MAC address cannot yet be discovered due to reliance
on an nvmem provider which is yet to be instantiated, resulting in a
random address being assigned that has to be manually overridden.

[1] https://lore.kernel.org/netdev/20210919115725.29064-1-chunkeey@gmail.com

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac-platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index 4ab5bf64d353..df8ff839cc62 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -192,6 +192,9 @@ static int bgmac_probe(struct platform_device *pdev)
 	bgmac->dma_dev = &pdev->dev;
 
 	ret = of_get_mac_address(np, bgmac->net_dev->dev_addr);
+	if (ret == -EPROBE_DEFER)
+		return ret;
+
 	if (ret)
 		dev_warn(&pdev->dev,
 			 "MAC address not present in device tree\n");
-- 
2.33.0



