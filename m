Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3344CC03D
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 15:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiCCOq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 09:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCCOq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 09:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8212218A793
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 06:46:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37D41B825AD
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 14:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D8FC004E1;
        Thu,  3 Mar 2022 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646318770;
        bh=zTVJAwunlEo1wbP8rW/3GrwpH49zSpZqNRT50AKh5+E=;
        h=Subject:To:From:Date:From;
        b=mUX5LHMzm6ps5z7o1UBHA0va5OXkFoTtPa/1zSqp6GiTf4TihNRa3z+wPvFpIRr7D
         4BxjLDnZaeTiue45HJnw17iyUH0E6BqrBQO99KJGygq0fXjNyMnF7WEQ7/t6me4xI/
         DrZrSlMaOs/rXmm0j/RgKa74dQ51SSrtHoBHMacs=
Subject: patch "usb: typec: tipd: Forward plug orientation to typec subsystem" added to usb-testing
To:     sven@svenpeter.dev, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Mar 2022 15:45:55 +0100
Message-ID: <1646318755196108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tipd: Forward plug orientation to typec subsystem

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 676748389f5db74e7d28f9d630eebd75cb8a11b4 Mon Sep 17 00:00:00 2001
From: Sven Peter <sven@svenpeter.dev>
Date: Sat, 26 Feb 2022 13:59:12 +0100
Subject: usb: typec: tipd: Forward plug orientation to typec subsystem

In order to bring up the USB3 PHY on the Apple M1 we need to know the
orientation of the Type-C cable. Extract it from the status register and
forward it to the typec subsystem.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20220226125912.59828-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c     | 5 +++++
 drivers/usb/typec/tipd/tps6598x.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 7ffcda94d323..16b4560216ba 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -256,6 +256,10 @@ static int tps6598x_connect(struct tps6598x *tps, u32 status)
 	typec_set_pwr_opmode(tps->port, mode);
 	typec_set_pwr_role(tps->port, TPS_STATUS_TO_TYPEC_PORTROLE(status));
 	typec_set_vconn_role(tps->port, TPS_STATUS_TO_TYPEC_VCONN(status));
+	if (TPS_STATUS_TO_UPSIDE_DOWN(status))
+		typec_set_orientation(tps->port, TYPEC_ORIENTATION_REVERSE);
+	else
+		typec_set_orientation(tps->port, TYPEC_ORIENTATION_NORMAL);
 	tps6598x_set_data_role(tps, TPS_STATUS_TO_TYPEC_DATAROLE(status), true);
 
 	tps->partner = typec_register_partner(tps->port, &desc);
@@ -278,6 +282,7 @@ static void tps6598x_disconnect(struct tps6598x *tps, u32 status)
 	typec_set_pwr_opmode(tps->port, TYPEC_PWR_MODE_USB);
 	typec_set_pwr_role(tps->port, TPS_STATUS_TO_TYPEC_PORTROLE(status));
 	typec_set_vconn_role(tps->port, TPS_STATUS_TO_TYPEC_VCONN(status));
+	typec_set_orientation(tps->port, TYPEC_ORIENTATION_NONE);
 	tps6598x_set_data_role(tps, TPS_STATUS_TO_TYPEC_DATAROLE(status), false);
 
 	power_supply_changed(tps->psy);
diff --git a/drivers/usb/typec/tipd/tps6598x.h b/drivers/usb/typec/tipd/tps6598x.h
index 3dae84c524fb..527857549d69 100644
--- a/drivers/usb/typec/tipd/tps6598x.h
+++ b/drivers/usb/typec/tipd/tps6598x.h
@@ -17,6 +17,7 @@
 /* TPS_REG_STATUS bits */
 #define TPS_STATUS_PLUG_PRESENT		BIT(0)
 #define TPS_STATUS_PLUG_UPSIDE_DOWN	BIT(4)
+#define TPS_STATUS_TO_UPSIDE_DOWN(s)	(!!((s) & TPS_STATUS_PLUG_UPSIDE_DOWN))
 #define TPS_STATUS_PORTROLE		BIT(5)
 #define TPS_STATUS_TO_TYPEC_PORTROLE(s) (!!((s) & TPS_STATUS_PORTROLE))
 #define TPS_STATUS_DATAROLE		BIT(6)
-- 
2.35.1


