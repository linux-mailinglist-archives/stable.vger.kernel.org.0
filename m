Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B12A20636A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389706AbgFWUYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390382AbgFWUYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:24:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B28E2070E;
        Tue, 23 Jun 2020 20:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943847;
        bh=7jOIZZUblMJrgVmQcUKFWYKtW7WTO++BGTCorcYKPMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RghiQoP8D2KV/NdfzYq/HgkOu8CuHXj7XVInwlnvn0glKzYmu1eUiX0LjNFHQ3NS
         3t0yFoiivm3xiGD90GHSh5avZAFIKXC86MHVEtej/kpNVMPT24rZzEqY4HiK1Sg0QO
         GlhAQOsW4i0Urd+lbPh/VVexaeU1vu9jozVuDw1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/314] net: dsa: lantiq_gswip: fix and improve the unsupported interface error
Date:   Tue, 23 Jun 2020 21:54:30 +0200
Message-Id: <20200623195342.426436190@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index a69c9b9878b7d..636966e93517e 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1451,7 +1451,8 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 
 unsupported:
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	dev_err(ds->dev, "Unsupported interface: %d\n", state->interface);
+	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+		phy_modes(state->interface), port);
 	return;
 }
 
-- 
2.25.1



