Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAE6450AB1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhKORNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236565AbhKORMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D345A6322A;
        Mon, 15 Nov 2021 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996175;
        bh=RwPELUlSRrH8ihBiH8+BhS7PfY7lGPMdxADq8nR8pK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtTxebzqiSVwEzELAHxFYT6DK3zPXxCwXSaoUAVY9odAE0kg6Sev7iJDfM56OtzDi
         PF6X9tZUJRhfnLoJwYH8StHtcD85eL7YO2+rxjAXFKtqxPb6sWHRew3QEzVB+W4Wis
         4IPvb6Op0ZKpqXJCWJVegBgiIvRAqET5O2pzfFMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Anikiel?= <pan@semihalf.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/355] reset: socfpga: add empty driver allowing consumers to probe
Date:   Mon, 15 Nov 2021 17:59:28 +0100
Message-Id: <20211115165314.975035619@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 96953992c2bb5..1c5236a69dc49 100644
--- a/drivers/reset/reset-socfpga.c
+++ b/drivers/reset/reset-socfpga.c
@@ -86,3 +86,29 @@ void __init socfpga_reset_init(void)
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



