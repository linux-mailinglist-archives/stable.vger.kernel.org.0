Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092451900C6
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 23:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgCWV7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 17:59:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39038 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgCWV7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 17:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585000785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nevpt0xLORfgoRN4dmNd6lQ6W3/5uqm6WozKz2sMmto=;
        b=B0qz0ebzcWOB7Th9gsI4anemXL10br44f5hMtZoKI05CyFnYB2qeQSQRd4ChObRglFF1ye
        hvlFzm+TGYDGgXcfweJXZU1AOyLtMOosLyM0Nwa6JQJHxoLoiMCPcQI69zieu2PR/BIbmH
        ufTufq1k/8b6SDHKJhXSbCDlfpQdTcM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-asBjqoy4MDis8bsZ-K2iEQ-1; Mon, 23 Mar 2020 17:59:43 -0400
X-MC-Unique: asBjqoy4MDis8bsZ-K2iEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 669F1100550D;
        Mon, 23 Mar 2020 21:59:42 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05E8D19C6A;
        Mon, 23 Mar 2020 21:59:40 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH resend] extcon: axp288: Add wakeup support
Date:   Mon, 23 Mar 2020 22:59:39 +0100
Message-Id: <20200323215939.79008-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
2.26.0.rc2

