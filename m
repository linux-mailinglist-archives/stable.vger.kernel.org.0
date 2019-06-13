Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE1943FB5
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbfFMP7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731481AbfFMIti (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:49:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C582206BA;
        Thu, 13 Jun 2019 08:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415777;
        bh=YL8MIoVT72q5kWa4/vm5yvnqtrpUHTG172GFL97hqFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbuOSLg4fECNBEAaHFhCC2HVVaYWK95fl4uWPdkwFdCcNlvv6bahllZcfpiSLdsnI
         6fzuYrYbL8QmVmE83rtYfzGqvOkxocxV2NMJcJH0b/lW1RebmFK4w69vFsC4QRQIyg
         rW0QuyEP7d7Djf0xbu/Bn37QldizRGRHFDArHNQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Binbin Wu <binbin.wu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 119/155] pinctrl: pinctrl-intel: move gpio suspend/resume to noirq phase
Date:   Thu, 13 Jun 2019 10:33:51 +0200
Message-Id: <20190613075659.546693851@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2fef32766861c6e171f436ab99c89198cf0ca6e1 ]

In current driver, SET_LATE_SYSTEM_SLEEP_PM_OPS is used to install the
callbacks for suspend/resume.
GPIO pin may be used as the interrupt pin by some device. However, using
SET_LATE_SYSTEM_SLEEP_PM_OPS() to install the callbacks, the resume
callback is called after resume_device_irqs(). Unintended interrupts may
arrive due to resuming device irqs first, but the GPIO controller is not
properly restored.

Normally, for a SMP system, there are multiple cores, so even when there are
unintended interrupts, BSP gets the chance to initialize the GPIO chip soon.
But when there is only 1 core is active (other cores are offlined or
single core) during resume, it is more easily to observe the unintended
interrupts.

This patch renames the suspend/resume function by adding suffix "_noirq",
and installs the callbacks using SET_NOIRQ_SYSTEM_SLEEP_PM_OPS().

Signed-off-by: Binbin Wu <binbin.wu@intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c |  8 ++++----
 drivers/pinctrl/intel/pinctrl-intel.h | 11 ++++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 3b1818184207..70638b74f9d6 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1466,7 +1466,7 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	return false;
 }
 
-int intel_pinctrl_suspend(struct device *dev)
+int intel_pinctrl_suspend_noirq(struct device *dev)
 {
 	struct intel_pinctrl *pctrl = dev_get_drvdata(dev);
 	struct intel_community_context *communities;
@@ -1505,7 +1505,7 @@ int intel_pinctrl_suspend(struct device *dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(intel_pinctrl_suspend);
+EXPORT_SYMBOL_GPL(intel_pinctrl_suspend_noirq);
 
 static void intel_gpio_irq_init(struct intel_pinctrl *pctrl)
 {
@@ -1527,7 +1527,7 @@ static void intel_gpio_irq_init(struct intel_pinctrl *pctrl)
 	}
 }
 
-int intel_pinctrl_resume(struct device *dev)
+int intel_pinctrl_resume_noirq(struct device *dev)
 {
 	struct intel_pinctrl *pctrl = dev_get_drvdata(dev);
 	const struct intel_community_context *communities;
@@ -1589,7 +1589,7 @@ int intel_pinctrl_resume(struct device *dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(intel_pinctrl_resume);
+EXPORT_SYMBOL_GPL(intel_pinctrl_resume_noirq);
 #endif
 
 MODULE_AUTHOR("Mathias Nyman <mathias.nyman@linux.intel.com>");
diff --git a/drivers/pinctrl/intel/pinctrl-intel.h b/drivers/pinctrl/intel/pinctrl-intel.h
index b8a07d37d18f..a8e958f1dcf5 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.h
+++ b/drivers/pinctrl/intel/pinctrl-intel.h
@@ -177,13 +177,14 @@ int intel_pinctrl_probe_by_hid(struct platform_device *pdev);
 int intel_pinctrl_probe_by_uid(struct platform_device *pdev);
 
 #ifdef CONFIG_PM_SLEEP
-int intel_pinctrl_suspend(struct device *dev);
-int intel_pinctrl_resume(struct device *dev);
+int intel_pinctrl_suspend_noirq(struct device *dev);
+int intel_pinctrl_resume_noirq(struct device *dev);
 #endif
 
-#define INTEL_PINCTRL_PM_OPS(_name)						  \
-const struct dev_pm_ops _name = {						  \
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(intel_pinctrl_suspend, intel_pinctrl_resume) \
+#define INTEL_PINCTRL_PM_OPS(_name)					\
+const struct dev_pm_ops _name = {					\
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(intel_pinctrl_suspend_noirq,	\
+				      intel_pinctrl_resume_noirq)	\
 }
 
 #endif /* PINCTRL_INTEL_H */
-- 
2.20.1



