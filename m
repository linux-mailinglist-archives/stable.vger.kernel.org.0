Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4AF49A356
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387621AbiAXX5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846024AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EF6C067A77;
        Mon, 24 Jan 2022 13:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D00460C60;
        Mon, 24 Jan 2022 21:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B94FC340E4;
        Mon, 24 Jan 2022 21:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059331;
        bh=bk9nZDAqnO/Hmuv3stLRFANXP3OxWAyedFH4l31DiW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGNZLZ/G81f4cs5w0gLYW8bNZNFR0VcAmOVVE3g7djEYLE5reCwba3WE6a/nOUZJe
         Y0dI9bcpLJbWSZFBIzYco3L/cMipG/64nKA5gTzPywRtv4fXMOl78I6vzIP8/lIRSo
         orcWL7Xdrc6dSmVo4rpZmzhxQXYLdf+Qh0sqbyKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0579/1039] soc: imx: gpcv2: Synchronously suspend MIX domains
Date:   Mon, 24 Jan 2022 19:39:28 +0100
Message-Id: <20220124184144.807597716@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit f756f435f7dd823f2d4bd593ce1bf3168def1308 ]

In case the following power domain sequence happens, iMX8M Mini always hangs:
  gpumix:on -> gpu:on -> gpu:off -> gpu:on
This is likely due to another quirk of the GPC block. This situation can be
prevented by always synchronously powering off both the domain and MIX domain.
Make it so. This turns the aforementioned sequence into:
  gpumix:on -> gpu:on -> gpu:off -> gpumix:off -> gpumix:on -> gpu:on

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Frieder Schrempf <frieder.schrempf@kontron.de>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Acked-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpcv2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index 7b6dfa33dcb9f..8176380b02e6e 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -377,7 +377,7 @@ static int imx_pgc_power_down(struct generic_pm_domain *genpd)
 		}
 	}
 
-	pm_runtime_put(domain->dev);
+	pm_runtime_put_sync_suspend(domain->dev);
 
 	return 0;
 
-- 
2.34.1



