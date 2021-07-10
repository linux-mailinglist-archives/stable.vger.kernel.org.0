Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206B83C3171
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhGJClX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235801AbhGJCjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CAB161413;
        Sat, 10 Jul 2021 02:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884560;
        bh=1DNtzbH+tgS8PpZCnsvBYH72S49zNDnHKw0QlEjJDkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5nxJQ6RjbE/3AdFlj12fPIkhmvkMApys0qVDVJl4eiclK0FndhVTTfaPOIQz9+wj
         8swTvaEJ2ncgY/gziNiOYChmBdwaqNJRxLyhqguY/U2+VW8E9/HWuoi92PVUtFXIx3
         AINuTBZ3WVI9/wTMFLGFJvboki0oRlex1yiBHZyvDF5Gick1SnWhF8nEXfNeRMs51m
         JI2i6AVAlWfxu7eXUBnqOYYqtmCTGzaZeqpkshqXclGToF8oOUSBxPdstxLsD7zozz
         NjVreK6WCNZXjkomLSHPGehybeiLRUttm8ztSo0kQK0KMzGHhWt/v36bVUoPKnH8A9
         ZzURk8SyAPlTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 31/33] intel_th: Wait until port is in reset before programming it
Date:   Fri,  9 Jul 2021 22:35:13 -0400
Message-Id: <20210710023516.3172075-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023516.3172075-1-sashal@kernel.org>
References: <20210710023516.3172075-1-sashal@kernel.org>
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
index 6a451b4fc04d..4b270ed7f27b 100644
--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -223,6 +223,22 @@ static ssize_t port_show(struct device *dev, struct device_attribute *attr,
 
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
@@ -243,6 +259,7 @@ static int intel_th_output_activate(struct intel_th_device *thdev)
 	if (ret)
 		goto fail_put;
 
+	intel_th_trace_prepare(thdev);
 	if (thdrv->activate)
 		ret = thdrv->activate(thdev);
 	else
diff --git a/drivers/hwtracing/intel_th/gth.c b/drivers/hwtracing/intel_th/gth.c
index 79473ba48d0c..4edc54448f31 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -521,6 +521,21 @@ static void gth_tscu_resync(struct gth_device *gth)
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
@@ -742,6 +757,7 @@ static struct intel_th_driver intel_th_gth_driver = {
 	.assign		= intel_th_gth_assign,
 	.unassign	= intel_th_gth_unassign,
 	.set_output	= intel_th_gth_set_output,
+	.prepare	= intel_th_gth_prepare,
 	.enable		= intel_th_gth_enable,
 	.disable	= intel_th_gth_disable,
 	.driver	= {
diff --git a/drivers/hwtracing/intel_th/intel_th.h b/drivers/hwtracing/intel_th/intel_th.h
index 99ad563fc40d..093a89e29ce6 100644
--- a/drivers/hwtracing/intel_th/intel_th.h
+++ b/drivers/hwtracing/intel_th/intel_th.h
@@ -140,6 +140,7 @@ intel_th_output_assigned(struct intel_th_device *thdev)
  * @remove:	remove method
  * @assign:	match a given output type device against available outputs
  * @unassign:	deassociate an output type device from an output port
+ * @prepare:	prepare output port for tracing
  * @enable:	enable tracing for a given output device
  * @disable:	disable tracing for a given output device
  * @irq:	interrupt callback
@@ -161,6 +162,8 @@ struct intel_th_driver {
 					  struct intel_th_device *othdev);
 	void			(*unassign)(struct intel_th_device *thdev,
 					    struct intel_th_device *othdev);
+	void			(*prepare)(struct intel_th_device *thdev,
+					   struct intel_th_output *output);
 	void			(*enable)(struct intel_th_device *thdev,
 					  struct intel_th_output *output);
 	void			(*disable)(struct intel_th_device *thdev,
-- 
2.30.2

