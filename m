Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6853032F7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbhAZEn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:43:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbhAYSms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 610F023101;
        Mon, 25 Jan 2021 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600119;
        bh=Lr4kGqLdBH46Ho6YB/3cuq2D3nR/saIdiWeiqOsVfUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L576egijzkCtVkjWEVKKBVHiGQ1g89tYWX1ZzZvwdVZM1P46qlDWPtF7HgDyfjbtU
         84t3jPckGSSDgogCRi4j1x+IqfqQJgo0d/0OU8guvKjIrNqMxUOeLgvNOGJXidy9mc
         1ClEd0NKPopdULMBc31+WanulXy4v+qDEKyTEoHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 39/58] usb: udc: core: Use lock when write to soft_connect
Date:   Mon, 25 Jan 2021 19:39:40 +0100
Message-Id: <20210125183158.394376239@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
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
@@ -1471,10 +1471,13 @@ static ssize_t soft_connect_store(struct
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
@@ -1486,10 +1489,14 @@ static ssize_t soft_connect_store(struct
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
 


