Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6AFAF5685
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbfKHTJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391773AbfKHTJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DA12087E;
        Fri,  8 Nov 2019 19:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240159;
        bh=eyHWixG3v3PK5DC0NDn5uLPn+AVkLw4bBj/jynhUuSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnAp1qdEKui1eQlONLtgIsLtbpDCdFa7ORs142D8X70iIXRqxv+ReSUnvGjiayBWp
         Pg1yDdYlF1CRHVVh/L0+HHAWmfnw41iQZ/uTT/6M163hhcb6ABeQdOtNpLbEMPge/u
         /ZuH+d57GV2Fk0Bi3/OcqhU7uqbJUIbTQV4u5Xsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 108/140] net: phylink: Fix phylink_dbg() macro
Date:   Fri,  8 Nov 2019 19:50:36 +0100
Message-Id: <20191108174911.698389253@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 9d68db5092c5fac99fccfdeab3f04df0b27d1762 ]

The phylink_dbg() macro does not follow dynamic debug or defined(DEBUG)
and as a result, it spams the kernel log since a PR_DEBUG level is
currently used. Fix it to be defined appropriately whether
CONFIG_DYNAMIC_DEBUG or defined(DEBUG) are set.

Fixes: 17091180b152 ("net: phylink: Add phylink_{printk, err, warn, info, dbg} macros")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -87,8 +87,24 @@ struct phylink {
 	phylink_printk(KERN_WARNING, pl, fmt, ##__VA_ARGS__)
 #define phylink_info(pl, fmt, ...) \
 	phylink_printk(KERN_INFO, pl, fmt, ##__VA_ARGS__)
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define phylink_dbg(pl, fmt, ...) \
+do {									\
+	if ((pl)->config->type == PHYLINK_NETDEV)			\
+		netdev_dbg((pl)->netdev, fmt, ##__VA_ARGS__);		\
+	else if ((pl)->config->type == PHYLINK_DEV)			\
+		dev_dbg((pl)->dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+#elif defined(DEBUG)
+#define phylink_dbg(pl, fmt, ...)					\
 	phylink_printk(KERN_DEBUG, pl, fmt, ##__VA_ARGS__)
+#else
+#define phylink_dbg(pl, fmt, ...)					\
+({									\
+	if (0)								\
+		phylink_printk(KERN_DEBUG, pl, fmt, ##__VA_ARGS__);	\
+})
+#endif
 
 /**
  * phylink_set_port_modes() - set the port type modes in the ethtool mask


