Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E91E29C0ED
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817976AbgJ0RQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783551AbgJ0O60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05AD620714;
        Tue, 27 Oct 2020 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810705;
        bh=2UMKEJpcRMbJDqOdjSe02zcZS1wM0vySrxh045L1LNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txdm8KbX1XBbaLsV+TgKCDoOVcOt0L6RVU8pHe6NkbvYBgumNZUMc8lrprUnaYVk6
         Jj+e6cMCklSV53dTbDqey/hyByE3PuKZV6Nhl9J76Nj5gRrf/BsZKt3mmxRymzYS2g
         J9P/TTflrhNBF5rCEl00E0t08Klxb+ojsPNs4DPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tingwei Zhang <tingwei@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 234/633] coresight: cti: Write regsiters directly in cti_enable_hw()
Date:   Tue, 27 Oct 2020 14:49:37 +0100
Message-Id: <20201027135533.661777607@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tingwei Zhang <tingwei@codeaurora.org>

[ Upstream commit 984f37efa3857dcefa649fbdf64abb94591935c3 ]

Deadlock as below is triggered by one CPU holds drvdata->spinlock
and calls cti_enable_hw(). Smp_call_function_single() is called
in cti_enable_hw() and tries to let another CPU write CTI registers.
That CPU is trying to get drvdata->spinlock in cti_cpu_pm_notify()
and doesn't response to IPI from smp_call_function_single().

[  988.335937] CPU: 6 PID: 10258 Comm: sh Tainted: G        W    L
5.8.0-rc6-mainline-16783-gc38daa79b26b-dirty #1
[  988.346364] Hardware name: Thundercomm Dragonboard 845c (DT)
[  988.352073] pstate: 20400005 (nzCv daif +PAN -UAO BTYPE=--)
[  988.357689] pc : smp_call_function_single+0x158/0x1b8
[  988.362782] lr : smp_call_function_single+0x124/0x1b8
...
[  988.451638] Call trace:
[  988.454119]  smp_call_function_single+0x158/0x1b8
[  988.458866]  cti_enable+0xb4/0xf8 [coresight_cti]
[  988.463618]  coresight_control_assoc_ectdev+0x6c/0x128 [coresight]
[  988.469855]  coresight_enable+0x1f0/0x364 [coresight]
[  988.474957]  enable_source_store+0x5c/0x9c [coresight]
[  988.480140]  dev_attr_store+0x14/0x28
[  988.483839]  sysfs_kf_write+0x38/0x4c
[  988.487532]  kernfs_fop_write+0x1c0/0x2b0
[  988.491585]  vfs_write+0xfc/0x300
[  988.494931]  ksys_write+0x78/0xe0
[  988.498283]  __arm64_sys_write+0x18/0x20
[  988.502240]  el0_svc_common+0x98/0x160
[  988.506024]  do_el0_svc+0x78/0x80
[  988.509377]  el0_sync_handler+0xd4/0x270
[  988.513337]  el0_sync+0x164/0x180

This change write CTI registers directly in cti_enable_hw().
Config->hw_powered has been checked to be true with spinlock holded.
CTI is powered and can be programmed until spinlock is released.

Fixes: 6a0953ce7de9 ("coresight: cti: Add CPU idle pm notifer to CTI devices")
Signed-off-by: Tingwei Zhang <tingwei@codeaurora.org>
[Re-ordered variable declaration]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-10-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti.c | 24 +++++----------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti.c b/drivers/hwtracing/coresight/coresight-cti.c
index c4e9cc7034ab7..47f3c9abae303 100644
--- a/drivers/hwtracing/coresight/coresight-cti.c
+++ b/drivers/hwtracing/coresight/coresight-cti.c
@@ -86,22 +86,16 @@ void cti_write_all_hw_regs(struct cti_drvdata *drvdata)
 	CS_LOCK(drvdata->base);
 }
 
-static void cti_enable_hw_smp_call(void *info)
-{
-	struct cti_drvdata *drvdata = info;
-
-	cti_write_all_hw_regs(drvdata);
-}
-
 /* write regs to hardware and enable */
 static int cti_enable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
 	struct device *dev = &drvdata->csdev->dev;
+	unsigned long flags;
 	int rc = 0;
 
 	pm_runtime_get_sync(dev->parent);
-	spin_lock(&drvdata->spinlock);
+	spin_lock_irqsave(&drvdata->spinlock, flags);
 
 	/* no need to do anything if enabled or unpowered*/
 	if (config->hw_enabled || !config->hw_powered)
@@ -112,19 +106,11 @@ static int cti_enable_hw(struct cti_drvdata *drvdata)
 	if (rc)
 		goto cti_err_not_enabled;
 
-	if (drvdata->ctidev.cpu >= 0) {
-		rc = smp_call_function_single(drvdata->ctidev.cpu,
-					      cti_enable_hw_smp_call,
-					      drvdata, 1);
-		if (rc)
-			goto cti_err_not_enabled;
-	} else {
-		cti_write_all_hw_regs(drvdata);
-	}
+	cti_write_all_hw_regs(drvdata);
 
 	config->hw_enabled = true;
 	atomic_inc(&drvdata->config.enable_req_count);
-	spin_unlock(&drvdata->spinlock);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 	return rc;
 
 cti_state_unchanged:
@@ -132,7 +118,7 @@ static int cti_enable_hw(struct cti_drvdata *drvdata)
 
 	/* cannot enable due to error */
 cti_err_not_enabled:
-	spin_unlock(&drvdata->spinlock);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 	pm_runtime_put(dev->parent);
 	return rc;
 }
-- 
2.25.1



