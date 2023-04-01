Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF276D2D3C
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbjDABrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbjDABqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:46:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1950325554;
        Fri, 31 Mar 2023 18:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0F3AB83262;
        Sat,  1 Apr 2023 01:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2EFC4339B;
        Sat,  1 Apr 2023 01:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313487;
        bh=bc7tp/0HYO/uCoaOARNeHLN2//EvRzv+YWJcqQZ3kFU=;
        h=From:To:Cc:Subject:Date:From;
        b=P/snOpZqG7esADmSOTeOMkzNaoeQW4uPYuFJd4ejO+++56sLzgRnm2jh+Ma5vjRb4
         NeqAtWoJmeVI38Cj1l+w5g6wyJd2SrR6zviQSBDVp3Uoerz4xnyMoauOWKhziI215w
         rtS1FjvK/nFAK/CmFazHGgskvObBTDr7XA7yu9uE2sVkN4OIG2s2jQGlLwnGuXqLEq
         LTPhd+zhIhPMNFt5x42RVngXsBszNnMTnPX3L0OIYCkThJaFzX/X/kgXEuPWxEr42J
         rIrDt9B+ialViV4XmB+I4XluEDwibw7AmV9oUeBxA2mLRK0a79WahTx1kYn0QU+Oxe
         hynN08XsFZkFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Grundler <grundler@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, bleung@chromium.org,
        sre@kernel.org, chrome-platform@lists.linux.dev,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/4] power: supply: cros_usbpd: reclassify "default case!" as debug
Date:   Fri, 31 Mar 2023 21:44:41 -0400
Message-Id: <20230401014444.3357427-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
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
index 688a16bacfbbd..74b5914abbf7e 100644
--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -242,7 +242,7 @@ static int cros_usbpd_charger_get_power_info(struct port_data *port)
 		port->psy_current_max = 0;
 		break;
 	default:
-		dev_err(dev, "Port %d: default case!\n", port->port_number);
+		dev_dbg(dev, "Port %d: default case!\n", port->port_number);
 		port->psy_usb_type = POWER_SUPPLY_USB_TYPE_SDP;
 	}
 
-- 
2.39.2

