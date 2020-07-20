Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25822264C3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbgGTPr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbgGTPrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660212064B;
        Mon, 20 Jul 2020 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260074;
        bh=FGnwM50zHZ0mVmgqBARzn0ajromP7nURH69nQyHiNHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0+GHNJB86b3r6wFmYZiy/ZcLpEHB5iKWDzUUAUu4NtfQlOL21w8h1WrzIIlZ1rKE
         bgdBritGTNP8P7UYnV1nKMfwcVIVPJhdx7p9uRzcGmCYJGcGDo/h4JhrzvUUyhdAbB
         VeBX1W5KNLNshJZOIFPNkNKZvyHftyTPI8br4X3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Mori Hess <fmh6jj@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.14 098/125] usb: dwc2: Fix shutdown callback in platform
Date:   Mon, 20 Jul 2020 17:37:17 +0200
Message-Id: <20200720152807.750097320@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 4fdf228cdf6925af45a2066d403821e0977bfddb upstream.

To avoid lot of interrupts from dwc2 core, which can be asserted in
specific conditions need to disable interrupts on HW level instead of
disable IRQs on Kernel level, because of IRQ can be shared between
drivers.

Cc: stable@vger.kernel.org
Fixes: a40a00318c7fc ("usb: dwc2: add shutdown callback to platform variant")
Tested-by: Frank Mori Hess <fmh6jj@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Frank Mori Hess <fmh6jj@gmail.com>
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/platform.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -338,7 +338,8 @@ static void dwc2_driver_shutdown(struct
 {
 	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
 
-	disable_irq(hsotg->irq);
+	dwc2_disable_global_interrupts(hsotg);
+	synchronize_irq(hsotg->irq);
 }
 
 /**


