Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BEC501820
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbiDNQB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354500AbiDNPlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 11:41:04 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F38FDEB86
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:21:39 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p21so5744695ioj.4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5sSdpjUHCfybVwprx6qx71sk3MsE1l8j38zhRYOgvA=;
        b=Moo6XNM3QFQ6RSDOTHIY7p+uNAfyOR/+d8vU6R9FIgI2Tlmb+epkdj40Q5/MfpeKav
         6gmOeHsMvuycp/Irnrm+ZZfU9u9xdpnKz64tlvq6isd+GcN1hwH6FxjoQtt70RTMdk2n
         uFdKDCsNWCxQ7TwhNvyxaSKpnvg7wJVJXIXi6SU4tRwS20eS8lmUUppROMYsBhYIETp0
         TZXdivJOYzXbFhSF0LfFSOhhLdYxKMlQIhTIsPfwd85B/mKShFz4nAL51P0zAyIKZCMt
         bQ/s2rcXX8iONafoZZMCDOL9N8kzhUuq9HJFpxdV1wqa6gM50VpDK0by+dkOipo0Pj+0
         HAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5sSdpjUHCfybVwprx6qx71sk3MsE1l8j38zhRYOgvA=;
        b=U2QeB1hLs2D5U0qHUWGrftOgMK5pWrbAuBtKDQmJ4l8DKpskUqcMNdVR6RiiSgdE5J
         u49VHGyhfN3OgmtMa2KEpkyBalOy0zcShoDk3hI9HNk8QdCniu7fnLDyxxm9Bfg4Fgab
         StNOKWQKTNYDrpZstW3dYMbJ4PdByA94RuANu6dJvhWNUSdtGu4pU/WeLXSEHzqbNgVy
         5xYRd4ZsY/YlXy+zPXyEWFyTi+I4iwhzonOf2x2+329WP2IQsrqYIPtahhq+MjLc1r/a
         GETW/0KsR72vsMEDgGdzaqDq13xs3oRdJbxJyTGSEj/K6wFw9avrl9OVeOKLOeWMtFN3
         0o/A==
X-Gm-Message-State: AOAM533MEvAZw0F+0vfhEtJ2xC6bZ1jkpzcGXQQLo1gXnFw8M7B192bq
        vMgiyzqyzXjFRJ/9bRU0OuVICTbKp/VxnQ==
X-Google-Smtp-Source: ABdhPJzkaPuFMxPPSJ68GRGOVPeU9uwrRgiopfVGEf0IUCxq48MruByWzdztYpC2h3bYVdHU2+kHGw==
X-Received: by 2002:a05:6602:27c5:b0:631:a30f:143a with SMTP id l5-20020a05660227c500b00631a30f143amr1378062ios.40.1649949698601;
        Thu, 14 Apr 2022 08:21:38 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2-20020a056602160200b006463c1977f9sm1365395iow.22.2022.04.14.08.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 08:21:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org, quic_clew@quicinc.com,
        quic_deesin@quicinc.com, swboyd@chromium.org, elder@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH v2 3/3] net: ipa: request IPA register values be retained
Date:   Thu, 14 Apr 2022 10:21:31 -0500
Message-Id: <20220414152131.713724-4-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220414152131.713724-1-elder@linaro.org>
References: <20220414152131.713724-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/net/ipa/ipa_power.c | 52 +++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_power.h |  7 +++++
 drivers/net/ipa/ipa_uc.c    |  5 ++++
 3 files changed, 64 insertions(+)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index b1c6c0fcb654f..f2989aac47a62 100644
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
@@ -382,6 +386,47 @@ void ipa_power_modem_queue_active(struct ipa *ipa)
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
@@ -438,12 +483,18 @@ ipa_power_init(struct device *dev, const struct ipa_power_data *data)
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
@@ -460,6 +511,7 @@ void ipa_power_exit(struct ipa_power *power)
 
 	pm_runtime_disable(dev);
 	pm_runtime_dont_use_autosuspend(dev);
+	ipa_power_retention_exit(power);
 	ipa_interconnect_exit(power);
 	kfree(power);
 	clk_put(clk);
diff --git a/drivers/net/ipa/ipa_power.h b/drivers/net/ipa/ipa_power.h
index 2151805d7fbb0..6f84f057a2095 100644
--- a/drivers/net/ipa/ipa_power.h
+++ b/drivers/net/ipa/ipa_power.h
@@ -40,6 +40,13 @@ void ipa_power_modem_queue_wake(struct ipa *ipa);
  */
 void ipa_power_modem_queue_active(struct ipa *ipa);
 
+/**
+ * ipa_power_retention() - Control register retention on power collapse
+ * @ipa:	IPA pointer
+ * @enable:	Whether retention should be enabled or disabled
+ */
+void ipa_power_retention(struct ipa *ipa, bool enable);
+
 /**
  * ipa_power_setup() - Set up IPA power management
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 856e55a080a7f..fe11910518d95 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -11,6 +11,7 @@
 
 #include "ipa.h"
 #include "ipa_uc.h"
+#include "ipa_power.h"
 
 /**
  * DOC:  The IPA embedded microcontroller
@@ -154,6 +155,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
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
 
-- 
2.32.0

