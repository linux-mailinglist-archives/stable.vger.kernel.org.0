Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E084F6445
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbfKJC6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbfKJC4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3E1222D4;
        Sun, 10 Nov 2019 02:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354052;
        bh=cj5u95BnEoI4lNCshidUefaPX9ljRH1R6f9BmPwhev4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7u/IrwF9F3aOaMjqSwwpH99Q+BCxgdx+e3FOtBQwLeSml6GpureNTbTQVySmmzs7
         eT3lQbRQtfV1lZExwR3bp1tNH9RhklZT8BjJP19osm9koOS7n6Z2ZTSIEw1Dx1/TRi
         Gzmyi/ygtK4u547GIk2z9tGJkRl+ri3uXv2ANeIg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 062/109] coresight: Fix handling of sinks
Date:   Sat,  9 Nov 2019 21:44:54 -0500
Message-Id: <20191110024541.31567-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit c71369de02b285d9da526a526d8f2affc7b17c59 ]

The coresight components could be operated either in sysfs mode or in perf
mode. For some of the components, the mode of operation doesn't matter as
they simply relay the data to the next component in the trace path. But for
sinks, they need to be able to provide the trace data back to the user.
Thus we need to make sure that "mode" is handled appropriately. e.g,
the sysfs mode could have multiple sources driving the trace data, while
perf mode doesn't allow sharing the sink.

The coresight_enable_sink() however doesn't really allow this check to
trigger as it skips the "enable_sink" callback if the component is
already enabled, irrespective of the mode. This could cause mixing
of data from different modes or even same mode (in perf), if the
sources are different. Also, if we fail to enable the sink while
enabling a path (where sink is the first component enabled),
we could end up in disabling the components in the "entire"
path which were not enabled in this trial, causing disruptions
in the existing trace paths.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
index e571e4010dff0..366c1d493af35 100644
--- a/drivers/hwtracing/coresight/coresight.c
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -140,12 +140,14 @@ static int coresight_enable_sink(struct coresight_device *csdev, u32 mode)
 {
 	int ret;
 
-	if (!csdev->enable) {
-		if (sink_ops(csdev)->enable) {
-			ret = sink_ops(csdev)->enable(csdev, mode);
-			if (ret)
-				return ret;
-		}
+	/*
+	 * We need to make sure the "new" session is compatible with the
+	 * existing "mode" of operation.
+	 */
+	if (sink_ops(csdev)->enable) {
+		ret = sink_ops(csdev)->enable(csdev, mode);
+		if (ret)
+			return ret;
 		csdev->enable = true;
 	}
 
@@ -347,8 +349,14 @@ int coresight_enable_path(struct list_head *path, u32 mode)
 		switch (type) {
 		case CORESIGHT_DEV_TYPE_SINK:
 			ret = coresight_enable_sink(csdev, mode);
+			/*
+			 * Sink is the first component turned on. If we
+			 * failed to enable the sink, there are no components
+			 * that need disabling. Disabling the path here
+			 * would mean we could disrupt an existing session.
+			 */
 			if (ret)
-				goto err;
+				goto out;
 			break;
 		case CORESIGHT_DEV_TYPE_SOURCE:
 			/* sources are enabled from either sysFS or Perf */
-- 
2.20.1

