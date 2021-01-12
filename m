Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866522F4041
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388919AbhALX11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 18:27:27 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:42882 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388275AbhALX11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 18:27:27 -0500
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 82B3240109;
        Tue, 12 Jan 2021 23:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610493987; bh=UKg7IWSSwWSAYXGot7GhFfzSiXZ9QuCaLM/D4rQyQZg=;
        h=Date:From:Subject:To:Cc:From;
        b=Z5FmwyqlQDInPiN9qPmYhXeiQMWpcIifVHLmopJlrNlq6g52qXwTWfGnSlNwNySMO
         fMTGzT4XI0bDsS6XNBzKWijLoaAiwSaw/ATL6f7SB2PyP7frACkIYR4t/NTEKio25p
         m8QT4fYUxseVI2rMJFA7JpXCyo1bmmPEuCQ2pL+28VwKAykqXiGBLcx/MXlrolU1kS
         LbSZeyyYWK9MOCGgom5gaJZnXrTWdvhjNf70pzA46rS6nIscLrhUz7Wj3ewe6k7tn0
         YqfldTXDT5mXU4vgHyDi7XsG4+pfPDHi1Ez2mf+DLKAkciwPVjPhL9tre4Y3f41Z5N
         w4ILLDPQY/JOw==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id A8CC8A0096;
        Tue, 12 Jan 2021 23:26:22 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Tue, 12 Jan 2021 15:26:21 -0800
Date:   Tue, 12 Jan 2021 15:26:21 -0800
Message-Id: <8262fabe3aa7c02981f3b9d302461804c451ea5a.1610493934.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: udc: core: Use lock for soft_connect
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc:     stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use lock to guard against concurrent access for soft-connect/disconnect
operations when writing to soft_connect sysfs.

Cc: stable@vger.kernel.org
Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/udc/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 6a62bbd01324..44c67e765167 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1530,7 +1530,9 @@ static ssize_t soft_connect_store(struct device *dev,
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
 
+	mutex_lock(&udc_lock);
 	if (!udc->driver) {
+		mutex_unlock(&udc_lock);
 		dev_err(dev, "soft-connect without a gadget driver\n");
 		return -EOPNOTSUPP;
 	}
@@ -1542,10 +1544,12 @@ static ssize_t soft_connect_store(struct device *dev,
 		usb_gadget_disconnect(udc->gadget);
 		usb_gadget_udc_stop(udc);
 	} else {
+		mutex_unlock(&udc_lock);
 		dev_err(dev, "unsupported command '%s'\n", buf);
 		return -EINVAL;
 	}
 
+	mutex_unlock(&udc_lock);
 	return n;
 }
 static DEVICE_ATTR_WO(soft_connect);

base-commit: 4e0dcf62ab4cf917d0cbe751b8bf229a065248d4
-- 
2.28.0

