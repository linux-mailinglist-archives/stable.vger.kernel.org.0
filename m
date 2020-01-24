Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B32148331
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404680AbgAXLeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404691AbgAXLeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:34:09 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2C9E20704;
        Fri, 24 Jan 2020 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865649;
        bh=DDgwxmpgZHqtYN9cYku5TJUbMJs+80MNzlI7cbgWTS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqUcaO4uw17EcimLoDuPT7roEnXrT280GsI2m5mEiANM3gwdI62kD/KR2wqSQVEE2
         LkR6p5WXAg8+ACTtSZ3PAoXTTERqkGbRJXgxbo8pqJs1DOO1iRDxEtZf8laxmpcOD2
         f+JFuGFrYOWbG7c7uEozE0cn2bV8ADwwXf9R093M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 583/639] net: nixge: Fix a signedness bug in nixge_probe()
Date:   Fri, 24 Jan 2020 10:32:33 +0100
Message-Id: <20200124093202.505897670@linuxfoundation.org>
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

[ Upstream commit 1a4b62a0b8a3b81eca24366f63e214a7144b9f02 ]

The "priv->phy_mode" is an enum and in this context GCC will treat it
as an unsigned int so it can never be less than zero.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ni/nixge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 76efed058f334..a791d7932b0ef 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1233,7 +1233,7 @@ static int nixge_probe(struct platform_device *pdev)
 	}
 
 	priv->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-	if (priv->phy_mode < 0) {
+	if ((int)priv->phy_mode < 0) {
 		netdev_err(ndev, "not find \"phy-mode\" property\n");
 		err = -EINVAL;
 		goto unregister_mdio;
-- 
2.20.1



