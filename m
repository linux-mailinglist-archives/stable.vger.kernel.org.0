Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91406C9157
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfJBTIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35274 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729049AbfJBTIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-00035c-QY; Wed, 02 Oct 2019 20:08:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003bB-DM; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jisheng Zhang" <Jisheng.Zhang@synaptics.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.594136502@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 17/87] net: stmmac: fix reset gpio free missing
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

commit 49ce881c0d4c4a7a35358d9dccd5f26d0e56fc61 upstream.

Commit 984203ceff27 ("net: stmmac: mdio: remove reset gpio free")
removed the reset gpio free, when the driver is unbinded or rmmod,
we miss the gpio free.

This patch uses managed API to request the reset gpio, so that the
gpio could be freed properly.

Fixes: 984203ceff27 ("net: stmmac: mdio: remove reset gpio free")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -159,7 +159,8 @@ int stmmac_mdio_reset(struct mii_bus *bu
 		reset_gpio = data->reset_gpio;
 		active_low = data->active_low;
 
-		if (!gpio_request(reset_gpio, "mdio-reset")) {
+		if (!devm_gpio_request(priv->device, reset_gpio,
+				      "mdio-reset")) {
 			gpio_direction_output(reset_gpio, active_low ? 1 : 0);
 			udelay(data->delays[0]);
 			gpio_set_value(reset_gpio, active_low ? 0 : 1);

