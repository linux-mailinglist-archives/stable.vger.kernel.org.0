Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7813C2EAA
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhGJC17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233774AbhGJC1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C6E8613EE;
        Sat, 10 Jul 2021 02:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883858;
        bh=YrfJ8dKNlutmPddgbdWUgLKsXiT8/9F7vm9xuBCNROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LohcSiLw+xZ5e4GoC75g9riK4udG9XYQCc4PcaMGJnsUgLMDCjJfAv++Dqhu0UN4v
         rIznJ3+pIC2Vqe20HtQHEqxMqV3nqpe40LaZdL9aGb82cbqilum+F3/oHtlaF7ITb6
         tHlSuizdkMLqjEJmZ97asAz3vZjV8p3KtSXn2FrxA7Q3sj4anED2x3PD8WZhLuFoKX
         WksttdZNSAxCW8/sZmOvvhnYm5R/V/V98gi3dlstU9S7Flsr2N8AZ07VYvShecq3pd
         0ufV/ScPQB+XzDRck5wUGQRsBE5+JFidrcJBMlux9M0SJJPtCPmiYXhkfYnFbTUClb
         ZZhNAEn+OyErA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 100/104] intel_th: Wait until port is in reset before programming it
Date:   Fri,  9 Jul 2021 22:21:52 -0400
Message-Id: <20210710022156.3168825-100-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit ab1afed701d2db7eb35c1a2526a29067a38e93d1 ]

Some devices don't drain their pipelines if we don't make sure that
the corresponding output port is in reset before programming it for
a new trace capture, resulting in bits of old trace appearing in the
new trace capture. Fix that by explicitly making sure the reset is
asserted before programming new trace capture.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20210621151246.31891-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/core.c     | 17 +++++++++++++++++
 drivers/hwtracing/intel_th/gth.c      | 16 ++++++++++++++++
 drivers/hwtracing/intel_th/intel_th.h |  3 +++
 3 files changed, 36 insertions(+)

diff --git a/drivers/hwtracing/intel_th/core.c b/drivers/hwtracing/intel_th/core.c
index c9ac3dc65113..9cb8c7d13d46 100644
--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -215,6 +215,22 @@ static ssize_t port_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_RO(port);
 
+static void intel_th_trace_prepare(struct intel_th_device *thdev)
+{
+	struct intel_th_device *hub = to_intel_th_hub(thdev);
+	struct intel_th_driver *hubdrv = to_intel_th_driver(hub->dev.driver);
+
+	if (hub->type != INTEL_TH_SWITCH)
+		return;
+
+	if (thdev->type != INTEL_TH_OUTPUT)
+		return;
+
+	pm_runtime_get_sync(&thdev->dev);
+	hubdrv->prepare(hub, &thdev->output);
+	pm_runtime_put(&thdev->dev);
+}
+
 static int intel_th_output_activate(struct intel_th_device *thdev)
 {
 	struct intel_th_driver *thdrv =
@@ -235,6 +251,7 @@ static int intel_th_output_activate(struct intel_th_device *thdev)
 	if (ret)
 		goto fail_put;
 
+	intel_th_trace_prepare(thdev);
 	if (thdrv->activate)
 		ret = thdrv->activate(thdev);
 	else
diff --git a/drivers/hwtracing/intel_th/gth.c b/drivers/hwtracing/intel_th/gth.c
index 28509b02a0b5..b3308934a687 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -564,6 +564,21 @@ static void gth_tscu_resync(struct gth_device *gth)
 	iowrite32(reg, gth->base + REG_TSCU_TSUCTRL);
 }
 
+static void intel_th_gth_prepare(struct intel_th_device *thdev,
+				 struct intel_th_output *output)
+{
+	struct gth_device *gth = dev_get_drvdata(&thdev->dev);
+	int count;
+
+	/*
+	 * Wait until the output port is in reset before we start
+	 * programming it.
+	 */
+	for (count = GTH_PLE_WAITLOOP_DEPTH;
+	     count && !(gth_output_get(gth, output->port) & BIT(5)); count--)
+		cpu_relax();
+}
+
 /**
  * intel_th_gth_enable() - enable tracing to an output device
  * @thdev:	GTH device
@@ -815,6 +830,7 @@ static struct intel_th_driver intel_th_gth_driver = {
 	.assign		= intel_th_gth_assign,
 	.unassign	= intel_th_gth_unassign,
 	.set_output	= intel_th_gth_set_output,
+	.prepare	= intel_th_gth_prepare,
 	.enable		= intel_th_gth_enable,
 	.trig_switch	= intel_th_gth_switch,
 	.disable	= intel_th_gth_disable,
diff --git a/drivers/hwtracing/intel_th/intel_th.h b/drivers/hwtracing/intel_th/intel_th.h
index 5fe694708b7a..595615b79108 100644
--- a/drivers/hwtracing/intel_th/intel_th.h
+++ b/drivers/hwtracing/intel_th/intel_th.h
@@ -143,6 +143,7 @@ intel_th_output_assigned(struct intel_th_device *thdev)
  * @remove:	remove method
  * @assign:	match a given output type device against available outputs
  * @unassign:	deassociate an output type device from an output port
+ * @prepare:	prepare output port for tracing
  * @enable:	enable tracing for a given output device
  * @disable:	disable tracing for a given output device
  * @irq:	interrupt callback
@@ -164,6 +165,8 @@ struct intel_th_driver {
 					  struct intel_th_device *othdev);
 	void			(*unassign)(struct intel_th_device *thdev,
 					    struct intel_th_device *othdev);
+	void			(*prepare)(struct intel_th_device *thdev,
+					   struct intel_th_output *output);
 	void			(*enable)(struct intel_th_device *thdev,
 					  struct intel_th_output *output);
 	void			(*trig_switch)(struct intel_th_device *thdev,
-- 
2.30.2

