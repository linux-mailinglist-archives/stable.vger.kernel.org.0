Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6680A419BD0
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhI0RWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237085AbhI0RUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B14CA61352;
        Mon, 27 Sep 2021 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762801;
        bh=7eUByvsj/1mdEFb3Hz3uRC21VtGbqzQdNjbxs1bahFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNGgvwliIwyUwfrQi7MsdvfdjuoSXBFuvQXloIo2E7hr/c+Jm9mM092Nnyow/OBzB
         6/w2zFH4NfQxqnIL8PC1YO5C2NKZdtmpMPJ2DIWQkD7h4KB8vBSJ/IXtKX10h61Lix
         IKQei+3TZuVDUjGi0n2BaBTy27jD7iU2u4rA14xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "faqiang.zhu" <faqiang.zhu@nxp.com>,
        Felipe Balbi <balbi@kernel.org>, Li Jun <jun.li@nxp.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5.14 023/162] usb: dwc3: core: balance phy init and exit
Date:   Mon, 27 Sep 2021 19:01:09 +0200
Message-Id: <20210927170234.262917900@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 8cfac9a6744fcb143cb3e94ce002f09fd17fadbb upstream.

After we start to do core soft reset while usb role switch,
the phy init is invoked at every switch to device mode, but
its counter part de-init is missing, this causes the actual
phy init can not be done when we really want to re-init phy
like system resume, because the counter maintained by phy
core is not 0. considering phy init is actually redundant for
role switch, so move out the phy init from core soft reset to
dwc3 core init where is the only place required.

Fixes: f88359e1588b ("usb: dwc3: core: Do core softreset when switch mode")
Cc: <stable@vger.kernel.org>
Tested-by: faqiang.zhu <faqiang.zhu@nxp.com>
Tested-by: John Stultz <john.stultz@linaro.org> #HiKey960
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1631068099-13559-1-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -264,19 +264,6 @@ static int dwc3_core_soft_reset(struct d
 {
 	u32		reg;
 	int		retries = 1000;
-	int		ret;
-
-	usb_phy_init(dwc->usb2_phy);
-	usb_phy_init(dwc->usb3_phy);
-	ret = phy_init(dwc->usb2_generic_phy);
-	if (ret < 0)
-		return ret;
-
-	ret = phy_init(dwc->usb3_generic_phy);
-	if (ret < 0) {
-		phy_exit(dwc->usb2_generic_phy);
-		return ret;
-	}
 
 	/*
 	 * We're resetting only the device side because, if we're in host mode,
@@ -310,9 +297,6 @@ static int dwc3_core_soft_reset(struct d
 			udelay(1);
 	} while (--retries);
 
-	phy_exit(dwc->usb3_generic_phy);
-	phy_exit(dwc->usb2_generic_phy);
-
 	return -ETIMEDOUT;
 
 done:
@@ -982,9 +966,21 @@ static int dwc3_core_init(struct dwc3 *d
 		dwc->phys_ready = true;
 	}
 
+	usb_phy_init(dwc->usb2_phy);
+	usb_phy_init(dwc->usb3_phy);
+	ret = phy_init(dwc->usb2_generic_phy);
+	if (ret < 0)
+		goto err0a;
+
+	ret = phy_init(dwc->usb3_generic_phy);
+	if (ret < 0) {
+		phy_exit(dwc->usb2_generic_phy);
+		goto err0a;
+	}
+
 	ret = dwc3_core_soft_reset(dwc);
 	if (ret)
-		goto err0a;
+		goto err1;
 
 	if (hw_mode == DWC3_GHWPARAMS0_MODE_DRD &&
 	    !DWC3_VER_IS_WITHIN(DWC3, ANY, 194A)) {


