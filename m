Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4E3148328
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404646AbgAXLdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404645AbgAXLds (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:33:48 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72927206D4;
        Fri, 24 Jan 2020 11:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865628;
        bh=kTDjMHbYhLUz7Dh6mwAS7IYkboiSNJNavyi6X4sZN78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2J/A78JdZxg+yAsk15ppA63YkpwWXallNM7mlHuNLDXqM+3YTI/jdcU1Xef64VJQH
         dXJwJV4oFI95TrBGoX79q9GwMbkGmfbQtHN2CzJsWA392rV+KXxebASJKw4F3ZZgJO
         lAFvCbh1eZwCpEtP1gocqSivPANunNgm4yJLfqVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 578/639] net: netsec: Fix signedness bug in netsec_probe()
Date:   Fri, 24 Jan 2020 10:32:28 +0100
Message-Id: <20200124093201.860598934@linuxfoundation.org>
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

[ Upstream commit bd55f8ddbc437c225391ca8f487e7ec10243c4cc ]

The "priv->phy_interface" variable is an enum and in this context GCC
will treat it as an unsigned int so the error handling is never
triggered.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index d9d0d03e4ce79..027367b9cc480 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1604,7 +1604,7 @@ static int netsec_probe(struct platform_device *pdev)
 			   NETIF_MSG_LINK | NETIF_MSG_PROBE;
 
 	priv->phy_interface = device_get_phy_mode(&pdev->dev);
-	if (priv->phy_interface < 0) {
+	if ((int)priv->phy_interface < 0) {
 		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
 		ret = -ENODEV;
 		goto free_ndev;
-- 
2.20.1



