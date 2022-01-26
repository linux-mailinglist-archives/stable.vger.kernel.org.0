Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E292B49C6B5
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 10:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiAZJl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 04:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiAZJlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 04:41:42 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4D2C06175F;
        Wed, 26 Jan 2022 01:41:42 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id g9-20020a17090a67c900b001b4f1d71e4fso5635294pjm.4;
        Wed, 26 Jan 2022 01:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4S4SnCn9eD0g7xG9Mm2dDQNDBGBOG83eXlCYQPAFPMo=;
        b=MJMGW9hF6VHtArxCjhSKgW45DdofOq1qTJGtTPsntenbylZgbJ9MDkY73vHVwcpsj2
         d9gOYmHbM4Nf4t2tMbBMhYzS2GkDsHC4RPncMHuwQKkohVCAcGl+7LUSOtPIM1nUulYB
         zh2MHHVOGxfD9Rn6Wg5sxFcPd2D7M7Usbw1s+OJKF7J1hWjXOcjoqYUW2aiIg1abfGGy
         OtWtWov1SnneYODvSF126kTGxGoZIut2I/dRgd7jGQZbE+5fq4nznV7iBzB8WuUH0zXk
         K9TywWeRaTN08K4z1/gqopRLMy14/Mmsn/jBk1QXv1ESSC5OD6EzeJzaHNxkGMOHMctB
         HrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4S4SnCn9eD0g7xG9Mm2dDQNDBGBOG83eXlCYQPAFPMo=;
        b=BHhUHsbB7BnjpAGmUDRJ2oFQqq+6AA5Vi5blXWO5m6xUiV1tiCagVRh84Mr7vMIEMd
         Lb+w7dNzfUCBtyxsTICwdU4+riXYhCjHezo+tF6pw1eLccz2pXWsaVIeYbLdDjE1xw7d
         aBWJlzuIUqqpinMcg1ra9OZ1wxpxE5G3016iOcPX2HBp1em2tdeTijX6ZTx/18Y/d/VW
         YMHqlijp2XRNcpikEbp82AkbcZI4J0KrUMouXQ52LDqS3i/4RZmeAZaLjz7Zzc13o712
         dH/4CYwKyev+qCi10s7145MixG56iAz4zd17mXi8/v85lmwFnoTM9LOWyUSblaPwq0h3
         XS6w==
X-Gm-Message-State: AOAM5304zf0wVGEbEJrZ582YqXJYSOtzhb3TOIjTUNGZzhlLSGwOqGq0
        lP955YHGgmd6aXs4TPfYlXo=
X-Google-Smtp-Source: ABdhPJykoXtEX3wyHZ0RmV9fSH+ZRSOkMagr1QNuEmJEdTWS5+QBdhrSAOLHvAlgBqpV1cLn3Hb9kw==
X-Received: by 2002:a17:902:6b87:b0:149:7d3c:124d with SMTP id p7-20020a1709026b8700b001497d3c124dmr22345578plk.57.1643190101978;
        Wed, 26 Jan 2022 01:41:41 -0800 (PST)
Received: from jason-ThinkPad-T14-Gen-1.lan ([66.187.5.142])
        by smtp.gmail.com with ESMTPSA id r9sm16547576pga.2.2022.01.26.01.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:41:41 -0800 (PST)
From:   Hongyu Xie <xy521521@gmail.com>
To:     mathias.nyman@intel.com, gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        125707942@qq.com, Hongyu Xie <xiehongyu1@kylinos.cn>,
        stable@vger.kernel.org
Subject: [PATCH -next] xhci: fix two places when dealing with return value of function xhci_check_args
Date:   Wed, 26 Jan 2022 17:41:26 +0800
Message-Id: <20220126094126.923798-1-xy521521@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongyu Xie <xiehongyu1@kylinos.cn>

xhci_check_args returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
the return value of xhci_check_args <= 0.
This will cause a problem.
For example, r8152_submit_rx calling usb_submit_urb in
drivers/net/usb/r8152.c.
r8152_submit_rx will never get -ENODEV after submiting an urb
when xHC is halted,
because xhci_urb_enqueue returns -EINVAL in the very beginning.

Fixes: 203a86613fb3 ("xhci: Avoid NULL pointer deref when host dies.")
Cc: stable@vger.kernel.org
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
---
 drivers/usb/host/xhci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index dc357cabb265..a7a55dd206fe 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1604,9 +1604,12 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 	struct urb_priv	*urb_priv;
 	int num_tds;
 
-	if (!urb || xhci_check_args(hcd, urb->dev, urb->ep,
-					true, true, __func__) <= 0)
+	if (!urb)
 		return -EINVAL;
+	ret = xhci_check_args(hcd, urb->dev, urb->ep,
+					true, true, __func__);
+	if (ret <= 0)
+		return ret;
 
 	slot_id = urb->dev->slot_id;
 	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
@@ -3323,7 +3326,7 @@ static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
 		return -EINVAL;
 	ret = xhci_check_args(xhci_to_hcd(xhci), udev, ep, 1, true, __func__);
 	if (ret <= 0)
-		return -EINVAL;
+		return ret;
 	if (usb_ss_max_streams(&ep->ss_ep_comp) == 0) {
 		xhci_warn(xhci, "WARN: SuperSpeed Endpoint Companion"
 				" descriptor for ep 0x%x does not support streams\n",
-- 
2.25.1

