Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0015366D7D
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfGLMaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbfGLMaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:30:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3BEC216C4;
        Fri, 12 Jul 2019 12:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934624;
        bh=mOI4f+8M6MD8y67Qh6fR5ZdRMmZi5fzudA5PS0kp1Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFkh71nvoc+f4yJs0TDfUxIz01mgSDSoDYQMjgY4WVrKVPaS/qaukYCtkFkF8tEfS
         2RgDum19A+eAzlCUcL6ETGBBc9u0b3tpopLbnNvPUqbHI8R03jrp6s/r3YWNYj0EdU
         FAb+KqQQh+J49SoNFgPYuVFbMfb4ISgCRswx7/tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.1 114/138] usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()
Date:   Fri, 12 Jul 2019 14:19:38 +0200
Message-Id: <20190712121633.125684870@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit dfc4fdebc5d62ac4e2fe5428e59b273675515fb2 upstream.

Use a 10000us AHB idle timeout in dwc2_core_reset() and make it
consistent with the other "wait for AHB master IDLE state" ocurrences.

This fixes a problem for me where dwc2 would not want to initialize when
updating to 4.19 on a MIPS Lantiq VRX200 SoC. dwc2 worked fine with
4.14.
Testing on my board shows that it takes 180us until AHB master IDLE
state is signalled. The very old vendor driver for this SoC (ifxhcd)
used a 1 second timeout.
Use the same timeout that is used everywhere when polling for
GRSTCTL_AHBIDLE instead of using a timeout that "works for one board"
(180us in my case) to have consistent behavior across the dwc2 driver.

Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -531,7 +531,7 @@ int dwc2_core_reset(struct dwc2_hsotg *h
 	}
 
 	/* Wait for AHB master IDLE state */
-	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 50)) {
+	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 10000)) {
 		dev_warn(hsotg->dev, "%s: HANG! AHB Idle timeout GRSTCTL GRSTCTL_AHBIDLE\n",
 			 __func__);
 		return -EBUSY;


