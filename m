Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E905632905B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbhCAUHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235731AbhCATy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 229A665357;
        Mon,  1 Mar 2021 17:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621254;
        bh=E6XF8j4WUmRONjQdlpbT/dDDBQ+Edu+yQgaaG+u4nL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FszKimFbaUOOfRufAKOmAn6FM1VbL4GTYxl/yaRRdNKD/kTUY8NvE3hwcpNeURA/B
         HmvIvbNRUuJ0aspgx9xpWnxkTMmPP+0c4zaJmg12pmokdLS6MOVi0i7zxau8HSqh8b
         LIWmvpmTvbdkoaJS/EV0IrCQDPqZCFnu/dfHT5Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 449/775] regulator: bd718x7, bd71828, Fix dvs voltage levels
Date:   Mon,  1 Mar 2021 17:10:17 +0100
Message-Id: <20210301161223.736252254@linuxfoundation.org>
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

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit c294554111a835598b557db789d9ad2379b512a2 ]

The ROHM BD718x7 and BD71828 drivers support setting HW state
specific voltages from device-tree. This is used also by various
in-tree DTS files.

These drivers do incorrectly try to compose bit-map using enum
values. By a chance this works for first two valid levels having
values 1 and 2 - but setting values for the rest of the levels
do indicate capability of setting values for first levels as
well. Luckily the regulators which support setting values for
SUSPEND/LPSR do usually also support setting values for RUN
and IDLE too - thus this has not been such a fatal issue.

Fix this by defining the old enum values as bits and fixing the
parsing code. This allows keeping existing IC specific drivers
intact and only slightly changing the rohm-regulator.c

Fixes: 21b72156ede8b ("regulator: bd718x7: Split driver to common and bd718x7 specific parts")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210212080023.GA880728@localhost.localdomain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rohm-regulator.c |  9 ++++++---
 include/linux/mfd/rohm-generic.h   | 14 ++++++--------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/rohm-regulator.c b/drivers/regulator/rohm-regulator.c
index 399002383b28b..5c558b153d55e 100644
--- a/drivers/regulator/rohm-regulator.c
+++ b/drivers/regulator/rohm-regulator.c
@@ -52,9 +52,12 @@ int rohm_regulator_set_dvs_levels(const struct rohm_dvs_config *dvs,
 	char *prop;
 	unsigned int reg, mask, omask, oreg = desc->enable_reg;
 
-	for (i = 0; i < ROHM_DVS_LEVEL_MAX && !ret; i++) {
-		if (dvs->level_map & (1 << i)) {
-			switch (i + 1) {
+	for (i = 0; i < ROHM_DVS_LEVEL_VALID_AMOUNT && !ret; i++) {
+		int bit;
+
+		bit = BIT(i);
+		if (dvs->level_map & bit) {
+			switch (bit) {
 			case ROHM_DVS_LEVEL_RUN:
 				prop = "rohm,dvs-run-voltage";
 				reg = dvs->run_reg;
diff --git a/include/linux/mfd/rohm-generic.h b/include/linux/mfd/rohm-generic.h
index 4283b5b33e040..2b85b9deb03ae 100644
--- a/include/linux/mfd/rohm-generic.h
+++ b/include/linux/mfd/rohm-generic.h
@@ -20,14 +20,12 @@ struct rohm_regmap_dev {
 	struct regmap *regmap;
 };
 
-enum {
-	ROHM_DVS_LEVEL_UNKNOWN,
-	ROHM_DVS_LEVEL_RUN,
-	ROHM_DVS_LEVEL_IDLE,
-	ROHM_DVS_LEVEL_SUSPEND,
-	ROHM_DVS_LEVEL_LPSR,
-	ROHM_DVS_LEVEL_MAX = ROHM_DVS_LEVEL_LPSR,
-};
+#define ROHM_DVS_LEVEL_RUN		BIT(0)
+#define ROHM_DVS_LEVEL_IDLE		BIT(1)
+#define ROHM_DVS_LEVEL_SUSPEND		BIT(2)
+#define ROHM_DVS_LEVEL_LPSR		BIT(3)
+#define ROHM_DVS_LEVEL_VALID_AMOUNT	4
+#define ROHM_DVS_LEVEL_UNKNOWN		0
 
 /**
  * struct rohm_dvs_config - dynamic voltage scaling register descriptions
-- 
2.27.0



