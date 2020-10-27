Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1229B73E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799302AbgJ0Pas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799293AbgJ0Paq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9C9022202;
        Tue, 27 Oct 2020 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812645;
        bh=iKnE/Hc7xCVVFbYGgGIXEAKToBtNNhSRDCXKg6XNkX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pN8BiJ0aNrYXJX9U8kXW8hMG7jg2732ZSX8JHCL6uD3ud4eclf3eudfU4W8WoXuS3
         /B/NK+jrp+8B5LzIt7Ay121NQ+gKZqsCfruCifuEF34BMcz8FUw/OltcNY3e/nPGQB
         o9aYSEvWusyP8uCQDp0vHGl/mG0+e3neibRzTWUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Tingwei Zhang <tingwei@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 274/757] coresight: cti: remove pm_runtime_get_sync() from CPU hotplug
Date:   Tue, 27 Oct 2020 14:48:44 +0100
Message-Id: <20201027135503.426384519@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tingwei Zhang <tingwei@codeaurora.org>

[ Upstream commit 6e8836c6df5327bdb24211424f1ad1411d1ed64a ]

Below BUG is triggered by call pm_runtime_get_sync() in
cti_cpuhp_enable_hw(). It's in CPU hotplug callback with interrupt
disabled. Pm_runtime_get_sync() calls clock driver to enable clock
which could sleep. Remove pm_runtime_get_sync() in cti_cpuhp_enable_hw()
since pm_runtime_get_sync() is called in cti_enabld and pm_runtime_put()
is called in cti_disabled. No need to increase pm count when CPU gets
online since it's not decreased when CPU is offline.

[  105.800279] BUG: scheduling while atomic: swapper/1/0/0x00000002
[  105.800290] Modules linked in:
[  105.800327] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W
5.9.0-rc1-gff1304be0a05-dirty #21
[  105.800337] Hardware name: Thundercomm Dragonboard 845c (DT)
[  105.800353] Call trace:
[  105.800414]  dump_backtrace+0x0/0x1d4
[  105.800439]  show_stack+0x14/0x1c
[  105.800462]  dump_stack+0xc0/0x100
[  105.800490]  __schedule_bug+0x58/0x74
[  105.800523]  __schedule+0x590/0x65c
[  105.800538]  schedule+0x78/0x10c
[  105.800553]  schedule_timeout+0x188/0x250
[  105.800585]  qmp_send.constprop.10+0x12c/0x1b0
[  105.800599]  qmp_qdss_clk_prepare+0x18/0x20
[  105.800622]  clk_core_prepare+0x48/0xd4
[  105.800639]  clk_prepare+0x20/0x34
[  105.800663]  amba_pm_runtime_resume+0x54/0x90
[  105.800695]  __rpm_callback+0xdc/0x138
[  105.800709]  rpm_callback+0x24/0x78
[  105.800724]  rpm_resume+0x328/0x47c
[  105.800739]  __pm_runtime_resume+0x50/0x74
[  105.800768]  cti_starting_cpu+0x40/0xa4
[  105.800795]  cpuhp_invoke_callback+0x84/0x1e0
[  105.800814]  notify_cpu_starting+0x9c/0xb8
[  105.800834]  secondary_start_kernel+0xd8/0x164
[  105.800933] CPU1: Booted secondary processor 0x0000000100 [0x517f803c]

Fixes: e9b880581d55 ("coresight: cti: Add CPU Hotplug handling to CTI driver")
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Tingwei Zhang <tingwei@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-7-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti.c b/drivers/hwtracing/coresight/coresight-cti.c
index d6fea6efec71f..c4e9cc7034ab7 100644
--- a/drivers/hwtracing/coresight/coresight-cti.c
+++ b/drivers/hwtracing/coresight/coresight-cti.c
@@ -141,9 +141,7 @@ static int cti_enable_hw(struct cti_drvdata *drvdata)
 static void cti_cpuhp_enable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
-	struct device *dev = &drvdata->csdev->dev;
 
-	pm_runtime_get_sync(dev->parent);
 	spin_lock(&drvdata->spinlock);
 	config->hw_powered = true;
 
@@ -163,7 +161,6 @@ static void cti_cpuhp_enable_hw(struct cti_drvdata *drvdata)
 	/* did not re-enable due to no claim / no request */
 cti_hp_not_enabled:
 	spin_unlock(&drvdata->spinlock);
-	pm_runtime_put(dev->parent);
 }
 
 /* disable hardware */
-- 
2.25.1



