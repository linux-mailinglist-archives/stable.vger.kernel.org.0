Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E5D149B3A
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 16:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgAZPFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 10:05:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725907AbgAZPFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 10:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580051117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5P7+QvGQHXeotp6CF14kQeN4StmWZtMU1XYUVa0NpYU=;
        b=Or3xedcIZrg730EVjOb3n7ZZBM30/TgRIWTrrmSXwMm4vLHWP6YuI1TpakWW5YMdCA0Uti
        ++xld+CzuTN4ItpwBen4odolzupk8SC0umf+pDSJD7SrmGi0t3/phRJBXhpg8vy+H0pOVq
        H+1jbjTyPnp5OvTfRphENH3ndjoQYGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-T5k4771SOuewSikn8CDSQw-1; Sun, 26 Jan 2020 10:05:15 -0500
X-MC-Unique: T5k4771SOuewSikn8CDSQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D96B1882CC0;
        Sun, 26 Jan 2020 15:05:14 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-101.ams2.redhat.com [10.36.116.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88C985D9CD;
        Sun, 26 Jan 2020 15:05:11 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] extcon: axp288: Add wakeup support
Date:   Sun, 26 Jan 2020 16:05:11 +0100
Message-Id: <20200126150511.6148-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On devices with an AXP288, we need to wakeup from suspend when a charger
is plugged in, so that we can do charger-type detection and so that the
axp288-charger driver, which listens for our extcon events, can configure
the input-current-limit accordingly.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/extcon/extcon-axp288.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp28=
8.c
index a7f216191493..710a3bb66e95 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -443,9 +443,40 @@ static int axp288_extcon_probe(struct platform_devic=
e *pdev)
 	/* Start charger cable type detection */
 	axp288_extcon_enable(info);
=20
+	device_init_wakeup(dev, true);
+	platform_set_drvdata(pdev, info);
+
+	return 0;
+}
+
+static int __maybe_unused axp288_extcon_suspend(struct device *dev)
+{
+	struct axp288_extcon_info *info =3D dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(info->irq[VBUS_RISING_IRQ]);
+
 	return 0;
 }
=20
+static int __maybe_unused axp288_extcon_resume(struct device *dev)
+{
+	struct axp288_extcon_info *info =3D dev_get_drvdata(dev);
+
+	/*
+	 * Wakeup when a charger is connected to do charger-type
+	 * connection and generate an extcon event which makes the
+	 * axp288 charger driver set the input current limit.
+	 */
+	if (device_may_wakeup(dev))
+		disable_irq_wake(info->irq[VBUS_RISING_IRQ]);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(axp288_extcon_pm_ops, axp288_extcon_suspend,
+			 axp288_extcon_resume);
+
 static const struct platform_device_id axp288_extcon_table[] =3D {
 	{ .name =3D "axp288_extcon" },
 	{},
@@ -457,6 +488,7 @@ static struct platform_driver axp288_extcon_driver =3D=
 {
 	.id_table =3D axp288_extcon_table,
 	.driver =3D {
 		.name =3D "axp288_extcon",
+		.pm =3D &axp288_extcon_pm_ops,
 	},
 };
=20
--=20
2.24.1

