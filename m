Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3756520E675
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgF2Vrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgF2Sfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9FC24199;
        Mon, 29 Jun 2020 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443955;
        bh=o/TYTOT46rvqTePLmOZ9wOwdpWqkKPYJbiOXuA4zRLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE1fMEf19wZKWZ4k9XdIKKVc6+Ur60u4I2T2iE9hOwFQVvoyWT5clwx4x/vnP9aT2
         tVW9nOSSyYz8UQB7b1H/0PR1fC01AbTyJQADZW1unE0cuAoe9tjU7FF/ryYkX7vc20
         SZrq18p1FAtVv68jUngL78POMq+hmjH4OTz/bwY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 057/265] Revert "i2c: tegra: Fix suspending in active runtime PM state"
Date:   Mon, 29 Jun 2020 11:14:50 -0400
Message-Id: <20200629151818.2493727-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 78ad73421831247e46c31899a7bead02740e4bef ]

This reverts commit 9f42de8d4ec2304f10bbc51dc0484f3503d61196.

It's not safe to use pm_runtime_force_{suspend,resume}(), especially
during the noirq phase of suspend. See also the guidance provided in
commit 1e2ef05bb8cf ("PM: Limit race conditions between runtime PM
and system sleep (v2)").

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 4c4d17ddc96b9..7c88611c732c4 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1769,14 +1769,9 @@ static int tegra_i2c_remove(struct platform_device *pdev)
 static int __maybe_unused tegra_i2c_suspend(struct device *dev)
 {
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
-	int err;
 
 	i2c_mark_adapter_suspended(&i2c_dev->adapter);
 
-	err = pm_runtime_force_suspend(dev);
-	if (err < 0)
-		return err;
-
 	return 0;
 }
 
@@ -1797,10 +1792,6 @@ static int __maybe_unused tegra_i2c_resume(struct device *dev)
 	if (err)
 		return err;
 
-	err = pm_runtime_force_resume(dev);
-	if (err < 0)
-		return err;
-
 	i2c_mark_adapter_resumed(&i2c_dev->adapter);
 
 	return 0;
-- 
2.25.1

