Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28414A96B9
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357862AbiBDJ26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:28:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45824 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358109AbiBDJ1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:27:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1652461602;
        Fri,  4 Feb 2022 09:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA12DC004E1;
        Fri,  4 Feb 2022 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966828;
        bh=jhYVlAq+c39CVsH+sSlPV4y+433+nEv9z7fvwQl2K7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HggUP5HNJAmcCiNPq6zdR3wDaYVAfgttSjRrFIJsd0sY4UNPtYwoQSvVhOslsOy3P
         TaoNo2G3ae0xWSQsaYH6YLfu/nNRemHLFqIhm3nwP6lwbzZoP4S9zPbsZ+SlKmOGHe
         ptFQxThqRK4cGAi8dFBfaApO1C9e7qPL7dm8Mmjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 37/43] net: ipa: request IPA register values be retained
Date:   Fri,  4 Feb 2022 10:22:44 +0100
Message-Id: <20220204091918.370849377@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit 34a081761e4e3c35381cbfad609ebae2962fe2f8 upstream.

In some cases, the IPA hardware needs to request the always-on
subsystem (AOSS) to coordinate with the IPA microcontroller to
retain IPA register values at power collapse.  This is done by
issuing a QMP request to the AOSS microcontroller.  A similar
request ondoes that request.

We must get and hold the "QMP" handle early, because we might get
back EPROBE_DEFER for that.  But the actual request should be sent
while we know the IPA clock is active, and when we know the
microcontroller is operational.

Fixes: 1aac309d3207 ("net: ipa: use autosuspend")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_power.c |   52 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_power.h |    7 +++++
 drivers/net/ipa/ipa_uc.c    |    5 ++++
 3 files changed, 64 insertions(+)

--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -11,6 +11,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/bitops.h>
 
+#include "linux/soc/qcom/qcom_aoss.h"
+
 #include "ipa.h"
 #include "ipa_power.h"
 #include "ipa_endpoint.h"
@@ -64,6 +66,7 @@ enum ipa_power_flag {
  * struct ipa_power - IPA power management information
  * @dev:		IPA device pointer
  * @core:		IPA core clock
+ * @qmp:		QMP handle for AOSS communication
  * @spinlock:		Protects modem TX queue enable/disable
  * @flags:		Boolean state flags
  * @interconnect_count:	Number of elements in interconnect[]
@@ -72,6 +75,7 @@ enum ipa_power_flag {
 struct ipa_power {
 	struct device *dev;
 	struct clk *core;
+	struct qmp *qmp;
 	spinlock_t spinlock;	/* used with STOPPED/STARTED power flags */
 	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
 	u32 interconnect_count;
@@ -382,6 +386,47 @@ void ipa_power_modem_queue_active(struct
 	clear_bit(IPA_POWER_FLAG_STARTED, ipa->power->flags);
 }
 
+static int ipa_power_retention_init(struct ipa_power *power)
+{
+	struct qmp *qmp = qmp_get(power->dev);
+
+	if (IS_ERR(qmp)) {
+		if (PTR_ERR(qmp) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		/* We assume any other error means it's not defined/needed */
+		qmp = NULL;
+	}
+	power->qmp = qmp;
+
+	return 0;
+}
+
+static void ipa_power_retention_exit(struct ipa_power *power)
+{
+	qmp_put(power->qmp);
+	power->qmp = NULL;
+}
+
+/* Control register retention on power collapse */
+void ipa_power_retention(struct ipa *ipa, bool enable)
+{
+	static const char fmt[] = "{ class: bcm, res: ipa_pc, val: %c }";
+	struct ipa_power *power = ipa->power;
+	char buf[36];	/* Exactly enough for fmt[]; size a multiple of 4 */
+	int ret;
+
+	if (!power->qmp)
+		return;		/* Not needed on this platform */
+
+	(void)snprintf(buf, sizeof(buf), fmt, enable ? '1' : '0');
+
+	ret = qmp_send(power->qmp, buf, sizeof(buf));
+	if (ret)
+		dev_err(power->dev, "error %d sending QMP %sable request\n",
+			ret, enable ? "en" : "dis");
+}
+
 int ipa_power_setup(struct ipa *ipa)
 {
 	int ret;
@@ -438,12 +483,18 @@ ipa_power_init(struct device *dev, const
 	if (ret)
 		goto err_kfree;
 
+	ret = ipa_power_retention_init(power);
+	if (ret)
+		goto err_interconnect_exit;
+
 	pm_runtime_set_autosuspend_delay(dev, IPA_AUTOSUSPEND_DELAY);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
 	return power;
 
+err_interconnect_exit:
+	ipa_interconnect_exit(power);
 err_kfree:
 	kfree(power);
 err_clk_put:
@@ -460,6 +511,7 @@ void ipa_power_exit(struct ipa_power *po
 
 	pm_runtime_disable(dev);
 	pm_runtime_dont_use_autosuspend(dev);
+	ipa_power_retention_exit(power);
 	ipa_interconnect_exit(power);
 	kfree(power);
 	clk_put(clk);
--- a/drivers/net/ipa/ipa_power.h
+++ b/drivers/net/ipa/ipa_power.h
@@ -41,6 +41,13 @@ void ipa_power_modem_queue_wake(struct i
 void ipa_power_modem_queue_active(struct ipa *ipa);
 
 /**
+ * ipa_power_retention() - Control register retention on power collapse
+ * @ipa:	IPA pointer
+ * @enable:	Whether retention should be enabled or disabled
+ */
+void ipa_power_retention(struct ipa *ipa, bool enable);
+
+/**
  * ipa_power_setup() - Set up IPA power management
  * @ipa:	IPA pointer
  *
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -11,6 +11,7 @@
 
 #include "ipa.h"
 #include "ipa_uc.h"
+#include "ipa_power.h"
 
 /**
  * DOC:  The IPA embedded microcontroller
@@ -154,6 +155,7 @@ static void ipa_uc_response_hdlr(struct
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
 		if (ipa->uc_powered) {
 			ipa->uc_loaded = true;
+			ipa_power_retention(ipa, true);
 			pm_runtime_mark_last_busy(dev);
 			(void)pm_runtime_put_autosuspend(dev);
 			ipa->uc_powered = false;
@@ -184,6 +186,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
 
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
+	if (ipa->uc_loaded)
+		ipa_power_retention(ipa, false);
+
 	if (!ipa->uc_powered)
 		return;
 


