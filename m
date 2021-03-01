Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1444932908F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhCAUJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241999AbhCAUBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2520464EF3;
        Mon,  1 Mar 2021 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621425;
        bh=jvH/GyLLAh/9nUq3hDbwH5Om2TFn8RD6HrLju74h5F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktzLpFbwWLBbdg7XhhG8tS59F01cw23bYZcDrq6iVLqmE8DweMZ971uvhZaMr6Eyb
         YGksvTYviIgBckY0k5pSj1FrmTQGfwyGB3/q76tnogcC0KVDoPWikVv5iPyudIM7ok
         IPkItHAEwQY+4u9vrXDwuSylr9eGYzbRZUPYx67I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 512/775] soundwire: bus: fix confusion on device used by pm_runtime
Date:   Mon,  1 Mar 2021 17:11:20 +0100
Message-Id: <20210301161226.822435457@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 973794e85610d9a716a897baa9007ff56e192826 ]

Intel stress-tests routinely report IO timeouts and invalid power
management transitions. Upon further analysis, we seem to be using the
wrong devices in pm_runtime calls.

Before reading and writing registers, we first need to make sure the
Slave is fully resumed. The existing code attempts to do such that,
however because of a confusion dating from 2017 and copy/paste, we
end-up resuming the parent only instead of resuming the codec device.

This can lead to accesses to the Slave registers while the bus is
still being configured and the Slave not enumerated, and as a result
IO errors occur.

This is a classic problem, similar confusions happened for HDaudio
between bus and codec device, leading to power management issues.

Fix by using the relevant device for all uses of pm_runtime functions.

Fixes: 60ee9be255712 ('soundwire: bus: add PM/no-PM versions of read/write functions')
Fixes: aa79293517b39 ('soundwire: bus: fix io error when processing alert event')
Fixes: 9d715fa005ebc ('soundwire: Add IO transfer')
Reported-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210122070634.12825-9-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 483d5a389c92a..662b3b0302467 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -513,16 +513,16 @@ int sdw_nread(struct sdw_slave *slave, u32 addr, size_t count, u8 *val)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(slave->bus->dev);
+	ret = pm_runtime_get_sync(&slave->dev);
 	if (ret < 0 && ret != -EACCES) {
-		pm_runtime_put_noidle(slave->bus->dev);
+		pm_runtime_put_noidle(&slave->dev);
 		return ret;
 	}
 
 	ret = sdw_nread_no_pm(slave, addr, count, val);
 
-	pm_runtime_mark_last_busy(slave->bus->dev);
-	pm_runtime_put(slave->bus->dev);
+	pm_runtime_mark_last_busy(&slave->dev);
+	pm_runtime_put(&slave->dev);
 
 	return ret;
 }
@@ -539,16 +539,16 @@ int sdw_nwrite(struct sdw_slave *slave, u32 addr, size_t count, u8 *val)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(slave->bus->dev);
+	ret = pm_runtime_get_sync(&slave->dev);
 	if (ret < 0 && ret != -EACCES) {
-		pm_runtime_put_noidle(slave->bus->dev);
+		pm_runtime_put_noidle(&slave->dev);
 		return ret;
 	}
 
 	ret = sdw_nwrite_no_pm(slave, addr, count, val);
 
-	pm_runtime_mark_last_busy(slave->bus->dev);
-	pm_runtime_put(slave->bus->dev);
+	pm_runtime_mark_last_busy(&slave->dev);
+	pm_runtime_put(&slave->dev);
 
 	return ret;
 }
@@ -1453,7 +1453,7 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 	ret = pm_runtime_get_sync(&slave->dev);
 	if (ret < 0 && ret != -EACCES) {
 		dev_err(&slave->dev, "Failed to resume device: %d\n", ret);
-		pm_runtime_put_noidle(slave->bus->dev);
+		pm_runtime_put_noidle(&slave->dev);
 		return ret;
 	}
 
-- 
2.27.0



