Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006982F5C3D
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 09:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbhANIKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 03:10:54 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:53798 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727155AbhANIKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 03:10:53 -0500
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7FD5F40409;
        Thu, 14 Jan 2021 08:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610611793; bh=DYt3fzSUtsgqmE3RhzpKHDj+iN18zUya5J+pxlOZcEk=;
        h=Date:From:Subject:To:Cc:From;
        b=a5Wiq/SB3uBpQNmhY+LGcdlNBn+8uIt0M2Aclh9wcAy0Rsc56ipj17DYdj6zZy3wU
         saXtKbUByc9nqC4cflk/1fQcheNcksd/QbLRlbLwHelsC9l4oTCKZ9274RZK+cDYRj
         2KsHaGI7Wr+OuS7WTe+5NYrXuoSRJV2wRhuRF9Du3lVWFDL82x7bChLe1BI/WOB5GV
         DVUO99ZpOVI2wyl2lH3gBeG/2aJUU42jTi72+yFrj/7tu92ZHlIOikDAE3D9Vve07f
         RpZSHNNWTWIi+w1AWTSDO8RLPtZp+cTtTHld116M7exOut4TqnRLgoI7x+16OjzifL
         YeEC3BITvIjOw==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 371CEA0072;
        Thu, 14 Jan 2021 08:09:51 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 14 Jan 2021 00:09:51 -0800
Date:   Thu, 14 Jan 2021 00:09:51 -0800
Message-Id: <338ea01fbd69b1985ef58f0f59af02c805ddf189.1610611437.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v3] usb: udc: core: Use lock when write to soft_connect
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
 Changes in v3:
 - Improve flow: avoid assigning "ret = n" early
 Changes in v2:
 - Consolidate mutex_unlock to a single place using "goto out"

 drivers/usb/gadget/udc/core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 6a62bbd01324..ea114f922ccf 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1529,10 +1529,13 @@ static ssize_t soft_connect_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t n)
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
+	ssize_t			ret;
 
+	mutex_lock(&udc_lock);
 	if (!udc->driver) {
 		dev_err(dev, "soft-connect without a gadget driver\n");
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if (sysfs_streq(buf, "connect")) {
@@ -1543,10 +1546,14 @@ static ssize_t soft_connect_store(struct device *dev,
 		usb_gadget_udc_stop(udc);
 	} else {
 		dev_err(dev, "unsupported command '%s'\n", buf);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
-	return n;
+	ret = n;
+out:
+	mutex_unlock(&udc_lock);
+	return ret;
 }
 static DEVICE_ATTR_WO(soft_connect);
 

base-commit: 4e0dcf62ab4cf917d0cbe751b8bf229a065248d4
-- 
2.28.0

