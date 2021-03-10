Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAF0333EAA
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhCJN0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233331AbhCJNZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E054464FF4;
        Wed, 10 Mar 2021 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382721;
        bh=am/Yf4+CgdxaAeroQx3u4B5yChvltnp3/a3UbAnLPgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLsM9+yAa1ao4JTMNQ+MrLr6z8cwRcMHxXk8iAB8Wo2iDe4OFZhfRI7VoMN4hfIrS
         CUKvdSHjZx5TOlIT8nwWionUUpn3hP4oSwNUyeYSisosdMBD+boYScr1pm2WBLHasO
         PMTYrkHKPCK9PRC+tDoazs+52qyNsLR4JRaVUJOo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/20] platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines
Date:   Wed, 10 Mar 2021 14:24:49 +0100
Message-Id: <20210310132320.914225098@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.512307035@linuxfoundation.org>
References: <20210310132320.512307035@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7c936d8d26afbc74deac0651d613dead2f76e81c ]

Cleanup the ACER_CAP_FOO defines:
-Switch to using BIT() macro.
-The ACER_CAP_RFBTN flag is set, but it is never checked anywhere, drop it.
-Drop the unused ACER_CAP_ANY define.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201019185628.264473-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 29f6f2bbb5ff..41311c1526a0 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -218,14 +218,12 @@ struct hotkey_function_type_aa {
 /*
  * Interface capability flags
  */
-#define ACER_CAP_MAILLED		(1<<0)
-#define ACER_CAP_WIRELESS		(1<<1)
-#define ACER_CAP_BLUETOOTH		(1<<2)
-#define ACER_CAP_BRIGHTNESS		(1<<3)
-#define ACER_CAP_THREEG			(1<<4)
-#define ACER_CAP_ACCEL			(1<<5)
-#define ACER_CAP_RFBTN			(1<<6)
-#define ACER_CAP_ANY			(0xFFFFFFFF)
+#define ACER_CAP_MAILLED		BIT(0)
+#define ACER_CAP_WIRELESS		BIT(1)
+#define ACER_CAP_BLUETOOTH		BIT(2)
+#define ACER_CAP_BRIGHTNESS		BIT(3)
+#define ACER_CAP_THREEG			BIT(4)
+#define ACER_CAP_ACCEL			BIT(5)
 
 /*
  * Interface type flags
@@ -1268,10 +1266,8 @@ static void __init type_aa_dmi_decode(const struct dmi_header *header, void *d)
 		interface->capability |= ACER_CAP_THREEG;
 	if (type_aa->commun_func_bitmap & ACER_WMID3_GDS_BLUETOOTH)
 		interface->capability |= ACER_CAP_BLUETOOTH;
-	if (type_aa->commun_func_bitmap & ACER_WMID3_GDS_RFBTN) {
-		interface->capability |= ACER_CAP_RFBTN;
+	if (type_aa->commun_func_bitmap & ACER_WMID3_GDS_RFBTN)
 		commun_func_bitmap &= ~ACER_WMID3_GDS_RFBTN;
-	}
 
 	commun_fn_key_number = type_aa->commun_fn_key_number;
 }
-- 
2.30.1



