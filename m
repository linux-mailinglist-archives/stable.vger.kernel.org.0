Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD918B482
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgCSNKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgCSNKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:10:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83266215A4;
        Thu, 19 Mar 2020 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623418;
        bh=AhuTA8/MkvHmF3oFS0ibpdrzLSJVUbZlVGllr2QUfR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNSaW2daC0mmlux6Humie1d4C+4yVx5OAWasTmQSHIKHK3btDpBq5O1rRuwTru4SN
         wsu9AdD6/vwr08Rcd5j/Yj+ZVtSqFIuJci3XUJiGoidcO80r9bCNltgl6pqbaMjmTG
         Kw/rItpU+pcdOLGSWlc3Rjbuggpb1lMiMPE7Ad2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bogdanov <dbogdanov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 07/90] net: macsec: update SCI upon MAC address change.
Date:   Thu, 19 Mar 2020 13:59:29 +0100
Message-Id: <20200319123930.988268743@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

[ Upstream commit 6fc498bc82929ee23aa2f35a828c6178dfd3f823 ]

SCI should be updated, because it contains MAC in its first 6 octets.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2871,6 +2871,11 @@ static void macsec_dev_set_rx_mode(struc
 	dev_uc_sync(real_dev, dev);
 }
 
+static sci_t dev_to_sci(struct net_device *dev, __be16 port)
+{
+	return make_sci(dev->dev_addr, port);
+}
+
 static int macsec_set_mac_address(struct net_device *dev, void *p)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
@@ -2892,6 +2897,7 @@ static int macsec_set_mac_address(struct
 
 out:
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
 	return 0;
 }
 
@@ -3160,11 +3166,6 @@ static bool sci_exists(struct net_device
 	return false;
 }
 
-static sci_t dev_to_sci(struct net_device *dev, __be16 port)
-{
-	return make_sci(dev->dev_addr, port);
-}
-
 static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);


