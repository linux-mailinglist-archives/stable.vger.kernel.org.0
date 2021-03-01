Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F261328C8D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240728AbhCASx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240228AbhCASrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:47:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8197565058;
        Mon,  1 Mar 2021 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619405;
        bh=2JnITETQ5cKqL2KjsDqQgZjzoWEC4KVw2uc/h+1yLKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfpQvNSO4SSgk36a+FQ8jlmUPQw1Vx+2Uh9acLMMo8mYTtFyGzJ3qOtL5SvDaUTh6
         EO/2woordOSM9WqOnxB1lanTdJNvqF2YfIaJ/X1nQbwPmw6M34ZMnVocndrRY8DMRY
         qHKpkTVIyhrwkFXmhysspWw1GiECLWAtv53boB8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/663] soundwire: bus: fix confusion on device used by pm_runtime
Date:   Mon,  1 Mar 2021 17:11:13 +0100
Message-Id: <20210301161202.909558412@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 3c05ef105c073..1fe786855095a 100644
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
@@ -1446,7 +1446,7 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 	ret = pm_runtime_get_sync(&slave->dev);
 	if (ret < 0 && ret != -EACCES) {
 		dev_err(&slave->dev, "Failed to resume device: %d\n", ret);
-		pm_runtime_put_noidle(slave->bus->dev);
+		pm_runtime_put_noidle(&slave->dev);
 		return ret;
 	}
 
-- 
2.27.0



