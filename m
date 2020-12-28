Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE62E3883
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgL1NLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:11:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731552AbgL1NLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:11:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F2DE206ED;
        Mon, 28 Dec 2020 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161027;
        bh=ldrXQ9oTcDqf9SYxNtJmPisupfTA8g1oDRT7fgObFBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqXB0Vzh5t9AOgkHmr6wHEn5jt3Gf2Wd1pb2RIlYqa1ZlCEXt2RJlp8/qx3AvOMJO
         NWCrly5+SNNjfzN9DNcJ43CDQs/wP0pULcT24fzzFLmX27UW1Mlrr447LwZR/18riC
         a5IMF9mxB6WBbBvWymU2mgnFgDXbdE1iVnv/HX7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/242] vxlan: Copy needed_tailroom from lowerdev
Date:   Mon, 28 Dec 2020 13:47:30 +0100
Message-Id: <20201228124906.896981188@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit a5e74021e84bb5eadf760aaf2c583304f02269be ]

While vxlan doesn't need any extra tailroom, the lowerdev might need it. In
that case, copy it over to reduce the chance for additional (re)allocations
in the transmit path.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Link: https://lore.kernel.org/r/20201126125247.1047977-2-sven@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index c21f28840f05b..94a9add2fc878 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3186,6 +3186,8 @@ static void vxlan_config_apply(struct net_device *dev,
 		needed_headroom = lowerdev->hard_header_len;
 		needed_headroom += lowerdev->needed_headroom;
 
+		dev->needed_tailroom = lowerdev->needed_tailroom;
+
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
 		if (max_mtu < ETH_MIN_MTU)
-- 
2.27.0



