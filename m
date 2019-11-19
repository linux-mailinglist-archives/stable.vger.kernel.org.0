Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1471016DC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731497AbfKSFwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731006AbfKSFwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:52:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DCE620721;
        Tue, 19 Nov 2019 05:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142761;
        bh=cj5u95BnEoI4lNCshidUefaPX9ljRH1R6f9BmPwhev4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhNpAR/tFnLXSMXYn4Ahhg8jr5cGJSjVOizRfW6uflPHuFvWt4ex0i/dx3co79eZN
         5XD0nwHjt4pkjk2UTjdInE6cjUc+GtKhWI0HkZZmHTyBbCHWsKSp3/J9X1rIPxVETs
         PICLHXwEeXM+t99+h89ex9/SK8wXdu9+2F1GbjMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 191/239] coresight: Fix handling of sinks
Date:   Tue, 19 Nov 2019 06:19:51 +0100
Message-Id: <20191119051335.581613698@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



