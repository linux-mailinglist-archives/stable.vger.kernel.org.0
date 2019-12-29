Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6691012C9B3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbfL2SNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728563AbfL2R2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:28:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82AA20722;
        Sun, 29 Dec 2019 17:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640498;
        bh=A+V3kOd7aM3a0kWmJvDD1+pxWSgMnrzbg/E6ybE+yqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBq7nwYR7XRvgOHCFffCxwQuKjNrZQQhi1QzVp2hQZCD1QmJKu22+VeAwyITno3ND
         oi19bIB232L9LbnWQ60o7CBrJZq2ayJ9k+mkEL9P41GDAM4k6iPs6bLmkpzYbtZK9N
         ivCrdkrad+6aHssrtmEiQ/U4iGbukUX7kn0cqCLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 003/219] mod_devicetable: fix PHY module format
Date:   Sun, 29 Dec 2019 18:16:45 +0100
Message-Id: <20191229162509.633370446@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit d2ed49cf6c13e379c5819aa5ac20e1f9674ebc89 ]

When a PHY is probed, if the top bit is set, we end up requesting a
module with the string "mdio:-10101110000000100101000101010001" -
the top bit is printed to a signed -1 value. This leads to the module
not being loaded.

Fix the module format string and the macro generating the values for
it to ensure that we only print unsigned types and the top bit is
always 0/1. We correctly end up with
"mdio:10101110000000100101000101010001".

Fixes: 8626d3b43280 ("phylib: Support phy module autoloading")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mod_devicetable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -551,9 +551,9 @@ struct platform_device_id {
 #define MDIO_NAME_SIZE		32
 #define MDIO_MODULE_PREFIX	"mdio:"
 
-#define MDIO_ID_FMT "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d"
+#define MDIO_ID_FMT "%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u"
 #define MDIO_ID_ARGS(_id) \
-	(_id)>>31, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1,	\
+	((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1, \
 	((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, ((_id)>>24) & 1, \
 	((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, ((_id)>>20) & 1, \
 	((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, ((_id)>>16) & 1, \


