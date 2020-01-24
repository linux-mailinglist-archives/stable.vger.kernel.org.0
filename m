Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60F14767F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgAXBR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730427AbgAXBR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9431E21D7D;
        Fri, 24 Jan 2020 01:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828646;
        bh=YgsZRwJQo5NDjLt5Mz+9Gt6+Z3gsDcXgk385OZZSpSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRKXkNMr90SG3qiom6HQ/MM7zJDYFVbpkmKVSwTaSYvUCUvIAQUpgGhZg9l1uLyLb
         Jta+68oL4OekJXt4mHoJqs9GiQfPNCZmuJhQXMHjwDTKI91UXblPq8wgJ+WFWrNTbA
         fWMhfaRMFLSWs1O82cKC9cYVrkJaQ/VupM6lpGOw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 15/33] perf/imx_ddr: Add enhanced AXI ID filter support
Date:   Thu, 23 Jan 2020 20:16:50 -0500
Message-Id: <20200124011708.18232-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 44f8bd014a94ed679ddb77d0b92350d4ac4f23a5 ]

With DDR_CAP_AXI_ID_FILTER quirk, indicating HW supports AXI ID filter
which only can get bursts from DDR transaction, i.e. DDR read/write
requests.

This patch add DDR_CAP_AXI_ID_ENHANCED_FILTER quirk, indicating HW
supports AXI ID filter which can get bursts and bytes from DDR
transaction at the same time. We hope PMU always return bytes in the
driver due to it is more meaningful for users.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 63 +++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index ce7345745b42c..2a3966d059e70 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -45,7 +45,8 @@
 static DEFINE_IDA(ddr_ida);
 
 /* DDR Perf hardware feature */
-#define DDR_CAP_AXI_ID_FILTER          0x1     /* support AXI ID filter */
+#define DDR_CAP_AXI_ID_FILTER			0x1     /* support AXI ID filter */
+#define DDR_CAP_AXI_ID_FILTER_ENHANCED		0x3     /* support enhanced AXI ID filter */
 
 struct fsl_ddr_devtype_data {
 	unsigned int quirks;    /* quirks needed for different DDR Perf core */
@@ -178,6 +179,36 @@ static const struct attribute_group *attr_groups[] = {
 	NULL,
 };
 
+static bool ddr_perf_is_filtered(struct perf_event *event)
+{
+	return event->attr.config == 0x41 || event->attr.config == 0x42;
+}
+
+static u32 ddr_perf_filter_val(struct perf_event *event)
+{
+	return event->attr.config1;
+}
+
+static bool ddr_perf_filters_compatible(struct perf_event *a,
+					struct perf_event *b)
+{
+	if (!ddr_perf_is_filtered(a))
+		return true;
+	if (!ddr_perf_is_filtered(b))
+		return true;
+	return ddr_perf_filter_val(a) == ddr_perf_filter_val(b);
+}
+
+static bool ddr_perf_is_enhanced_filtered(struct perf_event *event)
+{
+	unsigned int filt;
+	struct ddr_pmu *pmu = to_ddr_pmu(event->pmu);
+
+	filt = pmu->devtype_data->quirks & DDR_CAP_AXI_ID_FILTER_ENHANCED;
+	return (filt == DDR_CAP_AXI_ID_FILTER_ENHANCED) &&
+		ddr_perf_is_filtered(event);
+}
+
 static u32 ddr_perf_alloc_counter(struct ddr_pmu *pmu, int event)
 {
 	int i;
@@ -209,27 +240,17 @@ static void ddr_perf_free_counter(struct ddr_pmu *pmu, int counter)
 
 static u32 ddr_perf_read_counter(struct ddr_pmu *pmu, int counter)
 {
-	return readl_relaxed(pmu->base + COUNTER_READ + counter * 4);
-}
-
-static bool ddr_perf_is_filtered(struct perf_event *event)
-{
-	return event->attr.config == 0x41 || event->attr.config == 0x42;
-}
+	struct perf_event *event = pmu->events[counter];
+	void __iomem *base = pmu->base;
 
-static u32 ddr_perf_filter_val(struct perf_event *event)
-{
-	return event->attr.config1;
-}
-
-static bool ddr_perf_filters_compatible(struct perf_event *a,
-					struct perf_event *b)
-{
-	if (!ddr_perf_is_filtered(a))
-		return true;
-	if (!ddr_perf_is_filtered(b))
-		return true;
-	return ddr_perf_filter_val(a) == ddr_perf_filter_val(b);
+	/*
+	 * return bytes instead of bursts from ddr transaction for
+	 * axid-read and axid-write event if PMU core supports enhanced
+	 * filter.
+	 */
+	base += ddr_perf_is_enhanced_filtered(event) ? COUNTER_DPCR1 :
+						       COUNTER_READ;
+	return readl_relaxed(base + counter * 4);
 }
 
 static int ddr_perf_event_init(struct perf_event *event)
-- 
2.20.1

