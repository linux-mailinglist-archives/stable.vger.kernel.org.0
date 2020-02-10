Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A29157923
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgBJNMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbgBJMiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:46 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140B520838;
        Mon, 10 Feb 2020 12:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338326;
        bh=kIFTEBfA3dx7yd2p+vy1SVGpsCsAblpfc3uwi/4hlZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWuXXOHJtOtd4offod/FghRdKRLpqkPIj4s9qrsGTNJdQ6PBeZUd43czLZgpy9fCH
         aXXCoxr8Cx6W/zXMbLgJ/MaREcsSsPTRR6QNfYy/N29/4c3KMS7kV/CTjoEBBWUR2g
         QHWlMTERozzjOMdq1NKcahvvzTtiVnD5w8Xiatbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@gmail.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Mark Brown <broonie@kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Subject: [PATCH 5.4 261/309] regulator: core: Add regulator_is_equal() helper
Date:   Mon, 10 Feb 2020 04:33:37 -0800
Message-Id: <20200210122431.731980081@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit b059b7e0ec3208ff1e17cff6387d75a9fbab4e02 upstream.

Add regulator_is_equal() helper to compare whether two regulators are
the same. This is useful for checking whether two separate regulators
in a driver are actually the same supply.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Igor Opaniuk <igor.opaniuk@toradex.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Link: https://lore.kernel.org/r/20191220164450.1395038-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/helpers.c        |   14 ++++++++++++++
 include/linux/regulator/consumer.h |    7 +++++++
 2 files changed, 21 insertions(+)

--- a/drivers/regulator/helpers.c
+++ b/drivers/regulator/helpers.c
@@ -13,6 +13,8 @@
 #include <linux/regulator/driver.h>
 #include <linux/module.h>
 
+#include "internal.h"
+
 /**
  * regulator_is_enabled_regmap - standard is_enabled() for regmap users
  *
@@ -881,3 +883,15 @@ void regulator_bulk_set_supply_names(str
 		consumers[i].supply = supply_names[i];
 }
 EXPORT_SYMBOL_GPL(regulator_bulk_set_supply_names);
+
+/**
+ * regulator_is_equal - test whether two regulators are the same
+ *
+ * @reg1: first regulator to operate on
+ * @reg2: second regulator to operate on
+ */
+bool regulator_is_equal(struct regulator *reg1, struct regulator *reg2)
+{
+	return reg1->rdev == reg2->rdev;
+}
+EXPORT_SYMBOL_GPL(regulator_is_equal);
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -287,6 +287,8 @@ void regulator_bulk_set_supply_names(str
 				     const char *const *supply_names,
 				     unsigned int num_supplies);
 
+bool regulator_is_equal(struct regulator *reg1, struct regulator *reg2);
+
 #else
 
 /*
@@ -593,6 +595,11 @@ regulator_bulk_set_supply_names(struct r
 {
 }
 
+static inline bool
+regulator_is_equal(struct regulator *reg1, struct regulator *reg2);
+{
+	return false;
+}
 #endif
 
 static inline int regulator_set_voltage_triplet(struct regulator *regulator,


