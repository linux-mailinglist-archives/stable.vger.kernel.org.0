Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C501CAF04
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgEHNNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729560AbgEHMro (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B83921473;
        Fri,  8 May 2020 12:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942064;
        bh=Z5iQ/y45laEYfpMIvVbfwwUyNxICJlk1K0BI1AQTMe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRTFQEaUOcS+3THF1jBPMynfw/iAKTCSEx8BvA5aS3FAzfF8ixUyoYrj3+sJimteE
         ASYkxDiWijmt1cagQ6PiHk/PtbrAqRlYjvTjMRlkKklOxHXdw2NV6zEbJSrvRejPea
         SfPcyeVqR6ZpX4HMHWo2eqi2H14F5/3lw7ds1cGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Thadeu Lima de Souza Cascardo <cascardo@debian.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 283/312] net: ehea: avoid null pointer dereference
Date:   Fri,  8 May 2020 14:34:34 +0200
Message-Id: <20200508123144.309831655@linuxfoundation.org>
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

From: xypron.glpk@gmx.de <xypron.glpk@gmx.de>

commit 1740c29a46b30a2f157afc473156f157e599d4c2 upstream.

ehea_get_port may return NULL. Do not dereference NULL value.

Fixes: 8c4877a4128e ("ehea: Use the standard logging functions")
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@debian.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ibm/ehea/ehea_main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1169,16 +1169,15 @@ static void ehea_parse_eqe(struct ehea_a
 	ec = EHEA_BMASK_GET(NEQE_EVENT_CODE, eqe);
 	portnum = EHEA_BMASK_GET(NEQE_PORTNUM, eqe);
 	port = ehea_get_port(adapter, portnum);
+	if (!port) {
+		netdev_err(NULL, "unknown portnum %x\n", portnum);
+		return;
+	}
 	dev = port->netdev;
 
 	switch (ec) {
 	case EHEA_EC_PORTSTATE_CHG:	/* port state change */
 
-		if (!port) {
-			netdev_err(dev, "unknown portnum %x\n", portnum);
-			break;
-		}
-
 		if (EHEA_BMASK_GET(NEQE_PORT_UP, eqe)) {
 			if (!netif_carrier_ok(dev)) {
 				ret = ehea_sense_port_attr(port);


