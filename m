Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C3D7F28F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405572AbfHBJqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405568AbfHBJqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD3DB2086A;
        Fri,  2 Aug 2019 09:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739193;
        bh=5lQbMyqxWLMRlZ5M0+0XQOEP+pgYP+IaWdsbpGz/8fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLPg9QqrT5EGDgTAuFC1iAQqxdFFKBXL7x4SaZhyr15jq4/UcGCgtrtE2LnW3dDPE
         VRVV04r+cJIggyygBlvwqx7/gvIaR4TzGz/pFOTlQhKwplyniFuf+M3KqOo8ZUokhE
         cnuaIAIXKERx8gp4GtVtx31Fb3HaF7ONWkZYEpLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 135/223] net: dsa: mv88e6xxx: wait after reset deactivation
Date:   Fri,  2 Aug 2019 11:36:00 +0200
Message-Id: <20190802092247.614793595@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 7b75e49de424ceb53d13e60f35d0a73765626fda ]

Add a 1ms delay after reset deactivation. Otherwise the chip returns
bogus ID value. This is observed with 88E6390 (Peridot) chip.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3846,6 +3846,8 @@ static int mv88e6xxx_probe(struct mdio_d
 		mv88e6xxx_mdio_unregister(chip);
 		return err;
 	}
+	if (chip->reset)
+		usleep_range(1000, 2000);
 
 	return 0;
 }


