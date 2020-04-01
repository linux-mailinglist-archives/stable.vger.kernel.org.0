Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434B519B016
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbgDAQX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387647AbgDAQX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:23:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DDC21556;
        Wed,  1 Apr 2020 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758235;
        bh=7HXrLcMrjq1vUs0dcnl4r6XQPbXaANKTiMgvquxYJkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ij2iRvSFZ8Ietd/DOYDs0lL8dSbGm7tW02+X1Y2IhppdMJmo9ByhzPdsUrr+1NRB5
         WPwzQdjiu0ask9+0t4BPq7NZ9n40YU1THGXIuTOZKX97+VIUzTooNxqw/a8YkO70Vw
         OF2YpQXAnlnyVHhnWm0Gr4WoIafIfVtDYfAUC4MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 026/116] net: phy: mdio-mux-bcm-iproc: check clk_prepare_enable() return value
Date:   Wed,  1 Apr 2020 18:16:42 +0200
Message-Id: <20200401161545.730602252@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

[ Upstream commit 872307abbd0d9afd72171929806c2fa33dc34179 ]

Check clk_prepare_enable() return value.

Fixes: 2c7230446bc9 ("net: phy: Add pm support to Broadcom iProc mdio mux driver")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio-mux-bcm-iproc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/mdio-mux-bcm-iproc.c
+++ b/drivers/net/phy/mdio-mux-bcm-iproc.c
@@ -301,8 +301,13 @@ static int mdio_mux_iproc_resume(struct
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct iproc_mdiomux_desc *md = platform_get_drvdata(pdev);
+	int rc;
 
-	clk_prepare_enable(md->core_clk);
+	rc = clk_prepare_enable(md->core_clk);
+	if (rc) {
+		dev_err(md->dev, "failed to enable core clk\n");
+		return rc;
+	}
 	mdio_mux_iproc_config(md);
 
 	return 0;


