Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F586961
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404489AbfHHTGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404486AbfHHTGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A33232184E;
        Thu,  8 Aug 2019 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291200;
        bh=Rgsn3PaiUomEhnUDUek54pKO3QXbvZ4dxKQM8YRnIFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShdKNRcdUOEtreyo/WQ08gNFCKYq10m1ivDvqIEYwn2OgsJi9HKdJfQPmSU2vvVcC
         j1H49owa5+Q544/ugMeKGcorz0m3qADuaQEdHQpeFTtUVr7iChATEu8oh7Bul8cX38
         qMLkC2YYsXYF6oOpx2igrqErBqlxbsljwdKaUjyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 24/56] net: phy: fixed_phy: print gpio error only if gpio node is present
Date:   Thu,  8 Aug 2019 21:04:50 +0200
Message-Id: <20190808190453.868506535@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

[ Upstream commit ab98c008ac761752cdc27f9eb053419feadeb2f7 ]

It is perfectly ok to not have an gpio attached to the fixed-link node. So
the driver should not throw an error message when the gpio is missing.

Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/fixed_phy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -216,8 +216,10 @@ static struct gpio_desc *fixed_phy_get_g
 	if (IS_ERR(gpiod)) {
 		if (PTR_ERR(gpiod) == -EPROBE_DEFER)
 			return gpiod;
-		pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
-		       fixed_link_node);
+
+		if (PTR_ERR(gpiod) != -ENOENT)
+			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
+			       fixed_link_node);
 		gpiod = NULL;
 	}
 


