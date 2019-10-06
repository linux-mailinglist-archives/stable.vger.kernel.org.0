Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7329CD70E
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbfJFRvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbfJFRu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39A0E222BE;
        Sun,  6 Oct 2019 17:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383946;
        bh=ab/650njBQ21/h5fy4o51oMZSKILe8Zt+y0PvRGsxZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmQwcA4WePSOvK8JD/PDU2mf8J/ZpA6F34zSCBAkq5zuWba42p4SKTd7qRxf24E7q
         Ge/ghob1BCNoehfTWSoBhS9CA9UdWXtJnCdLxWg3mnzVfayVt/TvUhAHpClUu9hhjv
         hcuvCWOeCGvZZ/weDeVv7G4P15eyxTs+LihRFxKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 154/166] net: dsa: sja1105: Prevent leaking memory
Date:   Sun,  6 Oct 2019 19:22:00 +0200
Message-Id: <20191006171225.866005334@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 68501df92d116b760777a2cfda314789f926476f ]

In sja1105_static_config_upload, in two cases memory is leaked: when
static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
fails. In both cases config_buf should be released.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during switch reset")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_spi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -409,7 +409,8 @@ int sja1105_static_config_upload(struct
 	rc = static_config_buf_prepare_for_upload(priv, config_buf, buf_len);
 	if (rc < 0) {
 		dev_err(dev, "Invalid config, cannot upload\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 	/* Prevent PHY jabbering during switch reset by inhibiting
 	 * Tx on all ports and waiting for current packet to drain.
@@ -418,7 +419,8 @@ int sja1105_static_config_upload(struct
 	rc = sja1105_inhibit_tx(priv, port_bitmap, true);
 	if (rc < 0) {
 		dev_err(dev, "Failed to inhibit Tx on ports\n");
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out;
 	}
 	/* Wait for an eventual egress packet to finish transmission
 	 * (reach IFG). It is guaranteed that a second one will not


