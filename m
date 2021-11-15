Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D192450F4A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbhKOS3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:29:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241745AbhKOSZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE81461A7D;
        Mon, 15 Nov 2021 17:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998907;
        bh=6TnqQ02W4jAYMfLgtsgFgXWmynP0vv5c6wV7xZmAv9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9LyOBIieOUkdR0vtMO/Fvby+ulVetigKI7FrPfORwd+xMjgP/PRed6sohU3WRQ7l
         ipc+HiPqjfM6sTGeLXQ+pWSnzBIYS/DgRiGehHdeNb9cti05YDO8McMj6277+L7LV8
         GZFSVRaxfzdBgwhK4DaE72oI8zRTg+FOdhUzKbug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Anikiel?= <pan@semihalf.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 073/849] reset: socfpga: add empty driver allowing consumers to probe
Date:   Mon, 15 Nov 2021 17:52:36 +0100
Message-Id: <20211115165422.518844070@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paweł Anikiel <pan@semihalf.com>

[ Upstream commit 3ad60b4b3570937f3278509fe6797a5093ce53f8 ]

The early reset driver doesn't ever probe, which causes consuming
devices to be unable to probe. Add an empty driver to set this device
as available, allowing consumers to probe.

Signed-off-by: Paweł Anikiel <pan@semihalf.com>
Link: https://lore.kernel.org/r/20210920124141.1166544-4-pan@semihalf.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-socfpga.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/reset/reset-socfpga.c b/drivers/reset/reset-socfpga.c
index 2a72f861f7983..8c6492e5693c7 100644
--- a/drivers/reset/reset-socfpga.c
+++ b/drivers/reset/reset-socfpga.c
@@ -92,3 +92,29 @@ void __init socfpga_reset_init(void)
 	for_each_matching_node(np, socfpga_early_reset_dt_ids)
 		a10_reset_init(np);
 }
+
+/*
+ * The early driver is problematic, because it doesn't register
+ * itself as a driver. This causes certain device links to prevent
+ * consumer devices from probing. The hacky solution is to register
+ * an empty driver, whose only job is to attach itself to the reset
+ * manager and call probe.
+ */
+static const struct of_device_id socfpga_reset_dt_ids[] = {
+	{ .compatible = "altr,rst-mgr", },
+	{ /* sentinel */ },
+};
+
+static int reset_simple_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver reset_socfpga_driver = {
+	.probe	= reset_simple_probe,
+	.driver = {
+		.name		= "socfpga-reset",
+		.of_match_table	= socfpga_reset_dt_ids,
+	},
+};
+builtin_platform_driver(reset_socfpga_driver);
-- 
2.33.0



