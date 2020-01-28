Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828AF14BB03
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgA1Omc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbgA1OM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:12:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E440D2468F;
        Tue, 28 Jan 2020 14:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220776;
        bh=2IlUtJTJbKBJAHL7rr3Zmi4Neo47Xs2N+P5Hq5OxvbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p07V2McxgDv4Q2bBzeS2ZTFJUlLeCJTEeHk5ShGJAIRCz3O+ErpKZVKvkWGzfVlr9
         UqwJLSLiZZJk6DuABIhMUvC7FlpFex0tKoJBSJQ4ltikE3IHtU7hEOY/ezrQyVAzRU
         KY+abL/83XjCuVW1F9emU3nLZGsb9CJNpuJRABmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 141/183] net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
Date:   Tue, 28 Jan 2020 15:06:00 +0100
Message-Id: <20200128135843.829260915@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 25a584955f020d6ec499c513923fb220f3112d2b ]

The "priv->phy_interface" variable is an enum and in this context GCC
will treat it as unsigned so the error handling will never be
triggered.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 53b3c1a5851c3..9530ee12726f3 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1794,7 +1794,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 
 	priv->phy_interface = of_get_phy_mode(dn);
 	/* Default to GMII interface mode */
-	if (priv->phy_interface < 0)
+	if ((int)priv->phy_interface < 0)
 		priv->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	/* In the case of a fixed PHY, the DT node associated
-- 
2.20.1



