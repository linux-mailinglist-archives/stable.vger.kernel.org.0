Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FB53C8F72
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbhGNTwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239659AbhGNTtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F374613D2;
        Wed, 14 Jul 2021 19:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291865;
        bh=SZnq5VVEghT7dcss/neDjXEOAvWnzcf2v5dVXoj4GhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8PLUeoK5QOIL4qq2n2CFvfbpt/j+69003HUksnUrQUCIJTE9ZAUlgA6vSrQTuHAf
         PVKtRY1/BFj2gbEo6+Aawb4SkeWPXllkUxNcxrecGD2iVR/EXwIrHKqvtrZS+Cvwu+
         v1koidUEVYo6kWgrxHTlkfrcEmFqDO09D5EzwOP88LWNb27gunJopbR97IhlshrCy2
         yJkz7aCaG1Yb+m7ZhQEY/ONqTWFujVo9jE5C5pn9qsmtX3EwU7Qrr5bjlUsaUTx3PH
         ycJYPl4+9US0c6YBzw9yr4+N1+5f0bgBH0YlMmUmILpo0eIzIBHFNcO2gSi1oX942z
         4D/xQTnWsYRLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Etienne Carriere <etienne.carriere@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 54/88] firmware: arm_scmi: Add SMCCC discovery dependency in Kconfig
Date:   Wed, 14 Jul 2021 15:42:29 -0400
Message-Id: <20210714194303.54028-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Etienne Carriere <etienne.carriere@linaro.org>

[ Upstream commit c05b07963e965ae34e75ee8c33af1095350cd87e ]

ARM_SCMI_PROTOCOL depends on either MAILBOX or HAVE_ARM_SMCCC_DISCOVERY,
not MAILBOX alone. Fix the depedency in Kconfig file and driver to
reflect the same.

Link: https://lore.kernel.org/r/20210521134055.24271-1-etienne.carriere@linaro.org
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Etienne Carriere <etienne.carriere@linaro.org>
[sudeep.holla: Minor tweaks to subject and change log]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/Kconfig           | 2 +-
 drivers/firmware/arm_scmi/common.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 5fa6b3ca0a38..c08968c5ddf8 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -9,7 +9,7 @@ menu "Firmware Drivers"
 config ARM_SCMI_PROTOCOL
 	tristate "ARM System Control and Management Interface (SCMI) Message Protocol"
 	depends on ARM || ARM64 || COMPILE_TEST
-	depends on MAILBOX
+	depends on MAILBOX || HAVE_ARM_SMCCC_DISCOVERY
 	help
 	  ARM System Control and Management Interface (SCMI) protocol is a
 	  set of operating system-independent software interfaces that are
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 65063fa948d4..34b7ae7980a3 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -243,7 +243,7 @@ struct scmi_desc {
 };
 
 extern const struct scmi_desc scmi_mailbox_desc;
-#ifdef CONFIG_HAVE_ARM_SMCCC
+#ifdef CONFIG_HAVE_ARM_SMCCC_DISCOVERY
 extern const struct scmi_desc scmi_smc_desc;
 #endif
 
-- 
2.30.2

