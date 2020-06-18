Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1761FE541
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgFRCYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgFRBRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE8621D90;
        Thu, 18 Jun 2020 01:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443055;
        bh=St+32PWtOnP3r5Q0VnSaOgp8ULPNXgJlQD252LrToqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+ivjD8VWifDsUTjT5+6fbBgXBefpI5rTRhLbfbSWNa8YeLJOHhHfaGfuYUdbpBnu
         bE8RBcaXlbTAU1QFpJocupIRz2524gOvvk5zi0GEPEQODrdHQ7zTaWb6Lg0OpS8q+T
         g7ltwHb+oGGdoCFcDgRUaIl7E5g76RvgdLwFlMSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 047/266] coresight: tmc: Fix TMC mode read in tmc_read_prepare_etb()
Date:   Wed, 17 Jun 2020 21:12:52 -0400
Message-Id: <20200618011631.604574-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit 347adb0d6385c3220dc01ab61807a5b1892901cc ]

On some QCOM platforms like SC7180, SDM845 and SM8150,
reading TMC mode register without proper coresight power
management can lead to async exceptions like the one in
the call trace below in tmc_read_prepare_etb(). This can
happen if the user tries to read the TMC etf data via
device node without setting up source and the sink first.
Fix this by having a check for coresight sysfs mode
before reading TMC mode management register.

 Kernel panic - not syncing: Asynchronous SError Interrupt
 CPU: 7 PID: 2605 Comm: hexdump Tainted: G S                5.4.30 #122
 Call trace:
  dump_backtrace+0x0/0x188
  show_stack+0x20/0x2c
  dump_stack+0xdc/0x144
  panic+0x168/0x36c
  panic+0x0/0x36c
  arm64_serror_panic+0x78/0x84
  do_serror+0x130/0x138
  el1_error+0x84/0xf8
  tmc_read_prepare_etb+0x88/0xb8
  tmc_open+0x40/0xd8
  misc_open+0x120/0x158
  chrdev_open+0xb8/0x1a4
  do_dentry_open+0x268/0x3a0
  vfs_open+0x34/0x40
  path_openat+0x39c/0xdf4
  do_filp_open+0x90/0x10c
  do_sys_open+0x150/0x3e8
  __arm64_compat_sys_openat+0x28/0x34
  el0_svc_common+0xa8/0x160
  el0_svc_compat_handler+0x2c/0x38
  el0_svc_compat+0x8/0x10

Fixes: 4525412a5046 ("coresight: tmc: making prepare/unprepare functions generic")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Suggested-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200518180242.7916-14-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index d0cc3985b72a..36cce2bfb744 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -596,13 +596,6 @@ int tmc_read_prepare_etb(struct tmc_drvdata *drvdata)
 		goto out;
 	}
 
-	/* There is no point in reading a TMC in HW FIFO mode */
-	mode = readl_relaxed(drvdata->base + TMC_MODE);
-	if (mode != TMC_MODE_CIRCULAR_BUFFER) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Don't interfere if operated from Perf */
 	if (drvdata->mode == CS_MODE_PERF) {
 		ret = -EINVAL;
@@ -616,8 +609,15 @@ int tmc_read_prepare_etb(struct tmc_drvdata *drvdata)
 	}
 
 	/* Disable the TMC if need be */
-	if (drvdata->mode == CS_MODE_SYSFS)
+	if (drvdata->mode == CS_MODE_SYSFS) {
+		/* There is no point in reading a TMC in HW FIFO mode */
+		mode = readl_relaxed(drvdata->base + TMC_MODE);
+		if (mode != TMC_MODE_CIRCULAR_BUFFER) {
+			ret = -EINVAL;
+			goto out;
+		}
 		__tmc_etb_disable_hw(drvdata);
+	}
 
 	drvdata->reading = true;
 out:
-- 
2.25.1

