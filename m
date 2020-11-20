Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75012BB0E2
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgKTQq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:46:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54446 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbgKTQqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:46:55 -0500
Received: from 3.general.kamal.us.vpn ([10.172.68.53] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kg9Yj-0007MA-J1; Fri, 20 Nov 2020 16:46:53 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kg9Yf-0003Jy-9C; Fri, 20 Nov 2020 08:46:49 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 5.9.x] usb: dwc2: Avoid leaving the error_debugfs label unused
Date:   Fri, 20 Nov 2020 08:46:45 -0800
Message-Id: <20201120164645.12542-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <X7eAyumuMGcWBG81@kroah.com>
References: <X7eAyumuMGcWBG81@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit 190bb01b72d2d5c3654a03c42fb1ad0dc6114c79 upstream.

The error_debugfs label is only used when either
CONFIG_USB_DWC2_PERIPHERAL or CONFIG_USB_DWC2_DUAL_ROLE is enabled. Add
the same #if to the error_debugfs label itself as the code which uses
this label already has.

This avoids the following compiler warning:
  warning: label ‘error_debugfs’ defined but not used [-Wunused-label]

Fixes: e1c08cf23172ed ("usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc2/platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index b28e90e0b685..8a7f86e1ef73 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -590,10 +590,13 @@ static int dwc2_driver_probe(struct platform_device *dev)
 #endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 	return 0;
 
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || \
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
 error_debugfs:
 	dwc2_debugfs_exit(hsotg);
 	if (hsotg->hcd_enabled)
 		dwc2_hcd_remove(hsotg);
+#endif
 error_init:
 	if (hsotg->params.activate_stm_id_vb_detection)
 		regulator_disable(hsotg->usb33d);
-- 
2.17.1

