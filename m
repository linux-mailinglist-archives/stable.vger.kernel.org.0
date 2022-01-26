Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD0449C59D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 09:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiAZI4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 03:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiAZI4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 03:56:19 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEF4C06161C;
        Wed, 26 Jan 2022 00:56:19 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id j16so11204901plx.4;
        Wed, 26 Jan 2022 00:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4S4SnCn9eD0g7xG9Mm2dDQNDBGBOG83eXlCYQPAFPMo=;
        b=BbDEwgQg73det4KtLGRLbJfcaV0orlyeGNNbyJk616IVmVqvm1L2GO6wkDJju6tHfv
         MAYRx7shj7JLtcjWEocPjmdLS1odmSRwyJpEWMV+v+ySCv4dznRZoYMTy+5VfFPB9xZ3
         0adomHh/vNK9pRdifKuqr4Xrz84N1HkA7m2CkdZ7rr0I1W71ez15OZ4IsIG2+6hHC1/R
         9wbRZ0if/FyOUqDALupg6fOkA/K8Gsw/G2GFYWqb5Z6/oC/tam/M9FfqmT30UWsE6r6d
         S718753DU22ldFpAlx6YPS7JsYbTKKB+/jvPmEW4TzKW836VZEQIVvWkXtRMon13L5/t
         N1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4S4SnCn9eD0g7xG9Mm2dDQNDBGBOG83eXlCYQPAFPMo=;
        b=sZI+WaE9AevW9hMTSFx3s/q7nNZe/5EwCXbzHyUJjw9Riw/jFD/XYfcOWbcOGh53bA
         /2NoC1vrR7S2tuwxkkIafHB6bEsWlRsZbw51Xt+eS38jBgl5lGgflWlJsDr+C+8j4nzD
         6Og8nDlFCq3BvoBxSgaacpTwtz2WCbaJs62w+g46l+xiTH5VYYOw3ARnS3XZanUNyPBy
         mYw/GO+Yq7w7P0BgxXY4SgwVK0BFP/M7DIRht+okrrhpEqoqMchm4jpz70L7TDzzIb0s
         HvBe8IT27imdQLkYa0hh3YpRTE12zDSoaPkItcmS4RqwG6/E/0u3ajBfXSDknh8Iqrap
         OxDQ==
X-Gm-Message-State: AOAM531869jcC1oVvNKOLnxmn2oZS9dbi6KBx1Mdp3arExg6J2Jfyc49
        cICpEGavCr2iFZ0UnRbnJxU=
X-Google-Smtp-Source: ABdhPJwpbeWRvM+2nZ+Pu+ml/h90hyno+84Gtllq3DX3a/THRde9rb53S+zUQyuSArnKHV6f2hD0sg==
X-Received: by 2002:a17:90a:50f:: with SMTP id h15mr7776060pjh.78.1643187379196;
        Wed, 26 Jan 2022 00:56:19 -0800 (PST)
Received: from jason-ThinkPad-T14-Gen-1.lan ([66.187.5.142])
        by smtp.gmail.com with ESMTPSA id mn2sm2400977pjb.38.2022.01.26.00.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 00:56:18 -0800 (PST)
From:   Hongyu Xie <xy521521@gmail.com>
To:     mathias.nyman@intel.com, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH -next] xhci: fix two places when dealing with return value of function xhci_check_args
Date:   Wed, 26 Jan 2022 16:56:09 +0800
Message-Id: <20220126085609.918452-1-xy521521@gmail.com>
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

