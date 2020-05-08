Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB301CAFAF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgEHNS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgEHMmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83E62495F;
        Fri,  8 May 2020 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941756;
        bh=lv69lw1TSPtSSMXYYkRILtjmmpxacXgfv0+K0ZLOOv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Udmef3PH1+gPMfLz8mP44rSXhFfHvHnSkpdjAhUvbc2GoRtER6OxBJZAAdkdGfhrL
         li9fbu+0vdlBH2q9NHBootSIn6d2rSuWVcOELmszKLYSLkGdkRU4aqeKGooBeLsiX1
         D5rM7RibAKRXGE/QRfqKMskelELTQSkAcBygdp5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 160/312] mdio-sun4i: oops in error handling in probe
Date:   Fri,  8 May 2020 14:32:31 +0200
Message-Id: <20200508123135.704170154@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 227f33beab746aeec4ef3305bd17b1d374df09e7 upstream.

We could end up dereferencing an error pointer when we call
regulator_disable().

Fixes: 4bdcb1dd9feb ('net: Add MDIO bus driver for the Allwinner EMAC')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/mdio-sun4i.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/mdio-sun4i.c
+++ b/drivers/net/phy/mdio-sun4i.c
@@ -134,6 +134,7 @@ static int sun4i_mdio_probe(struct platf
 		}
 
 		dev_info(&pdev->dev, "no regulator found\n");
+		data->regulator = NULL;
 	} else {
 		ret = regulator_enable(data->regulator);
 		if (ret)
@@ -149,7 +150,8 @@ static int sun4i_mdio_probe(struct platf
 	return 0;
 
 err_out_disable_regulator:
-	regulator_disable(data->regulator);
+	if (data->regulator)
+		regulator_disable(data->regulator);
 err_out_free_mdiobus:
 	mdiobus_free(bus);
 	return ret;


