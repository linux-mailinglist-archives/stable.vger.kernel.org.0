Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA71A1313EA
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 15:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgAFOma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 09:42:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36038 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726303AbgAFOma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 09:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578321748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sPkr4dJTffQCcP7/2lEKFJe2jd0IKHJATWdG20Se/rI=;
        b=Z9vXcZn+OiwpBtMpMyhAHYWOjDuu1LJPr+0GQmagWCPA0xrDV2mwszCNw/mg6oglnKfKaR
        Ny9PZCn5zDltxUzUUNkyEdPQsMzbKJSsnAWhdHgA6tyKV/K9qDNjE/Z4NyPEXWzu6qkU3O
        yEGb60g/6ScRE4prKg9UHU9jBPrvgok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-X2skCLxwMBiUcqY87ONxhw-1; Mon, 06 Jan 2020 09:42:25 -0500
X-MC-Unique: X2skCLxwMBiUcqY87ONxhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C982E800D5C;
        Mon,  6 Jan 2020 14:42:23 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-130.ams2.redhat.com [10.36.116.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 762EA17109;
        Mon,  6 Jan 2020 14:42:20 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jason Anderson <jasona.594@gmail.com>
Subject: [PATCH 1/2] platform/x86: GPD pocket fan: Use default values when wrong modparams are given
Date:   Mon,  6 Jan 2020 15:42:18 +0100
Message-Id: <20200106144219.525215-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use our default values when wrong module-parameters are given, instead of
refusing to load. Refusing to load leaves the fan at the BIOS default
setting, which is "Off". The CPU's thermal throttling should protect the
system from damage, but not-loading is really not the best fallback in th=
is
case.

This commit fixes this by re-setting module-parameter values to their
defaults if they are out of range, instead of failing the probe with
-EINVAL.

Cc: stable@vger.kernel.org
Cc: Jason Anderson <jasona.594@gmail.com>
Reported-by: Jason Anderson <jasona.594@gmail.com>
Fixes: 594ce6db326e ("platform/x86: GPD pocket fan: Use a min-speed of 2 =
while charging")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/gpd-pocket-fan.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/gpd-pocket-fan.c b/drivers/platform/x86=
/gpd-pocket-fan.c
index be85ed966bf3..1e6a42f2ea8a 100644
--- a/drivers/platform/x86/gpd-pocket-fan.c
+++ b/drivers/platform/x86/gpd-pocket-fan.c
@@ -16,17 +16,26 @@
=20
 #define MAX_SPEED 3
=20
-static int temp_limits[3] =3D { 55000, 60000, 65000 };
+#define TEMP_LIMIT0_DEFAULT	55000
+#define TEMP_LIMIT1_DEFAULT	60000
+#define TEMP_LIMIT2_DEFAULT	65000
+
+#define HYSTERESIS_DEFAULT	3000
+
+#define SPEED_ON_AC_DEFAULT	2
+
+static int temp_limits[3] =3D {
+	TEMP_LIMIT0_DEFAULT, TEMP_LIMIT1_DEFAULT, TEMP_LIMIT2_DEFAULT };
 module_param_array(temp_limits, int, NULL, 0444);
 MODULE_PARM_DESC(temp_limits,
 		 "Millicelsius values above which the fan speed increases");
=20
-static int hysteresis =3D 3000;
+static int hysteresis =3D HYSTERESIS_DEFAULT;
 module_param(hysteresis, int, 0444);
 MODULE_PARM_DESC(hysteresis,
 		 "Hysteresis in millicelsius before lowering the fan speed");
=20
-static int speed_on_ac =3D 2;
+static int speed_on_ac =3D SPEED_ON_AC_DEFAULT;
 module_param(speed_on_ac, int, 0444);
 MODULE_PARM_DESC(speed_on_ac,
 		 "minimum fan speed to allow when system is powered by AC");
@@ -120,18 +129,21 @@ static int gpd_pocket_fan_probe(struct platform_dev=
ice *pdev)
 		if (temp_limits[i] < 40000 || temp_limits[i] > 70000) {
 			dev_err(&pdev->dev, "Invalid temp-limit %d (must be between 40000 and=
 70000)\n",
 				temp_limits[i]);
-			return -EINVAL;
+			temp_limits[0] =3D TEMP_LIMIT0_DEFAULT;
+			temp_limits[1] =3D TEMP_LIMIT1_DEFAULT;
+			temp_limits[2] =3D TEMP_LIMIT2_DEFAULT;
+			break;
 		}
 	}
 	if (hysteresis < 1000 || hysteresis > 10000) {
 		dev_err(&pdev->dev, "Invalid hysteresis %d (must be between 1000 and 1=
0000)\n",
 			hysteresis);
-		return -EINVAL;
+		hysteresis =3D HYSTERESIS_DEFAULT;
 	}
 	if (speed_on_ac < 0 || speed_on_ac > MAX_SPEED) {
 		dev_err(&pdev->dev, "Invalid speed_on_ac %d (must be between 0 and 3)\=
n",
 			speed_on_ac);
-		return -EINVAL;
+		speed_on_ac =3D SPEED_ON_AC_DEFAULT;
 	}
=20
 	fan =3D devm_kzalloc(&pdev->dev, sizeof(*fan), GFP_KERNEL);
--=20
2.24.1

