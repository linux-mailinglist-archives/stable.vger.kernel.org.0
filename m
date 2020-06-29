Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E6120D831
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgF2ThJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:37:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733014AbgF2Tae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E184E251F5;
        Mon, 29 Jun 2020 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444913;
        bh=4bzO8lKbvDkBF64UwGEL5SVtyrk3gewKVO6JyZYk3hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1BLy8L7ghXlemOq9gOcfwGdaCQWIZtc8F34m0rAoUKBeg/zVr/Pq7mjZ48SbqT+v
         dcF4K7rPGR1qThQUBXQvex6wE3zte/NgK4xxud3sxSZBdRbVYl5SWjUUGgWLaoI/7L
         XjF6ApEywakZ+FpRO4uQbglG/4/EWkLWM6V5QFFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/131] i2c: tegra: Add missing kerneldoc for some fields
Date:   Mon, 29 Jun 2020 11:33:00 -0400
Message-Id: <20200629153502.2494656-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 0604ee4aefa20f493a32dc223599f922fb615367 ]

Not all fields were properly documented. Add kerneldoc for the missing
fields to prevent the build from flagging them.

Reported-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 9a6b9a1b88aef..917f416787b10 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -154,6 +154,16 @@ enum msg_end_type {
  * @clk_divisor_std_fast_mode: Clock divisor in standard/fast mode. It is
  *		applicable if there is no fast clock source i.e. single clock
  *		source.
+ * @clk_divisor_fast_plus_mode: Clock divisor in fast mode plus. It is
+ *		applicable if there is no fast clock source (i.e. single
+ *		clock source).
+ * @has_multi_master_mode: The I2C controller supports running in single-master
+ *		or multi-master mode.
+ * @has_slcg_override_reg: The I2C controller supports a register that
+ *		overrides the second level clock gating.
+ * @has_mst_fifo: The I2C controller contains the new MST FIFO interface that
+ *		provides additional features and allows for longer messages to
+ *		be transferred in one go.
  */
 struct tegra_i2c_hw_feature {
 	bool has_continue_xfer_support;
@@ -175,9 +185,11 @@ struct tegra_i2c_hw_feature {
  * @adapter: core I2C layer adapter information
  * @div_clk: clock reference for div clock of I2C controller
  * @fast_clk: clock reference for fast clock of I2C controller
+ * @rst: reset control for the I2C controller
  * @base: ioremapped registers cookie
  * @cont_id: I2C controller ID, used for packet header
  * @irq: IRQ number of transfer complete interrupt
+ * @irq_disabled: used to track whether or not the interrupt is enabled
  * @is_dvc: identifies the DVC I2C controller, has a different register layout
  * @msg_complete: transfer completion notifier
  * @msg_err: error code for completed message
@@ -185,6 +197,9 @@ struct tegra_i2c_hw_feature {
  * @msg_buf_remaining: size of unsent data in the message buffer
  * @msg_read: identifies read transfers
  * @bus_clk_rate: current I2C bus clock rate
+ * @clk_divisor_non_hs_mode: clock divider for non-high-speed modes
+ * @is_multimaster_mode: track if I2C controller is in multi-master mode
+ * @xfer_lock: lock to serialize transfer submission and processing
  */
 struct tegra_i2c_dev {
 	struct device *dev;
-- 
2.25.1

