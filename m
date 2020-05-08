Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958241CADBF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgEHNEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgEHMtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:49:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8272324953;
        Fri,  8 May 2020 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942146;
        bh=0FOvSCNt8UtfbIPwhxl/4xZOBKkGSXp3YeT0bc0a7Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArZv246rkOZXMBJ1iUJ5MijfHYeoAcrfF03XhcwhIeac/2IzpO3bac/SCffmh2948
         2dI8sxOQ8iQI2Kqbu+CHggIyjNEH1KLK3yPPKloNto+X1ByqycDdfWF1h2jBifzkPi
         c+z+6KEZ5w8sGUBiiPLjCxGYd7QS2vzQyuJBUpSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Hutchinson <b.hutchman@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 276/312] net: ethernet: davinci_emac: Fix devioctl while in fixed link
Date:   Fri,  8 May 2020 14:34:27 +0200
Message-Id: <20200508123143.839989509@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 62522ef3c399996f6c8120bfd14b94280bc9f490 upstream.

When configured in fixed link, the DaVinci emac driver sets the
priv->phydev to NULL and further ioctl calls to the phy_mii_ioctl()
causes the kernel to crash.

Cc: Brian Hutchinson <b.hutchman@gmail.com>
Fixes: 1bb6aa56bb38 ("net: davinci_emac: Add support for fixed-link PHY")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/davinci_emac.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1512,7 +1512,10 @@ static int emac_devioctl(struct net_devi
 
 	/* TODO: Add phy read and write and private statistics get feature */
 
-	return phy_mii_ioctl(priv->phydev, ifrq, cmd);
+	if (priv->phydev)
+		return phy_mii_ioctl(priv->phydev, ifrq, cmd);
+	else
+		return -EOPNOTSUPP;
 }
 
 static int match_first_device(struct device *dev, void *data)


