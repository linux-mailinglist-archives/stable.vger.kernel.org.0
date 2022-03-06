Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42EB4CEA33
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 10:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiCFJe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 04:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiCFJe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 04:34:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B5714029
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 01:33:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986E0611B7
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 09:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDF5C340EC;
        Sun,  6 Mar 2022 09:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646559212;
        bh=Nz2+064ZaQeKEZ+JvbBKfRaHMgb8vKXUNdN6xN/vDtE=;
        h=Subject:To:From:Date:From;
        b=Dvz3sk4/8JgTpQcsPZkUQ4oguxxHoSD5eAoOL8hc7wlmy59N66YkC6lrnNLwJAGgy
         SuUzeGGg232wwDiiGHjRjG2WjrFruUlEhQFWOQT/2Uks0QOLJ0Hri9cdVIrMIE3/y1
         H/9xHMceBct/16kBQoGBgE3NaAm0o3Tba2UaBbRk=
Subject: patch "usb: typec: tipd: Forward plug orientation to typec subsystem" added to usb-next
To:     sven@svenpeter.dev, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Mar 2022 10:33:21 +0100
Message-ID: <1646559201960@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


