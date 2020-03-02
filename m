Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A0A176523
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 21:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgCBUha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 15:37:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726579AbgCBUha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 15:37:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583181448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zqvrLEQk5BMgju+RSyn/5B7EOYMlf2EShnIdivH2s10=;
        b=Yl5HypZrKlE0rx4vA0MIlHd9jpbKtx0WSODSkywbA9sRr2DmHYtBkFXY7Pg+dkaNPSMWgs
        fky8bNdTkqyBI2auRgC1BDulw0tVTCjRAXlEy/hSA6X6u/Oy5WiAgCs/tsPdEeZOVWQ9/l
        KStTqxDuOWvIfbAAzz0iuqCQw012Too=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-bC9Ty_ouO8GLgdEtXWVwHg-1; Mon, 02 Mar 2020 15:37:27 -0500
X-MC-Unique: bC9Ty_ouO8GLgdEtXWVwHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6328D13E5;
        Mon,  2 Mar 2020 20:37:26 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B5045DD73;
        Mon,  2 Mar 2020 20:37:19 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com
Cc:     andre.przywara@arm.com, stable@vger.kernel.org, cohuck@redhat.com
Subject: [PATCH] vfio: platform: Switch to platform_get_irq_optional()
Date:   Mon,  2 Mar 2020 21:37:15 +0100
Message-Id: <20200302203715.13889-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 7723f4c5ecdb ("driver core: platform: Add an error
message to platform_get_irq*()"), platform_get_irq() calls dev_err()
on an error. As we enumerate all interrupts until platform_get_irq()
fails, we now systematically get a message such as:
"vfio-platform fff51000.ethernet: IRQ index 3 not found" which is
a false positive.

Let's use platform_get_irq_optional() instead.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Cc: stable@vger.kernel.org # v5.3+
---
 drivers/vfio/platform/vfio_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platfor=
m/vfio_platform.c
index ae1a5eb98620..1e2769010089 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -44,7 +44,7 @@ static int get_platform_irq(struct vfio_platform_device=
 *vdev, int i)
 {
 	struct platform_device *pdev =3D (struct platform_device *) vdev->opaqu=
e;
=20
-	return platform_get_irq(pdev, i);
+	return platform_get_irq_optional(pdev, i);
 }
=20
 static int vfio_platform_probe(struct platform_device *pdev)
--=20
2.20.1

