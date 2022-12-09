Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A69648750
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 18:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiLIRIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 12:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiLIRIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 12:08:06 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7CA813DE0;
        Fri,  9 Dec 2022 09:07:45 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,230,1665414000"; 
   d="scan'208";a="145652880"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 10 Dec 2022 02:07:45 +0900
Received: from localhost.localdomain (unknown [10.226.92.54])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 559214000FA3;
        Sat, 10 Dec 2022 02:07:42 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das@bp.renesas.com>, linux-usb@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
Date:   Fri,  9 Dec 2022 17:07:40 +0000
Message-Id: <20221209170740.70539-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The value returned by usb_role_switch_get() can be NULL and it leads
to NULL pointer crash. This patch fixes this issue by adding NULL
check for the role switch handle.

[   25.336613] Hardware name: Silicon Linux RZ/G2E evaluation kit EK874 (CAT874 + CAT875) (DT)
[   25.344991] Workqueue: events_unbound deferred_probe_work_func
[   25.350869] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   25.357854] pc : renesas_usb3_role_switch_get+0x40/0x80 [renesas_usb3]
[   25.364428] lr : renesas_usb3_role_switch_get+0x24/0x80 [renesas_usb3]
[   25.370986] sp : ffff80000a4b3a40
[   25.374311] x29: ffff80000a4b3a40 x28: 0000000000000000 x27: 0000000000000000
[   25.381476] x26: ffff80000a3ade78 x25: ffff00000a809005 x24: ffff80000117f178
[   25.388641] x23: ffff00000a8d7810 x22: ffff00000a8d8410 x21: 0000000000000000
[   25.395805] x20: ffff000011cd7080 x19: ffff000011cd7080 x18: 0000000000000020
[   25.402969] x17: ffff800076196000 x16: ffff800008004000 x15: 0000000000004000
[   25.410133] x14: 000000000000022b x13: 0000000000000001 x12: 0000000000000001
[   25.417291] x11: 0000000000000000 x10: 0000000000000a40 x9 : ffff80000a4b3770
[   25.424452] x8 : ffff00007fbc9000 x7 : 0040000000000008 x6 : ffff00000a8d8590
[   25.431615] x5 : ffff80000a4b3960 x4 : 0000000000000000 x3 : ffff00000a8d84f4
[   25.438776] x2 : 0000000000000218 x1 : ffff80000a715218 x0 : 0000000000000218
[   25.445942] Call trace:
[   25.448398]  renesas_usb3_role_switch_get+0x40/0x80 [renesas_usb3]
[   25.454613]  renesas_usb3_role_switch_set+0x4c/0x440 [renesas_usb3]
[   25.460908]  usb_role_switch_set_role+0x44/0xa4
[   25.465468]  hd3ss3220_set_role+0xa0/0x100 [hd3ss3220]
[   25.470635]  hd3ss3220_probe+0x118/0x2fc [hd3ss3220]
[   25.475621]  i2c_device_probe+0x338/0x384

Fixes: 5a9a8a4c5058 ("usb: typec: hd3ss3220: hd3ss3220_probe() warn: passing zero to 'PTR_ERR'")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
This issue triggered on RZ/G2E board, where there is no USB3 firmware and it
returned a null role switch handle.

v1->v2:
 * Make it as individual patch
 * Added Cc tag
---
 drivers/usb/typec/hd3ss3220.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/hd3ss3220.c b/drivers/usb/typec/hd3ss3220.c
index 2a58185fb14c..c24bbccd14f9 100644
--- a/drivers/usb/typec/hd3ss3220.c
+++ b/drivers/usb/typec/hd3ss3220.c
@@ -186,7 +186,10 @@ static int hd3ss3220_probe(struct i2c_client *client,
 		hd3ss3220->role_sw = usb_role_switch_get(hd3ss3220->dev);
 	}
 
-	if (IS_ERR(hd3ss3220->role_sw)) {
+	if (!hd3ss3220->role_sw) {
+		ret = -ENODEV;
+		goto err_put_fwnode;
+	} else if (IS_ERR(hd3ss3220->role_sw)) {
 		ret = PTR_ERR(hd3ss3220->role_sw);
 		goto err_put_fwnode;
 	}
-- 
2.25.1

