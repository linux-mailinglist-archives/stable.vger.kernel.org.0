Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01DF304B18
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbhAZEti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730095AbhAYSqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73D09224F9;
        Mon, 25 Jan 2021 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600335;
        bh=nhzg8bCaoaQiknIuiAx+yq6EJ+DYo/Hn+zqTbO3BpVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltvrpF1RJSZMdGSpdo79yGmXjcGLLgmjmQZRNMfd3Xx5NKOXpPZsxqK4fY+Kdbnl2
         I8ho+xk/Qwz3GE1t6OMwsA+EIyeEfyuBPai5pvGVGJrtTVdiXG0Gm469yeroe2y2Jd
         pvw9gozZfYs87KHgYgsE7IAszUPvK/WwkBhjTtQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 62/86] usb: udc: core: Use lock when write to soft_connect
Date:   Mon, 25 Jan 2021 19:39:44 +0100
Message-Id: <20210125183203.671169509@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit c28095bc99073ddda65e4f31f6ae0d908d4d5cd8 upstream.

Use lock to guard against concurrent access for soft-connect/disconnect
operations when writing to soft_connect sysfs.

Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
Cc: stable@vger.kernel.org
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/338ea01fbd69b1985ef58f0f59af02c805ddf189.1610611437.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/core.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1477,10 +1477,13 @@ static ssize_t soft_connect_store(struct
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
@@ -1491,10 +1494,14 @@ static ssize_t soft_connect_store(struct
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
 


