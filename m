Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460E327C8C8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgI2MEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbgI2Lhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D995820848;
        Tue, 29 Sep 2020 11:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379461;
        bh=edvpvBXgzkA1HGw8xxSPpBS1Btl6werh9kXB01ts0TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOYB5U8mTNpuu3vyRjH1pjWKvmOntmFiQic47Wm6os2SfCSEom3m6cA7RP8YFoNDa
         sWJQO0bi3azCwkyGngP4NuzFhxW2h8WOxrPuXvAzVAj9duOWmVrF1RckM3/azVE9ql
         xFac1vCiR417dt1zwnU2K8qHMsSA7FqgOVxGKrMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/388] intel_th: Disallow multi mode on devices where its broken
Date:   Tue, 29 Sep 2020 12:58:24 +0200
Message-Id: <20200929110018.858657555@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



