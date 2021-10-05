Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DAF42334B
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 00:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJEWS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 18:18:27 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:9531 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhJEWS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 18:18:27 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 38488240003;
        Tue,  5 Oct 2021 22:16:32 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Bin Liu <b-liu@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: musb: dsps: Fix the probe error path
Date:   Wed,  6 Oct 2021 00:16:31 +0200
Message-Id: <20211005221631.1529448-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7c75bde329d7 ("usb: musb: musb_dsps: request_irq() after
initializing musb") has inverted the calls to
dsps_setup_optional_vbus_irq() and dsps_create_musb_pdev() without
updating correctly the error path. dsps_create_musb_pdev() allocates and
registers a new platform device which must be unregistered and freed
with platform_device_unregister(), and this is missing upon
dsps_setup_optional_vbus_irq() error.

While on the master branch it seems not to trigger any issue, I observed
a kernel crash because of a NULL pointer dereference with a v5.10.70
stable kernel where the patch mentioned above was backported. With this
kernel version, -EPROBE_DEFER is returned the first time
dsps_setup_optional_vbus_irq() is called which triggers the probe to
error out without unregistering the platform device. Unfortunately, on
the Beagle Bone Black Wireless, the platform device still living in the
system is being used by the USB Ethernet gadget driver, which during the
boot phase triggers the crash.

My limited knowledge of the musb world prevents me to revert this commit
which was sent to silence a robot warning which, as far as I understand,
does not make sense. The goal of this patch was to prevent an IRQ to
fire before the platform device being registered. I think this cannot
ever happen due to the fact that enabling the interrupts is done by the
->enable() callback of the platform musb device, and this platform
device must be already registered in order for the core or any other
user to use this callback.

Hence, I decided to fix the error path, which might prevent future
errors on mainline kernels while also fixing older ones.

Fixes: 7c75bde329d7 ("usb: musb: musb_dsps: request_irq() after initializing musb")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/usb/musb/musb_dsps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index ce9fc46c9266..b5935834f9d2 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -899,11 +899,13 @@ static int dsps_probe(struct platform_device *pdev)
 	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
 		ret = dsps_setup_optional_vbus_irq(pdev, glue);
 		if (ret)
-			goto err;
+			goto unregister_pdev;
 	}
 
 	return 0;
 
+unregister_pdev:
+	platform_device_unregister(glue->musb);
 err:
 	pm_runtime_disable(&pdev->dev);
 	iounmap(glue->usbss_base);
-- 
2.27.0

