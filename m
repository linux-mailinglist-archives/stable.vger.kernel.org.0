Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359CE16761E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbgBUIIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:08:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732243AbgBUIIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:08:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E56520722;
        Fri, 21 Feb 2020 08:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272527;
        bh=Ub8G3HeCiVqwopxkJ/unRKyVlD9x9u4VUfXKklzVoKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pz5RB1YVFdoxc24Kyg31r5GepYLmJ/7fvG2WLifTDywpvulOyKoIc42ai+RBCq549
         4NMFd/HF/rpCyCgCnGf8t3z6BtCuIvUzpqeTCdnPMCxN+mPEcF8YVEdT6f0/EUJTPg
         aho/Lrlg9ntzD2PO2B6p+lZsr2LMeJ+L0b69Si10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Niklas Cassel <nks@flawful.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/344] clk: Use parent node pointer during registration if necessary
Date:   Fri, 21 Feb 2020 08:39:34 +0100
Message-Id: <20200221072404.862674329@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b0344a1a03704..62d0fc486d3a2 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3718,6 +3718,28 @@ fail_out:
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
@@ -3733,7 +3755,7 @@ fail_out:
  */
 struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 {
-	return __clk_register(dev, dev_of_node(dev), hw);
+	return __clk_register(dev, dev_or_parent_of_node(dev), hw);
 }
 EXPORT_SYMBOL_GPL(clk_register);
 
@@ -3749,7 +3771,8 @@ EXPORT_SYMBOL_GPL(clk_register);
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



