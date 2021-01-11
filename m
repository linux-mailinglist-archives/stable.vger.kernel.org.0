Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2542E2F16C6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbhAKN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbhAKN5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 08:57:12 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C51C061786;
        Mon, 11 Jan 2021 05:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t97qfNfslY47//eCciieQX08O/i/e1TvZf3R4Xgo04k=; b=A+df3OecQuS3wsVlaCAr/FvXIB
        SYwYcoPd4E/IC8oWatbtPyMUGStlzWXND6kWATVr/XFuZ1b/idP89dLqSsNM53fac433iuygeryA8
        RAKgLpAb1psZeaPOykC/9LCpRX4b7fpP9VG9O7BQ5l3M3kC3kTSMlMLZ01nDoSEv5rflTywZ1Rs8F
        sxV4YKENFQOqZ/4zE3CPpN6umyuhrrQX+WW7FMrmjv7XHn5O8WklTS8PfR5Nb8H2nt+SWFV/V0EvB
        RVF17EB0o4hslMHOFBXOLnV1bQIh3csdfChNG8A4wsIHuQZa5bmceRXeHXj8oPxC6f0Ie2awvGUPc
        kG+dE4/Q==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=toshino.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mperttunen@nvidia.com>)
        id 1kyxgJ-0001de-6R; Mon, 11 Jan 2021 15:56:27 +0200
From:   Mikko Perttunen <mperttunen@nvidia.com>
To:     ldewangan@nvidia.com, digetx@gmail.com, thierry.reding@gmail.com,
        jonathanh@nvidia.com, wsa@kernel.org
Cc:     linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH] i2c: tegra: Wait for config load atomically while in ISR
Date:   Mon, 11 Jan 2021 15:55:47 +0200
Message-Id: <20210111135547.3613092-1-mperttunen@nvidia.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: mperttunen@nvidia.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upon a communication error, the interrupt handler can call
tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
unless the current transaction was marked atomic. Since
tegra_i2c_disable_packet_mode is only called from the interrupt path,
make it use atomic waiting always.

Fixes: ede2299f7101 ("i2c: tegra: Support atomic transfers")
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
This fixes constant spew for me while HDMI is connected to a
powered off television.

 drivers/i2c/busses/i2c-tegra.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 6f08c0c3238d..4a7ff1840565 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -528,12 +528,12 @@ static void tegra_i2c_vi_init(struct tegra_i2c_dev *i2c_dev)
 
 static int tegra_i2c_poll_register(struct tegra_i2c_dev *i2c_dev,
 				   u32 reg, u32 mask, u32 delay_us,
-				   u32 timeout_us)
+				   u32 timeout_us, bool force_atomic)
 {
 	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
 	u32 val;
 
-	if (!i2c_dev->atomic_mode)
+	if (!i2c_dev->atomic_mode && !force_atomic)
 		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
 						  delay_us, timeout_us);
 
@@ -560,7 +560,7 @@ static int tegra_i2c_flush_fifos(struct tegra_i2c_dev *i2c_dev)
 	val |= mask;
 	i2c_writel(i2c_dev, val, offset);
 
-	err = tegra_i2c_poll_register(i2c_dev, offset, mask, 1000, 1000000);
+	err = tegra_i2c_poll_register(i2c_dev, offset, mask, 1000, 1000000, false);
 	if (err) {
 		dev_err(i2c_dev->dev, "failed to flush FIFO\n");
 		return err;
@@ -569,7 +569,7 @@ static int tegra_i2c_flush_fifos(struct tegra_i2c_dev *i2c_dev)
 	return 0;
 }
 
-static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev)
+static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev, bool force_atomic)
 {
 	int err;
 
@@ -579,7 +579,7 @@ static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev)
 	i2c_writel(i2c_dev, I2C_MSTR_CONFIG_LOAD, I2C_CONFIG_LOAD);
 
 	err = tegra_i2c_poll_register(i2c_dev, I2C_CONFIG_LOAD, 0xffffffff,
-				      1000, I2C_CONFIG_LOAD_TIMEOUT);
+				      1000, I2C_CONFIG_LOAD_TIMEOUT, force_atomic);
 	if (err) {
 		dev_err(i2c_dev->dev, "failed to load config\n");
 		return err;
@@ -684,7 +684,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	if (i2c_dev->multimaster_mode && i2c_dev->hw->has_slcg_override_reg)
 		i2c_writel(i2c_dev, I2C_MST_CORE_CLKEN_OVR, I2C_CLKEN_OVERRIDE);
 
-	err = tegra_i2c_wait_for_config_load(i2c_dev);
+	err = tegra_i2c_wait_for_config_load(i2c_dev, false);
 	if (err)
 		return err;
 
@@ -707,7 +707,7 @@ static int tegra_i2c_disable_packet_mode(struct tegra_i2c_dev *i2c_dev)
 	if (cnfg & I2C_CNFG_PACKET_MODE_EN)
 		i2c_writel(i2c_dev, cnfg & ~I2C_CNFG_PACKET_MODE_EN, I2C_CNFG);
 
-	return tegra_i2c_wait_for_config_load(i2c_dev);
+	return tegra_i2c_wait_for_config_load(i2c_dev, true);
 }
 
 static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
@@ -1090,7 +1090,7 @@ static int tegra_i2c_issue_bus_clear(struct i2c_adapter *adap)
 	      I2C_BC_TERMINATE;
 	i2c_writel(i2c_dev, val, I2C_BUS_CLEAR_CNFG);
 
-	err = tegra_i2c_wait_for_config_load(i2c_dev);
+	err = tegra_i2c_wait_for_config_load(i2c_dev, false);
 	if (err)
 		return err;
 
-- 
2.30.0

