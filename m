Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B1C431CA5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhJRNm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhJRNk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 540906138B;
        Mon, 18 Oct 2021 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564019;
        bh=Vw6ttr68ZCstAPpVVICipZAA0bc2xWlXeF1vrKCNfus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRIPo804LX3OPGtYZ+PTViu53MXsn5QLz1eriQORkeoJAt+9vxBbbeAw29D+1vnYF
         ja5t37PP/NnESyy98h1EKIb9cVByPS6pjzXcnmygbLsjZ2pKVRG1ZHhJ9WwyrWFbhf
         gihBs2rhazTU64eSa83k+5+HBWnH0V7jtKGmLQkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 034/103] usb: musb: dsps: Fix the probe error path
Date:   Mon, 18 Oct 2021 15:24:10 +0200
Message-Id: <20211018132335.864944908@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit c2115b2b16421d93d4993f3fe4c520e91d6fe801 upstream.

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
Link: https://lore.kernel.org/r/20211005221631.1529448-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_dsps.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -899,11 +899,13 @@ static int dsps_probe(struct platform_de
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


