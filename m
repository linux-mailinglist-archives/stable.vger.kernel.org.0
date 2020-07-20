Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441AF226A92
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbgGTPx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731185AbgGTPx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:53:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689552064B;
        Mon, 20 Jul 2020 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260408;
        bh=O7oxE+ZgMEmpcUAPuTEVSBn4PvQogEjRMMdnjHQfhDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFDlqkDc37cD7JxBFtFBp29CsRnF+ll4VuomUl6R5rkpWKlcMYHWsROHhSPocAQsW
         757hmxLanf+NJ8QNzbzX7uH2MaAo3mALXs7IU/Bd/0/lVQoLajZzoWTZGJLglzf7/b
         APd+JDwyrHbjIfFDCkr7T+Ks615toOiVpJIt4AxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Mori Hess <fmh6jj@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 091/133] usb: dwc2: Fix shutdown callback in platform
Date:   Mon, 20 Jul 2020 17:37:18 +0200
Message-Id: <20200720152808.121397489@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
@@ -349,7 +349,8 @@ static void dwc2_driver_shutdown(struct
 {
 	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
 
-	disable_irq(hsotg->irq);
+	dwc2_disable_global_interrupts(hsotg);
+	synchronize_irq(hsotg->irq);
 }
 
 /**


