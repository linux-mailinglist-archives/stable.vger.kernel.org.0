Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA493CA82A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhGOS6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241536AbhGOS5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07FC8613D1;
        Thu, 15 Jul 2021 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375301;
        bh=d09ir3kgb9xtU564t4rO0NluCjTTcHfF8TAcNZAL3Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPKBG7pwFQtoy7MEuA7otREsKLg/0G2ZVwu5dswSrr+nqwqVnhvXar6hKwQ50LVtj
         CCdXj1zLgAgjGEQ8WRjBEroOJZlojLsCEX0c9laofkg8XtWD0we3qioI9TzVsnwAiv
         B7yH3xGuJbGA1ulhKe0QXXUwjmKmZx7gAoUdAZ9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 022/242] net: mdio: provide shim implementation of devm_of_mdiobus_register
Date:   Thu, 15 Jul 2021 20:36:24 +0200
Message-Id: <20210715182555.669787927@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 86544c3de6a2185409c5a3d02f674ea223a14217 ]

Similar to the way in which of_mdiobus_register() has a fallback to the
non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
a shim for the device-managed devm_of_mdiobus_register() which calls
devm_mdiobus_register() and discards the struct device_node *.

In particular, this solves a build issue with the qca8k DSA driver which
uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of_mdio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 2b05e7f7c238..da633d34ab86 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -72,6 +72,13 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
 	return mdiobus_register(mdio);
 }
 
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return devm_mdiobus_register(dev, mdio);
+}
+
 static inline struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
 	return NULL;
-- 
2.30.2



