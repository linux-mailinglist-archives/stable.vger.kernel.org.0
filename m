Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DB79E13D
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfH0IBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbfH0IBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2481217F5;
        Tue, 27 Aug 2019 08:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892891;
        bh=+cU68XijqRIcgqLFvONk0csbOfLe3BkLdpISFbp4skI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkdNPcDKfBt+8vIfzqqCdrgamY1oIGgxd78wrx7DD3NcfUTyxe+0VUyGAFe2JjgGK
         hr3JkymwSIqk+xli1YILal8CgwflkxPLKBjoOPiP7dS9LM8Fu+3QE5Ej7gPH7eIswF
         OjJfY2rdIzkyV180IPrSgytu8PgC8QDDVhLjLzBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 049/162] net: stmmac: manage errors returned by of_get_mac_address()
Date:   Tue, 27 Aug 2019 09:49:37 +0200
Message-Id: <20190827072739.930021590@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 195b2919ccd7ffcaf6b6bbcb39444a53ab8308c7 ]

Commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
added support for reading the MAC address from an nvmem-cell. This
required changing the logic to return an error pointer upon failure.

If stmmac is loaded before the nvmem provider driver then
of_get_mac_address() return an error pointer with -EPROBE_DEFER.

Propagate this error so the stmmac driver will be probed again after the
nvmem provider driver is loaded.
Default to a random generated MAC address in case of any other error,
instead of using the error pointer as MAC address.

Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 0f0f4b31eb7ec..9b5218a8c15bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -385,6 +385,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		return ERR_PTR(-ENOMEM);
 
 	*mac = of_get_mac_address(np);
+	if (IS_ERR(*mac)) {
+		if (PTR_ERR(*mac) == -EPROBE_DEFER)
+			return ERR_CAST(*mac);
+
+		*mac = NULL;
+	}
+
 	plat->interface = of_get_phy_mode(np);
 
 	/* Get max speed of operation from device tree */
-- 
2.20.1



