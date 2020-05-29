Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80F31E7C68
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 13:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgE2L4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 07:56:11 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48648 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgE2L4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 07:56:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CF36840926;
        Fri, 29 May 2020 11:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1590753371; bh=L3nqExQdt9Th8F85LswZf1/Mv1pXFYVFvvkgMUD9fAg=;
        h=Date:From:Subject:To:Cc:From;
        b=GGa09UmroPcaHihHX47BqGh70zcc+ZUxr6hVublp67rA30nGe+PrAyYVkKPfYzIJ8
         AREg3SxII9z2nIez0Wcs1+2OeYjdKJTNLldBSmN1SQybovuvgbYHMCy//tm1AYkFUU
         0/y2Ew6XUe62vMqFTyRWZgOMbtki5pcIr3fe5PAUaMe2c4j9yFct7XB12m2Dgsprpp
         7WOOaIfqWHtZUntAZrcohzuSW7l0MuaJ26mxip+RsBDTiW0/zwU/fVMII1hdIUJN9v
         JDgYnZE+bPONM+zFcjvxyeXCm+dIdU4LyiLGGehcm8m3ml45JRn9SN2sfNYWEU6ioa
         CYRO8d2sTshQA==
Received: from hminas-z420 (hminas-z420.internal.synopsys.com [10.116.126.211])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 892F4A005B;
        Fri, 29 May 2020 11:56:06 +0000 (UTC)
Received: by hminas-z420 (sSMTP sendmail emulation); Fri, 29 May 2020 15:56:05 +0400
Date:   Fri, 29 May 2020 15:56:05 +0400
Message-Id: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        "Heiko Stuebner" <heiko.stuebner@collabora.com>,
        Douglas Anderson <dianders@chromium.org>
Cc:     stable@vger.kernel.org, Frank Mori Hess <fmh6jj@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To avoid lot of interrupts from dwc2 core, which can be asserted in
specific conditions need to disable interrupts on HW level instead of
disable IRQs on Kernel level, because of IRQ can be shared between
drivers.

Cc: stable@vger.kernel.org
Fixes: a40a00318c7fc ("usb: dwc2: add shutdown callback to platform variant")
Tested-by: Frank Mori Hess <fmh6jj@gmail.com>
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
---
 drivers/usb/dwc2/platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index e571c8ae65ec..ada5b66b948e 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -342,7 +342,7 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
 {
 	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
 
-	disable_irq(hsotg->irq);
+	dwc2_disable_global_interrupts(hsotg);
 }
 
 /**
-- 
2.11.0

