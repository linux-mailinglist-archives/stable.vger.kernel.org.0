Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C93226A93
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgGTQgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731181AbgGTPxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:53:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62D982064B;
        Mon, 20 Jul 2020 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260411;
        bh=X247JY9DKVxhOAz9dukBO7UpM2Cd9fXC5aQn9AcfBA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wv6ZHV+sMojkCwnnjLAZCi6isaJpCzbNoJRCdWcSzpeV05kM/CpPuT4ZaOGbTmBFc
         EEkG0WBgKRkIduxn6CGB1E/g5cWULA4+Kwzlrv+RdxG0hVHqbmpmh3t/gcyUn4m9id
         7eI0OqBlWHSfu2m7t6dz+VyN/+6TAXWG97dP6D00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.19 092/133] usb: chipidea: core: add wakeup support for extcon
Date:   Mon, 20 Jul 2020 17:37:19 +0200
Message-Id: <20200720152808.164065691@linuxfoundation.org>
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
@@ -1154,6 +1154,29 @@ static void ci_controller_suspend(struct
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
@@ -1186,6 +1209,7 @@ static int ci_controller_resume(struct d
 		enable_irq(ci->irq);
 		if (ci_otg_is_fsm_mode(ci))
 			ci_otg_fsm_wakeup_by_srp(ci);
+		ci_extcon_wakeup_int(ci);
 	}
 
 	return 0;


