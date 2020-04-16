Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731AF1AC479
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392624AbgDPOAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392616AbgDPOA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:00:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2377E2078B;
        Thu, 16 Apr 2020 14:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045625;
        bh=5Ty25x7/siPUKilRYHMcLb7XfHJHNLiTxo6srGlszyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdKTqqczONFc3RVoZ10diS9n5Kgs7k5mO4Pdvfg++ml5KAM2M4AMOUH874rKM9C7A
         5arFalu3JoquMG4im7pl+NBvUXm4m6XdI2+h1T2F6/e1fTVh/9KHYZYSAnvJo6xxmR
         5L1C5L3R99Cc88TMOBoZtTgmVx6J7E5rKbIiazWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.6 211/254] drm/vboxvideo: Add missing remove_conflicting_pci_framebuffers call, v2
Date:   Thu, 16 Apr 2020 15:25:00 +0200
Message-Id: <20200416131352.447471577@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit a65a97b48694d34248195eb89bf3687403261056 upstream.

The vboxvideo driver is missing a call to remove conflicting framebuffers.

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

Changes in v2:
-Make the drm_fb_helper_remove_conflicting_pci_framebuffers() call one of
 the first things we do in our probe() method

Cc: stable@vger.kernel.org
Fixes: 2695eae1f6d3 ("drm/vboxvideo: Switch to generic fbdev emulation")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200325144310.36779-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vboxvideo/vbox_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
+++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
@@ -41,6 +41,10 @@ static int vbox_pci_probe(struct pci_dev
 	if (!vbox_check_supported(VBE_DISPI_ID_HGSMI))
 		return -ENODEV;
 
+	ret = drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, "vboxvideodrmfb");
+	if (ret)
+		return ret;
+
 	vbox = kzalloc(sizeof(*vbox), GFP_KERNEL);
 	if (!vbox)
 		return -ENOMEM;


