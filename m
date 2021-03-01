Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2055329082
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbhCAUJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238583AbhCAUAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:00:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18CA264ED7;
        Mon,  1 Mar 2021 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621417;
        bh=6ePt3rwdDT108Ub4rc+l9h4ayQGocHfdHrRlTEPF/7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiNqKeNit3BD3Ybh9/vfofplsvGGuoWrPCzo+WgBA0C44E5xbNyYcMbhoDUM3oHwU
         oK8oSRwlYtFv74JZwr6PyzpYzZhe3Ar1EM0jzzENtc/r+193Xc+9l1c3NqJ9wXVHJn
         T356TLoo+b/P54PGR+pXmeqT410puJSF8vrp2gw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 509/775] soundwire: bus: use sdw_update_no_pm when initializing a device
Date:   Mon,  1 Mar 2021 17:11:17 +0100
Message-Id: <20210301161226.668282991@linuxfoundation.org>
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

[ Upstream commit b04c975e654cfdea6d691cd403b5a81cce7e593d ]

When a Slave device is resumed, it may resume the bus and restart the
enumeration. During that process, we absolutely don't want to call
regular read/write routines which will wait for the resume to
complete, otherwise a deadlock occurs.

Fixes: 60ee9be25571 ('soundwire: bus: add PM/no-PM versions of read/write functions')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210122070634.12825-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index d1e8c3a54976b..60c42508c6c6b 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -489,6 +489,18 @@ sdw_read_no_pm(struct sdw_slave *slave, u32 addr)
 		return buf;
 }
 
+static int sdw_update_no_pm(struct sdw_slave *slave, u32 addr, u8 mask, u8 val)
+{
+	int tmp;
+
+	tmp = sdw_read_no_pm(slave, addr);
+	if (tmp < 0)
+		return tmp;
+
+	tmp = (tmp & ~mask) | val;
+	return sdw_write_no_pm(slave, addr, tmp);
+}
+
 /**
  * sdw_nread() - Read "n" contiguous SDW Slave registers
  * @slave: SDW Slave
@@ -1256,7 +1268,7 @@ static int sdw_initialize_slave(struct sdw_slave *slave)
 	val = slave->prop.scp_int1_mask;
 
 	/* Enable SCP interrupts */
-	ret = sdw_update(slave, SDW_SCP_INTMASK1, val, val);
+	ret = sdw_update_no_pm(slave, SDW_SCP_INTMASK1, val, val);
 	if (ret < 0) {
 		dev_err(slave->bus->dev,
 			"SDW_SCP_INTMASK1 write failed:%d\n", ret);
@@ -1271,7 +1283,7 @@ static int sdw_initialize_slave(struct sdw_slave *slave)
 	val = prop->dp0_prop->imp_def_interrupts;
 	val |= SDW_DP0_INT_PORT_READY | SDW_DP0_INT_BRA_FAILURE;
 
-	ret = sdw_update(slave, SDW_DP0_INTMASK, val, val);
+	ret = sdw_update_no_pm(slave, SDW_DP0_INTMASK, val, val);
 	if (ret < 0)
 		dev_err(slave->bus->dev,
 			"SDW_DP0_INTMASK read failed:%d\n", ret);
-- 
2.27.0



