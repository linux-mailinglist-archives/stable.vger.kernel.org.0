Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60674148326
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404635AbgAXLdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404620AbgAXLdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:33:45 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A699C206D4;
        Fri, 24 Jan 2020 11:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865624;
        bh=8qqQxDrZw419BxuS8vtAzVOtgZqvRsC1xgPlPaca5XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5T24KSfBwkodedjKd3H5y/ELh2UorLmoQiip76hedKmCnSUiBxRO4qjaxGxsxWe3
         T9IOnZvvwTM6EZEVell3PGXRaiJkYDWdRtj9Vc5H+97xmG4yf+9ee3XK921JhvSOy2
         zSgAVz19TBAFOWgZpV35YSLLIL7OisDeNp+6Bbz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 577/639] net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
Date:   Fri, 24 Jan 2020 10:32:27 +0100
Message-Id: <20200124093201.743119776@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index 0bdbc72605e1f..49aa3b5ea57cc 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2470,7 +2470,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 
 	priv->phy_interface = of_get_phy_mode(dn);
 	/* Default to GMII interface mode */
-	if (priv->phy_interface < 0)
+	if ((int)priv->phy_interface < 0)
 		priv->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	/* In the case of a fixed PHY, the DT node associated
-- 
2.20.1



