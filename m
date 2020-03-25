Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D5C192B67
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 15:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgCYOnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 10:43:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:57966 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727731AbgCYOnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 10:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585147396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dqoV/KEwx95ZHleBlKYKHLasQWHeps4CF+K8aw8lRJc=;
        b=TiyDZ7N5Y9z059pPHWmn5425d3F+CS77PnoLIG0CeZxGP4/Z92/zbrMH+AC2KmRZtsBznb
        nkeS3LsLFKhU3l35XRh7dYPxQDVLpo4oM1bG7iKoFSQa2Z2LFwEbwa5WmW+8v3yHR+6KkD
        DJyPikB3L2DOhfe62L5mkgM3ecWVKuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-oUA_TMZGM-m3eTOr4kV0kg-1; Wed, 25 Mar 2020 10:43:15 -0400
X-MC-Unique: oUA_TMZGM-m3eTOr4kV0kg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDDDBDB60;
        Wed, 25 Mar 2020 14:43:13 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-213.ams2.redhat.com [10.36.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D73010002A7;
        Wed, 25 Mar 2020 14:43:12 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH] drm/vboxvideo: Add missing remove_conflicting_pci_framebuffers call
Date:   Wed, 25 Mar 2020 15:43:10 +0100
Message-Id: <20200325144310.36779-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vboxvideo driver is missing a call to remove conflicting framebuffers=
.

Surprisingly, when using legacy BIOS booting this does not really cause
any issues. But when using UEFI to boot the VM then plymouth will draw
on both the efifb /dev/fb0 and /dev/drm/card0 (which has registered
/dev/fb1 as fbdev emulation).

VirtualBox will actual display the output of both devices (I guess it is
showing whatever was drawn last), this causes weird artifacts because of
pitch issues in the efifb when the VM window is not sized at 1024x768
(the window will resize to its last size once the vboxvideo driver loads,
changing the pitch).

Adding the missing drm_fb_helper_remove_conflicting_pci_framebuffers()
call fixes this.

Cc: stable@vger.kernel.org
Fixes: 2695eae1f6d3 ("drm/vboxvideo: Switch to generic fbdev emulation")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/gpu/drm/vboxvideo/vbox_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxv=
ideo/vbox_drv.c
index 8512d970a09f..261255085918 100644
--- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
+++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
@@ -76,6 +76,10 @@ static int vbox_pci_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
 	if (ret)
 		goto err_mode_fini;
=20
+	ret =3D drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, "vboxvi=
deodrmfb");
+	if (ret)
+		goto err_irq_fini;
+
 	ret =3D drm_fbdev_generic_setup(&vbox->ddev, 32);
 	if (ret)
 		goto err_irq_fini;
--=20
2.26.0.rc2

