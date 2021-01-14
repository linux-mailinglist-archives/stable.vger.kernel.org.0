Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871452F596F
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 04:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbhANDjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 22:39:31 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:43270 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbhANDja (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 22:39:30 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 15B114025A;
        Thu, 14 Jan 2021 03:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610595510; bh=av7mt7Tvas77VdAORFuYEb9QVuhpUCn+UocN3bdElgw=;
        h=Date:From:Subject:To:Cc:From;
        b=JSGOQsHAYq/g9YnFSgY5pxq3Oe5GmRs02S0kAO4Xv8aDHNSeOhvwbnQvta8zEpm6e
         uXdTm2s2I3mIkLuq3L98A9MwQ87bF0hsuUhugQTyhcTql6B7IaAhR8wDeOMmDiLZ7O
         RwTimFeVl7PbDeHYuuB0SadjuDbGwn/N9cEUsIJRN5n5vozVisDRjtqvxDlL7r122U
         zmdaDRainSB7xeDQNCrIaQ/19Y//9Dtp6gd6U5DN//2NJgf5BAMqEwUESLIs5UisKU
         IeeEY4eQCyc8OKcnUzrb4I7R+WlYw/1mzADdxFDrFARlCFhbTpEe61gFNPGlAkG8ID
         Mb4pdt3hZ5SHg==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 76789A007A;
        Thu, 14 Jan 2021 03:38:28 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 13 Jan 2021 19:38:28 -0800
Date:   Wed, 13 Jan 2021 19:38:28 -0800
Message-Id: <311bc6d30b23427420133602c2833308310b7fcb.1610595364.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2] usb: udc: core: Use lock when write to soft_connect
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
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
 Changes in v2:
 - Consolidate mutex_unlock to a single place using "goto out"

 drivers/usb/gadget/udc/core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 6a62bbd01324..3363f5c282f1 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1529,10 +1529,13 @@ static ssize_t soft_connect_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t n)
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
+	ssize_t			ret = n;
 
+	mutex_lock(&udc_lock);
 	if (!udc->driver) {
 		dev_err(dev, "soft-connect without a gadget driver\n");
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if (sysfs_streq(buf, "connect")) {
@@ -1543,10 +1546,12 @@ static ssize_t soft_connect_store(struct device *dev,
 		usb_gadget_udc_stop(udc);
 	} else {
 		dev_err(dev, "unsupported command '%s'\n", buf);
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return n;
+out:
+	mutex_unlock(&udc_lock);
+	return ret;
 }
 static DEVICE_ATTR_WO(soft_connect);
 

base-commit: 4e0dcf62ab4cf917d0cbe751b8bf229a065248d4
-- 
2.28.0

