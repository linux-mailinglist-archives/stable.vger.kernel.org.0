Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80E1283AA5
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgJEPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgJEPdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BF2A207BC;
        Mon,  5 Oct 2020 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911991;
        bh=dvIL3u54ca5MTHLtjXk3r3JOtkBC1MToCW4yEaWMa/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOvWdsatIeqERJdo/v3ZzbliqbUb48OP+B6mdeE1uo6irefgAp3MB6vBDN6nRx+RF
         QotJMWCArEX0j7YAdnrX//RMVi8R0+VaoL+2X59GCxczmiOgmiZz6577g/XCmDhd3t
         3uI4W9Caq5he+zgPfH5WfQAtjs1Eavv2RkJVfC54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 58/85] dmaengine: dmatest: Prevent to run on misconfigured channel
Date:   Mon,  5 Oct 2020 17:26:54 +0200
Message-Id: <20201005142117.514377567@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit ce65d55f92a67e247f4d799e581cf9fed677871c ]

Andy reported that commit 6b41030fdc79 ("dmaengine: dmatest:
Restore default for channel") broke his scripts for the case
where "busy" channel is used for configuration with expectation
that run command would do nothing. Instead, behavior was
(unintentionally) changed to treat such case as under-configuration
and progress with defaults, i.e. run command would start a test
with default setting for channel (which would use all channels).

Restore original behavior with tracking status of channel setter
so we can distinguish between misconfigured and under-configured
cases in run command and act accordingly.

Fixes: 6b41030fdc79 ("dmaengine: dmatest: Restore default for channel")
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200922115847.30100-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmatest.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 604f803579312..323822372b4ce 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -129,6 +129,7 @@ struct dmatest_params {
  * @nr_channels:	number of channels under test
  * @lock:		access protection to the fields of this structure
  * @did_init:		module has been initialized completely
+ * @last_error:		test has faced configuration issues
  */
 static struct dmatest_info {
 	/* Test parameters */
@@ -137,6 +138,7 @@ static struct dmatest_info {
 	/* Internal state */
 	struct list_head	channels;
 	unsigned int		nr_channels;
+	int			last_error;
 	struct mutex		lock;
 	bool			did_init;
 } test_info = {
@@ -1175,10 +1177,22 @@ static int dmatest_run_set(const char *val, const struct kernel_param *kp)
 		return ret;
 	} else if (dmatest_run) {
 		if (!is_threaded_test_pending(info)) {
-			pr_info("No channels configured, continue with any\n");
-			if (!is_threaded_test_run(info))
-				stop_threaded_test(info);
-			add_threaded_test(info);
+			/*
+			 * We have nothing to run. This can be due to:
+			 */
+			ret = info->last_error;
+			if (ret) {
+				/* 1) Misconfiguration */
+				pr_err("Channel misconfigured, can't continue\n");
+				mutex_unlock(&info->lock);
+				return ret;
+			} else {
+				/* 2) We rely on defaults */
+				pr_info("No channels configured, continue with any\n");
+				if (!is_threaded_test_run(info))
+					stop_threaded_test(info);
+				add_threaded_test(info);
+			}
 		}
 		start_threaded_tests(info);
 	} else {
@@ -1195,7 +1209,7 @@ static int dmatest_chan_set(const char *val, const struct kernel_param *kp)
 	struct dmatest_info *info = &test_info;
 	struct dmatest_chan *dtc;
 	char chan_reset_val[20];
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&info->lock);
 	ret = param_set_copystring(val, kp);
@@ -1250,12 +1264,14 @@ static int dmatest_chan_set(const char *val, const struct kernel_param *kp)
 		goto add_chan_err;
 	}
 
+	info->last_error = ret;
 	mutex_unlock(&info->lock);
 
 	return ret;
 
 add_chan_err:
 	param_set_copystring(chan_reset_val, kp);
+	info->last_error = ret;
 	mutex_unlock(&info->lock);
 
 	return ret;
-- 
2.25.1



