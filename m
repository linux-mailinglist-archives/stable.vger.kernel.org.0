Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4529B8D5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802035AbgJ0PpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799590AbgJ0PcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7F2A20728;
        Tue, 27 Oct 2020 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812738;
        bh=OhaDBBnxbYMzQQopBBEYIM19xtqxR6PHTP9eV9r0BKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DblPfb/9nb16tmvWSZISoP+eOthjdOt9gUG7CkytTxp4NGRfi73/gLB1EJ2veQxGW
         Ct2cIhMxVxYP5CAbcJ6Ze9CaahV/sP7rhcfvYp7FSWbohhgKar3H16DcWmcfQqNoOp
         zCYOdL4E8vViyztHsG93M8R+xc/W3dyXBhbSxZZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Tingwei Zhang <tingwei@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 273/757] coresight: cti: disclaim device only when its claimed
Date:   Tue, 27 Oct 2020 14:48:43 +0100
Message-Id: <20201027135503.378639598@linuxfoundation.org>
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

[ Upstream commit 0dee28268ddbe53a981d4d87faf5dc0f1700e698 ]

Coresight_claim_device() is called in cti_starting_cpu() only
when CTI is enabled while coresight_disclaim_device() is called
uncontionally in cti_dying_cpu(). This triggered below WARNING.
Only call disclaim device when CTI device is enabled to fix it.

[   75.989643] WARNING: CPU: 1 PID: 14 at
kernel/drivers/hwtracing/coresight/coresight.c:209
coresight_disclaim_device_unlocked+0x10/0x24
[   75.989697] CPU: 1 PID: 14 Comm: migration/1 Not tainted
5.9.0-rc1-gff1304be0a05-dirty #21
[   75.989709] Hardware name: Thundercomm Dragonboard 845c (DT)
[   75.989737] pstate: 80c00085 (Nzcv daIf +PAN +UAO BTYPE=--)
[   75.989758] pc : coresight_disclaim_device_unlocked+0x10/0x24
[   75.989775] lr : coresight_disclaim_device+0x24/0x38
[   75.989783] sp : ffff800011cd3c90
.
[   75.990018] Call trace:
[   75.990041]  coresight_disclaim_device_unlocked+0x10/0x24
[   75.990066]  cti_dying_cpu+0x34/0x4c
[   75.990101]  cpuhp_invoke_callback+0x84/0x1e0
[   75.990121]  take_cpu_down+0x90/0xe0
[   75.990154]  multi_cpu_stop+0x134/0x160
[   75.990171]  cpu_stopper_thread+0xb0/0x13c
[   75.990196]  smpboot_thread_fn+0x1c4/0x270
[   75.990222]  kthread+0x128/0x154
[   75.990251]  ret_from_fork+0x10/0x18

Fixes: e9b880581d55 ("coresight: cti: Add CPU Hotplug handling to CTI driver")
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Tingwei Zhang <tingwei@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-6-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti.c b/drivers/hwtracing/coresight/coresight-cti.c
index 3ccc703dc9409..d6fea6efec71f 100644
--- a/drivers/hwtracing/coresight/coresight-cti.c
+++ b/drivers/hwtracing/coresight/coresight-cti.c
@@ -742,7 +742,8 @@ static int cti_dying_cpu(unsigned int cpu)
 
 	spin_lock(&drvdata->spinlock);
 	drvdata->config.hw_powered = false;
-	coresight_disclaim_device(drvdata->base);
+	if (drvdata->config.hw_enabled)
+		coresight_disclaim_device(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
 	return 0;
 }
-- 
2.25.1



