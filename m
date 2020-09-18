Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C019A26EB65
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgIRCEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbgIRCEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F7C23600;
        Fri, 18 Sep 2020 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394690;
        bh=edvpvBXgzkA1HGw8xxSPpBS1Btl6werh9kXB01ts0TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOgOuLGNtK0lt/eN91s32G4fGuTD+sBixN3Gl0pmuhmhvEObUWgUCK0G1dKEbiltZ
         1uZ8SwwwjXasnPpDc5GthRmlWKVIVPMEDuSW+/bpXsvWee/kf2YmL4C6XXww2QFxgL
         2JxFjCNUPi6VnXokMWDOX/OVvKbvHZoGPJ0tLZCM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 179/330] intel_th: Disallow multi mode on devices where it's broken
Date:   Thu, 17 Sep 2020 21:58:39 -0400
Message-Id: <20200918020110.2063155-179-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit 397c7729665a3b07a7b4ce7215173df8e9112809 ]

Some versions of Intel TH have an issue that prevents the multi mode of
MSU from working correctly, resulting in no trace data and potentially
stuck MSU pipeline.

Disable multi mode on such devices.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200317062215.15598-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/intel_th.h |  2 ++
 drivers/hwtracing/intel_th/msu.c      | 11 +++++++++--
 drivers/hwtracing/intel_th/pci.c      |  8 ++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/intel_th/intel_th.h b/drivers/hwtracing/intel_th/intel_th.h
index 6f4f5486fe6dc..5fe694708b7a3 100644
--- a/drivers/hwtracing/intel_th/intel_th.h
+++ b/drivers/hwtracing/intel_th/intel_th.h
@@ -47,11 +47,13 @@ struct intel_th_output {
 /**
  * struct intel_th_drvdata - describes hardware capabilities and quirks
  * @tscu_enable:	device needs SW to enable time stamping unit
+ * @multi_is_broken:	device has multiblock mode is broken
  * @has_mintctl:	device has interrupt control (MINTCTL) register
  * @host_mode_only:	device can only operate in 'host debugger' mode
  */
 struct intel_th_drvdata {
 	unsigned int	tscu_enable        : 1,
+			multi_is_broken    : 1,
 			has_mintctl        : 1,
 			host_mode_only     : 1;
 };
diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 255f8f41c8ff7..3cd2489d398c5 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -157,7 +157,8 @@ struct msc {
 	/* config */
 	unsigned int		enabled : 1,
 				wrap	: 1,
-				do_irq	: 1;
+				do_irq	: 1,
+				multi_is_broken : 1;
 	unsigned int		mode;
 	unsigned int		burst_len;
 	unsigned int		index;
@@ -1665,7 +1666,7 @@ static int intel_th_msc_init(struct msc *msc)
 {
 	atomic_set(&msc->user_count, -1);
 
-	msc->mode = MSC_MODE_MULTI;
+	msc->mode = msc->multi_is_broken ? MSC_MODE_SINGLE : MSC_MODE_MULTI;
 	mutex_init(&msc->buf_mutex);
 	INIT_LIST_HEAD(&msc->win_list);
 	INIT_LIST_HEAD(&msc->iter_list);
@@ -1877,6 +1878,9 @@ mode_store(struct device *dev, struct device_attribute *attr, const char *buf,
 	return -EINVAL;
 
 found:
+	if (i == MSC_MODE_MULTI && msc->multi_is_broken)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&msc->buf_mutex);
 	ret = 0;
 
@@ -2083,6 +2087,9 @@ static int intel_th_msc_probe(struct intel_th_device *thdev)
 	if (!res)
 		msc->do_irq = 1;
 
+	if (INTEL_TH_CAP(to_intel_th(thdev), multi_is_broken))
+		msc->multi_is_broken = 1;
+
 	msc->index = thdev->id;
 
 	msc->thdev = thdev;
diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 0d26484d67955..21fdf0b935166 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -120,6 +120,10 @@ static void intel_th_pci_remove(struct pci_dev *pdev)
 	pci_free_irq_vectors(pdev);
 }
 
+static const struct intel_th_drvdata intel_th_1x_multi_is_broken = {
+	.multi_is_broken	= 1,
+};
+
 static const struct intel_th_drvdata intel_th_2x = {
 	.tscu_enable	= 1,
 	.has_mintctl	= 1,
@@ -152,7 +156,7 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 	{
 		/* Kaby Lake PCH-H */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa2a6),
-		.driver_data = (kernel_ulong_t)0,
+		.driver_data = (kernel_ulong_t)&intel_th_1x_multi_is_broken,
 	},
 	{
 		/* Denverton */
@@ -207,7 +211,7 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 	{
 		/* Comet Lake PCH-V */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa3a6),
-		.driver_data = (kernel_ulong_t)&intel_th_2x,
+		.driver_data = (kernel_ulong_t)&intel_th_1x_multi_is_broken,
 	},
 	{
 		/* Ice Lake NNPI */
-- 
2.25.1

