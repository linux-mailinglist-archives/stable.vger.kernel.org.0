Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56DC3CDF75
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343614AbhGSPK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343663AbhGSPI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C589261364;
        Mon, 19 Jul 2021 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709707;
        bh=YrfJ8dKNlutmPddgbdWUgLKsXiT8/9F7vm9xuBCNROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYGpnVPflGYjpd5Ts+MtHrvzhQzsCkUu1ub/Ae6o1NltxYRE1rzylWz6AiRWNH+bY
         t5fgvy5QMB273CrF4rC+tZH75Kc9YQzj01hfSruddy8fACnY/XQU/qMjw25YQKacxw
         zOfY7k23CLfAv7z5AFfayMJHWz0H6Ukr5Ay7oyzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/149] intel_th: Wait until port is in reset before programming it
Date:   Mon, 19 Jul 2021 16:52:54 +0200
Message-Id: <20210719144916.966692141@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



