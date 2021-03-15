Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8040933B96D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhCOOCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhCOOAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4350D64F25;
        Mon, 15 Mar 2021 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816784;
        bh=/yY8seZufJSCs5Os++rrO3sLbgFG6e57CZGe626Fo9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jD1ic5Sn3UtMkZ2px4nXdutM6uT1roJBCffoIsgkO6//ohxllNUb1FDwqwIIeIBYH
         I28eZWKo5nWTTj+ZNT/xPe1nob1LTJxrcD7xplbNUzVmakv00h39jlP2ojxUfcquWf
         lHeFpW2Afxv4xr7uJf/hngjmkMVqlUPNxQ5ucKQw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Subject: [PATCH 5.4 107/168] usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement
Date:   Mon, 15 Mar 2021 14:55:39 +0100
Message-Id: <20210315135553.881721785@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

commit 1cffb1c66499a9db9a735473778abf8427d16287 upstream.

of_get_child_by_name() increments the reference counter of the OF node it
managed to find. So after the code is done using the device node, the
refcount must be decremented. Add missing of_node_put() invocation then
to the dwc3_qcom_of_register_core() method, since DWC3 OF node is being
used only there.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20210212205521.14280-1-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -528,16 +528,19 @@ static int dwc3_qcom_of_register_core(st
 	ret = of_platform_populate(np, NULL, NULL, dev);
 	if (ret) {
 		dev_err(dev, "failed to register dwc3 core - %d\n", ret);
-		return ret;
+		goto node_put;
 	}
 
 	qcom->dwc3 = of_find_device_by_node(dwc3_np);
 	if (!qcom->dwc3) {
+		ret = -ENODEV;
 		dev_err(dev, "failed to get dwc3 platform device\n");
-		return -ENODEV;
 	}
 
-	return 0;
+node_put:
+	of_node_put(dwc3_np);
+
+	return ret;
 }
 
 static const struct dwc3_acpi_pdata sdm845_acpi_pdata = {


