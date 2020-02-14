Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D8E15F1B3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbgBNPzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:55:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731260AbgBNPzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7318A24673;
        Fri, 14 Feb 2020 15:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695699;
        bh=M0PJ8JZoSZ8dwHqx5cyIQLl2ynmitGbooB65Z3iUNV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKCcBlEElL2cVELYCPc/3RwWvP/queUuMXdWeYcQ5lvPodC9SYCQ7J/ABmJiRFk+N
         Li6yCupHc4OgGuhtDGS8a0Y3z34w+A91e2Uq3Agm5j2eZIpQHqOxKQiZFqJmma9zmI
         y1mP2QIw6RFLkUPxnFszlRg9laqJXMk2UNfoMwCw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Niklas Cassel <nks@flawful.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 281/542] clk: Use parent node pointer during registration if necessary
Date:   Fri, 14 Feb 2020 10:44:33 -0500
Message-Id: <20200214154854.6746-281-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 9011f92622e5ef2d075f45e5fa818776d4feb8c0 ]

Sometimes clk drivers are attached to devices which are children of a
parent device that is connected to a node in DT. This happens when
devices are MFD-ish and the parent device driver mostly registers child
devices to match against drivers placed in their respective subsystem
directories like drivers/clk, drivers/regulator, etc. When the clk
driver calls clk_register() with a device pointer, that struct device
pointer won't have a device_node associated with it because it was
created purely in software as a way to partition logic to a subsystem.

This causes problems for the way we find parent clks for the clks
registered by these child devices because we look at the registering
device's device_node pointer to lookup 'clocks' and 'clock-names'
properties. Let's use the parent device's device_node pointer if the
registering device doesn't have a device_node but the parent does. This
simplifies clk registration code by avoiding the need to assign some
device_node to the device registering the clk.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20191230190455.141339-1-sboyd@kernel.org
[sboyd@kernel.org: Fixup kernel-doc notation]
Reviewed-by: Niklas Cassel <nks@flawful.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 53585cfc4b9ba..66f056ac4c156 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3736,6 +3736,28 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 	return ERR_PTR(ret);
 }
 
+/**
+ * dev_or_parent_of_node() - Get device node of @dev or @dev's parent
+ * @dev: Device to get device node of
+ *
+ * Return: device node pointer of @dev, or the device node pointer of
+ * @dev->parent if dev doesn't have a device node, or NULL if neither
+ * @dev or @dev->parent have a device node.
+ */
+static struct device_node *dev_or_parent_of_node(struct device *dev)
+{
+	struct device_node *np;
+
+	if (!dev)
+		return NULL;
+
+	np = dev_of_node(dev);
+	if (!np)
+		np = dev_of_node(dev->parent);
+
+	return np;
+}
+
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
@@ -3751,7 +3773,7 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
  */
 struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 {
-	return __clk_register(dev, dev_of_node(dev), hw);
+	return __clk_register(dev, dev_or_parent_of_node(dev), hw);
 }
 EXPORT_SYMBOL_GPL(clk_register);
 
@@ -3767,7 +3789,8 @@ EXPORT_SYMBOL_GPL(clk_register);
  */
 int clk_hw_register(struct device *dev, struct clk_hw *hw)
 {
-	return PTR_ERR_OR_ZERO(__clk_register(dev, dev_of_node(dev), hw));
+	return PTR_ERR_OR_ZERO(__clk_register(dev, dev_or_parent_of_node(dev),
+			       hw));
 }
 EXPORT_SYMBOL_GPL(clk_hw_register);
 
-- 
2.20.1

