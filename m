Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90903329098
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbhCAUKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241994AbhCAUBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447E864EDC;
        Mon,  1 Mar 2021 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621422;
        bh=P8ARNSl8uBriEZCk08Naka8Qah+H9vyTmvFVnSF6UcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAGXqb4Q6w4aUcyJMAu5fkIB5QZRG9DiwOUc80ZdTdpc/sVCmyWdkWEZl11Rh9rfR
         WfmaTNGQjvBh0WDFi+Dt4N0dKLUgoyUFJhfdGlQck/9SNJESDOeTpiUnKDuf2ZG4Q1
         Alt2pX+oYDGT4o3CG8LMu2XyY/kSd+iTjcOvtsJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 511/775] soundwire: export sdw_write/read_no_pm functions
Date:   Mon,  1 Mar 2021 17:11:19 +0100
Message-Id: <20210301161226.770711420@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 167790abb90fa073d8341ee0e408ccad3d2109cd ]

sdw_write_no_pm and sdw_read_no_pm are useful when we want to do IO
without touching PM.

Fixes: 0231453bc08f ('soundwire: bus: add clock stop helpers')
Fixes: 60ee9be25571 ('soundwire: bus: add PM/no-PM versions of read/write functions')
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210122070634.12825-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c       | 7 ++++---
 include/linux/soundwire/sdw.h | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index b1830032b0522..483d5a389c92a 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -405,10 +405,11 @@ sdw_nwrite_no_pm(struct sdw_slave *slave, u32 addr, size_t count, u8 *val)
 	return sdw_transfer(slave->bus, &msg);
 }
 
-static int sdw_write_no_pm(struct sdw_slave *slave, u32 addr, u8 value)
+int sdw_write_no_pm(struct sdw_slave *slave, u32 addr, u8 value)
 {
 	return sdw_nwrite_no_pm(slave, addr, 1, &value);
 }
+EXPORT_SYMBOL(sdw_write_no_pm);
 
 static int
 sdw_bread_no_pm(struct sdw_bus *bus, u16 dev_num, u32 addr)
@@ -476,8 +477,7 @@ int sdw_bwrite_no_pm_unlocked(struct sdw_bus *bus, u16 dev_num, u32 addr, u8 val
 }
 EXPORT_SYMBOL(sdw_bwrite_no_pm_unlocked);
 
-static int
-sdw_read_no_pm(struct sdw_slave *slave, u32 addr)
+int sdw_read_no_pm(struct sdw_slave *slave, u32 addr)
 {
 	u8 buf;
 	int ret;
@@ -488,6 +488,7 @@ sdw_read_no_pm(struct sdw_slave *slave, u32 addr)
 	else
 		return buf;
 }
+EXPORT_SYMBOL(sdw_read_no_pm);
 
 static int sdw_update_no_pm(struct sdw_slave *slave, u32 addr, u8 mask, u8 val)
 {
diff --git a/include/linux/soundwire/sdw.h b/include/linux/soundwire/sdw.h
index f0b01b728640d..d08039d65825e 100644
--- a/include/linux/soundwire/sdw.h
+++ b/include/linux/soundwire/sdw.h
@@ -1005,6 +1005,8 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus);
 
 int sdw_read(struct sdw_slave *slave, u32 addr);
 int sdw_write(struct sdw_slave *slave, u32 addr, u8 value);
+int sdw_write_no_pm(struct sdw_slave *slave, u32 addr, u8 value);
+int sdw_read_no_pm(struct sdw_slave *slave, u32 addr);
 int sdw_nread(struct sdw_slave *slave, u32 addr, size_t count, u8 *val);
 int sdw_nwrite(struct sdw_slave *slave, u32 addr, size_t count, u8 *val);
 
-- 
2.27.0



