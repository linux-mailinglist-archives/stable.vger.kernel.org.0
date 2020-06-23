Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50D6206586
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbgFWUE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388268AbgFWUE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94EF520DD4;
        Tue, 23 Jun 2020 20:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942696;
        bh=zEPhArf7Bibyzv1Cx7hX5ix69EQLDU8ENiyIWeeyXtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5O8fYUgRgB4ox+f53H7sfN4KcAgcEgyNRWxlcuJjekehN6g42KuKo8X36HZ+fsc3
         JwXVWyQtDamb5/dcISGdQP4kn0z+cQSBh2vhGv67m4O7BFiDOUL0/IQEeugUeoVRKZ
         78Us77r7OVBBtxVIoedvRz9sp7zNGbsqkWS211Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 098/477] net: dsa: lantiq_gswip: fix and improve the unsupported interface error
Date:   Tue, 23 Jun 2020 21:51:35 +0200
Message-Id: <20200623195412.234492730@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 4d3da2d8d91f66988a829a18a0ce59945e8ae4fb ]

While trying to use the lantiq_gswip driver on one of my boards I made
a mistake when specifying the phy-mode (because the out-of-tree driver
wants phy-mode "gmii" or "mii" for the internal PHYs). In this case the
following error is printed multiple times:
  Unsupported interface: 3

While it gives at least a hint at what may be wrong it is not very user
friendly. Print the human readable phy-mode and also which port is
configured incorrectly (this hardware supports ports 0..6) to improve
the cases where someone made a mistake.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index cf6fa8fede334..521ebc072903b 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1452,7 +1452,8 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 
 unsupported:
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	dev_err(ds->dev, "Unsupported interface: %d\n", state->interface);
+	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+		phy_modes(state->interface), port);
 	return;
 }
 
-- 
2.25.1



