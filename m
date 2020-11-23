Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA382C07CB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733199AbgKWMoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733194AbgKWMoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F34A20857;
        Mon, 23 Nov 2020 12:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135456;
        bh=L7ABgRME1Vc96WG4/23UoEOOsHtXh1dUYdZRtjobXOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fvqh4ma9RUnCoyT+enOer2/bjBsmbdKx+eYyrTeRx6gIbgHbjGxax2ii7mcrjd0PG
         delVfUVUqfR5W6VQIwA4wgyqkDfuddLvcDKruTnkiUe7zSSlkzzmkJzqudNqyQEqX1
         D1Au7JIlUnhhrEj9G12mID1oaM/Y306BuhFrxkM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        kernel test robot <lkp@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 074/252] usb: dwc2: Avoid leaving the error_debugfs label unused
Date:   Mon, 23 Nov 2020 13:20:24 +0100
Message-Id: <20201123121839.163614494@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index b28e90e0b685d..8a7f86e1ef73a 100644
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
2.27.0



