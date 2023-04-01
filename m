Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05426D2D96
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 04:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjDACJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 22:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjDACJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 22:09:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A181C1025E;
        Fri, 31 Mar 2023 19:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36935B832FF;
        Sat,  1 Apr 2023 01:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9B2C4339C;
        Sat,  1 Apr 2023 01:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313434;
        bh=w+eQeY8xWmJH+xm58zvXHBkiJC8aAfsMU8f1VaxE4AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AH+F1ExLfvTDrtvS4AUTy2nVgEPnoN/StVlBWgojpDbVwhz3A403DwMszb2ZUgeyv
         ZNjUaT8b4Wnr6WlN6c9hQ/ERQuxExHTs/ClcGnseq9G7S26sjQMSkkV95YZzpx5vsv
         QvCKppV2s+jFC2e8rPf7E81d1pJexWUmHg5Yzl1OWeaGkd2x1b3mscHLO72QCbItTV
         jraUuYZFlITRy58PGtPrge7TMHRBSDe0bfiNGR0duVyLdMsApbPZ1jc8oQ1mA8AnYJ
         CVQUm2sJObfL1JALRAVh/PHkMOztYZ91ZWY3KG2DnTMli5glUCWI1M/JIarIaNrUTS
         fn6kDd5qUAoOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Grundler <grundler@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, bleung@chromium.org,
        sre@kernel.org, chrome-platform@lists.linux.dev,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/11] power: supply: cros_usbpd: reclassify "default case!" as debug
Date:   Fri, 31 Mar 2023 21:43:40 -0400
Message-Id: <20230401014350.3357107-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014350.3357107-1-sashal@kernel.org>
References: <20230401014350.3357107-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>

[ Upstream commit 14c76b2e75bca4d96e2b85a0c12aa43e84fe3f74 ]

This doesn't need to be printed every second as an error:
...
<3>[17438.628385] cros-usbpd-charger cros-usbpd-charger.3.auto: Port 1: default case!
<3>[17439.634176] cros-usbpd-charger cros-usbpd-charger.3.auto: Port 1: default case!
<3>[17440.640298] cros-usbpd-charger cros-usbpd-charger.3.auto: Port 1: default case!
...

Reduce priority from ERROR to DEBUG.

Signed-off-by: Grant Grundler <grundler@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cros_usbpd-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/cros_usbpd-charger.c b/drivers/power/supply/cros_usbpd-charger.c
index d89e08efd2ad0..0a4f02e4ae7ba 100644
--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -276,7 +276,7 @@ static int cros_usbpd_charger_get_power_info(struct port_data *port)
 		port->psy_current_max = 0;
 		break;
 	default:
-		dev_err(dev, "Port %d: default case!\n", port->port_number);
+		dev_dbg(dev, "Port %d: default case!\n", port->port_number);
 		port->psy_usb_type = POWER_SUPPLY_USB_TYPE_SDP;
 	}
 
-- 
2.39.2

