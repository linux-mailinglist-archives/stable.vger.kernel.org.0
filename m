Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9981329092
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbhCAUKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:10:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241901AbhCAUBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9717964EE3;
        Mon,  1 Mar 2021 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621420;
        bh=ATvjjP7ehIqaz/9qOCIgDwbNfUHgIxPdDD3zFDXWJns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cz7IVHXxjAGqng0iLOccZMRzRqZetvxp2nUCndH1vU8kCayhIYavQx2Z9VgNnQlJq
         vhF6pE0ApY5ZVRqlCfeOZWQlbflErJ2i/kpl2zbAEu7NQZI+UR3QIUOAMCFlEhnPcr
         j1BUduWoYfilB7W38I7pOiIov2inBSWcTUSbZusU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 510/775] soundwire: bus: use sdw_write_no_pm when setting the bus scale registers
Date:   Mon,  1 Mar 2021 17:11:18 +0100
Message-Id: <20210301161226.717101032@linuxfoundation.org>
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

[ Upstream commit 299e9780b9196bcb15b26dfdccd3244eb072d560 ]

When a Slave device is resumed, it may resume the bus and restart the
enumeration. During that process, we absolutely don't want to call
regular read/write routines which will wait for the resume to
complete, otherwise a deadlock occurs.

This patch fixes the same problem as the previous one, but is split to
make the life of linux-stable maintainers less painful.

Fixes: 29d158f90690 ('soundwire: bus: initialize bus clock base and scale registers')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210122070634.12825-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 60c42508c6c6b..b1830032b0522 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1222,7 +1222,7 @@ static int sdw_slave_set_frequency(struct sdw_slave *slave)
 	}
 	scale_index++;
 
-	ret = sdw_write(slave, SDW_SCP_BUS_CLOCK_BASE, base);
+	ret = sdw_write_no_pm(slave, SDW_SCP_BUS_CLOCK_BASE, base);
 	if (ret < 0) {
 		dev_err(&slave->dev,
 			"SDW_SCP_BUS_CLOCK_BASE write failed:%d\n", ret);
@@ -1230,13 +1230,13 @@ static int sdw_slave_set_frequency(struct sdw_slave *slave)
 	}
 
 	/* initialize scale for both banks */
-	ret = sdw_write(slave, SDW_SCP_BUSCLOCK_SCALE_B0, scale_index);
+	ret = sdw_write_no_pm(slave, SDW_SCP_BUSCLOCK_SCALE_B0, scale_index);
 	if (ret < 0) {
 		dev_err(&slave->dev,
 			"SDW_SCP_BUSCLOCK_SCALE_B0 write failed:%d\n", ret);
 		return ret;
 	}
-	ret = sdw_write(slave, SDW_SCP_BUSCLOCK_SCALE_B1, scale_index);
+	ret = sdw_write_no_pm(slave, SDW_SCP_BUSCLOCK_SCALE_B1, scale_index);
 	if (ret < 0)
 		dev_err(&slave->dev,
 			"SDW_SCP_BUSCLOCK_SCALE_B1 write failed:%d\n", ret);
-- 
2.27.0



