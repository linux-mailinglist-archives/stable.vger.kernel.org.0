Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4664921662F
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 08:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgGGGGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 02:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgGGGGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 02:06:17 -0400
Received: from localhost.localdomain (unknown [222.67.222.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E5BE20771;
        Tue,  7 Jul 2020 06:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594101977;
        bh=iaUBPSiNhXhrCz/hJLU62IegeXbcIEx+RGFPFono3gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvLl/xxLjxIZMeK9hrV3VPstzjzS5HLck03WwH9apg81n8uRNadlisdYvL+3SOQRl
         1M0Ktk8KBmEkBrJ0nUYN/SS++k5RoykVaWjB8qGtj0Bkof2B0xfC7IFNIHeLoSmtI8
         PPoC0OPwblT1bTuxz0DSaBzccCGu6EcPDeWzMHuA=
From:   Peter Chen <peter.chen@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] usb: chipidea: core: add wakeup support for extcon
Date:   Tue,  7 Jul 2020 14:06:01 +0800
Message-Id: <20200707060601.31907-2-peter.chen@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200707060601.31907-1-peter.chen@kernel.org>
References: <20200707060601.31907-1-peter.chen@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

If wakeup event occurred by extcon event, it needs to call
ci_irq again since the first ci_irq calling at extcon notifier
only wakes up controller, but do noop for event handling,
it causes the extcon use case can't work well from low power mode.

Cc: <stable@vger.kernel.org>
Fixes: 3ecb3e09b042 ("usb: chipidea: Use extcon framework for VBUS and ID detect")
Reported-by: Philippe Schenker <philippe.schenker@toradex.com>
Tested-by: Philippe Schenker <philippe.schenker@toradex.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/chipidea/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 9a7c53d09ab4..bb133245beed 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1243,6 +1243,29 @@ static void ci_controller_suspend(struct ci_hdrc *ci)
 	enable_irq(ci->irq);
 }
 
+/*
+ * Handle the wakeup interrupt triggered by extcon connector
+ * We need to call ci_irq again for extcon since the first
+ * interrupt (wakeup int) only let the controller be out of
+ * low power mode, but not handle any interrupts.
+ */
+static void ci_extcon_wakeup_int(struct ci_hdrc *ci)
+{
+	struct ci_hdrc_cable *cable_id, *cable_vbus;
+	u32 otgsc = hw_read_otgsc(ci, ~0);
+
+	cable_id = &ci->platdata->id_extcon;
+	cable_vbus = &ci->platdata->vbus_extcon;
+
+	if (!IS_ERR(cable_id->edev) && ci->is_otg &&
+		(otgsc & OTGSC_IDIE) && (otgsc & OTGSC_IDIS))
+		ci_irq(ci->irq, ci);
+
+	if (!IS_ERR(cable_vbus->edev) && ci->is_otg &&
+		(otgsc & OTGSC_BSVIE) && (otgsc & OTGSC_BSVIS))
+		ci_irq(ci->irq, ci);
+}
+
 static int ci_controller_resume(struct device *dev)
 {
 	struct ci_hdrc *ci = dev_get_drvdata(dev);
@@ -1275,6 +1298,7 @@ static int ci_controller_resume(struct device *dev)
 		enable_irq(ci->irq);
 		if (ci_otg_is_fsm_mode(ci))
 			ci_otg_fsm_wakeup_by_srp(ci);
+		ci_extcon_wakeup_int(ci);
 	}
 
 	return 0;
-- 
2.17.1

