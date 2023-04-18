Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D3F6E64A4
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjDRMvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjDRMvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68E916DF4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52F986340D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696B9C433EF;
        Tue, 18 Apr 2023 12:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822248;
        bh=VmykETqOcjF6Uy29X96uBxbZm48eC5ZmjKblSG7f64I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgEgtCc+aPKZkkZr2BbHJcOhXPCRfqB5PbTe3ihQ+MbXQM4prnv1d8W5R+PgAU+md
         J5nzFczteXXntJ3j0yD4riMg99+XfHZn0zuYSqyytd69f7/2tPgniMDjwUat4vJLbM
         z5rJQ6vro58Dtw6t3x10GTws9u7RpgPAM/yXq3k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Grant Grundler <grundler@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 079/139] power: supply: cros_usbpd: reclassify "default case!" as debug
Date:   Tue, 18 Apr 2023 14:22:24 +0200
Message-Id: <20230418120316.807741979@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index cadb6a0c2cc7e..b6c96376776a9 100644
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



