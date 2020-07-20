Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D011226BFD
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgGTPjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729571AbgGTPjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:39:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C4B22B4E;
        Mon, 20 Jul 2020 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259581;
        bh=BDFxamNvR6BK+Ys6L5BhcPUvwZUhOkwfV9Dm9nCJmvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZcBE2l5VyH6A84uLgUIWzRQ06F9md0hWLj2Y07ssMAkqcVO08gLdwNKdNY7IZb82
         emnWLIMw+DkCSHG11VTxRcjyDfj1GxlKsyXmmsaeGeejluwCUqUHQeFVq4bDH4Jtnd
         oFHQ61RFU6JrApCtFboLUSnaOa8Fh4ThF8OPljgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.4 42/58] usb: chipidea: core: add wakeup support for extcon
Date:   Mon, 20 Jul 2020 17:36:58 +0200
Message-Id: <20200720152749.322220072@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 876d4e1e8298ad1f94d9e9392fc90486755437b4 upstream.

If wakeup event occurred by extcon event, it needs to call
ci_irq again since the first ci_irq calling at extcon notifier
only wakes up controller, but do noop for event handling,
it causes the extcon use case can't work well from low power mode.

Cc: <stable@vger.kernel.org>
Fixes: 3ecb3e09b042 ("usb: chipidea: Use extcon framework for VBUS and ID detect")
Reported-by: Philippe Schenker <philippe.schenker@toradex.com>
Tested-by: Philippe Schenker <philippe.schenker@toradex.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200707060601.31907-2-peter.chen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/core.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1122,6 +1122,29 @@ static void ci_controller_suspend(struct
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
@@ -1148,6 +1171,7 @@ static int ci_controller_resume(struct d
 		enable_irq(ci->irq);
 		if (ci_otg_is_fsm_mode(ci))
 			ci_otg_fsm_wakeup_by_srp(ci);
+		ci_extcon_wakeup_int(ci);
 	}
 
 	return 0;


