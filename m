Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F9529B8C4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801928AbgJ0PpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799860AbgJ0Pdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C5520728;
        Tue, 27 Oct 2020 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812826;
        bh=S3FmQrq5G32JwUbm1AVXYhE3s1OK4/lx+DdjaR/FakM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2ZlyM2AVcC6gajSGFlEIa3I0DHAhHkObLQQStEn+CMkJ9Y+y/zLXSa8EXY4iqZVU
         dHFk6VS/uHBRarc/Vlyv5OAfHXpsF1HaeEklL9YmiOhz8rl+Z/KPrivUCVKOTI+MPD
         HbyWRO7Jh8jQc878stRK0Q6o3woE00XqEiQunZm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 312/757] usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails
Date:   Tue, 27 Oct 2020 14:49:22 +0100
Message-Id: <20201027135505.177053274@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit e1c08cf23172ed6fb228d75efc9f4c80a6812116 ]

Call dwc2_debugfs_exit() and dwc2_hcd_remove() (if the HCD was enabled
earlier) when usb_add_gadget_udc() has failed. This ensures that the
debugfs entries created by dwc2_debugfs_init() as well as the HCD are
cleaned up in the error path.

Fixes: 207324a321a866 ("usb: dwc2: Postponed gadget registration to the udc class driver")
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index db9fd4bd1a38c..b28e90e0b685d 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -584,12 +584,16 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		if (retval) {
 			hsotg->gadget.udc = NULL;
 			dwc2_hsotg_remove(hsotg);
-			goto error_init;
+			goto error_debugfs;
 		}
 	}
 #endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 	return 0;
 
+error_debugfs:
+	dwc2_debugfs_exit(hsotg);
+	if (hsotg->hcd_enabled)
+		dwc2_hcd_remove(hsotg);
 error_init:
 	if (hsotg->params.activate_stm_id_vb_detection)
 		regulator_disable(hsotg->usb33d);
-- 
2.25.1



