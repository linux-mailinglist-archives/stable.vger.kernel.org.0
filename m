Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED2628AC5
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388955AbfEWTqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbfEWTOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:14:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805C9217D7;
        Thu, 23 May 2019 19:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638863;
        bh=erWqDX8SpUwJR1ygf9C0eCHvcngG2wRO1gFt5XSuHpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhsBkUlYa6xoN4ZL7cMeTa/XEd1Umaz9nA99RewpxoinC0byf41AsdWNAx/21BnOl
         yWRGIBSiDPhOShUCd7vx8xSqAlI9SqkwXxCTERbfCmorfcxB9kasOCosEnfI3HFiLf
         ylJQcBVgrSZuMmLDQ02JDsbxV78PZhIkesQhnxBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 003/114] net: Always descend into dsa/
Date:   Thu, 23 May 2019 21:05:02 +0200
Message-Id: <20190523181731.776718888@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 0fe9f173d6cda95874edeb413b1fa9907b5ae830 ]

Jiri reported that with a kernel built with CONFIG_FIXED_PHY=y,
CONFIG_NET_DSA=m and CONFIG_NET_DSA_LOOP=m, we would not get to a
functional state where the mock-up driver is registered. Turns out that
we are not descending into drivers/net/dsa/ unconditionally, and we
won't be able to link-in dsa_loop_bdinfo.o which does the actual mock-up
mdio device registration.

Reported-by: Jiri Pirko <jiri@resnulli.us>
Fixes: 40013ff20b1b ("net: dsa: Fix functional dsa-loop dependency on FIXED_PHY")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Tested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -40,7 +40,7 @@ obj-$(CONFIG_ARCNET) += arcnet/
 obj-$(CONFIG_DEV_APPLETALK) += appletalk/
 obj-$(CONFIG_CAIF) += caif/
 obj-$(CONFIG_CAN) += can/
-obj-$(CONFIG_NET_DSA) += dsa/
+obj-y += dsa/
 obj-$(CONFIG_ETHERNET) += ethernet/
 obj-$(CONFIG_FDDI) += fddi/
 obj-$(CONFIG_HIPPI) += hippi/


