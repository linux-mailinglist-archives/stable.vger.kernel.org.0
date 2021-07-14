Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3873C8F6F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhGNTwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239654AbhGNTtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6C50613B5;
        Wed, 14 Jul 2021 19:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291866;
        bh=vswd9vLlAh48k+hOubWqFw2XWvN+q9gpk74CyZFCUtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjzJ0sHjibaCrLL+Jgk7F5x1sKkk5VosaONNtcNsDTzQIhpwIyX+qicVF2vg1ekZV
         y8/2ucG3CcpYo/noqyyLTSkryShDu7qex0pSCm4A1AuDzEosTRxUEu5kZwz9Jy336S
         wZRW7AllTX/qsIDuNE48wSDX3umAs6QfIzV6snDaVC+3T6UH76tNhI8l8jeHO1yyi5
         rCTD1qYatyIyaCXGMag/QywPzsAt4YAwLE2hLXTMOcsQVx5Cjprx4c8UAjAZ6tutX6
         HQ0oiRNLQr26c7HCMHFpclC1ej7lPb5PrhM+tzWixYduJMybZpvVktPk5M6gj22MWn
         w6cOp/ZGRWk9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 55/88] firmware: arm_scmi: Fix the build when CONFIG_MAILBOX is not selected
Date:   Wed, 14 Jul 2021 15:42:30 -0400
Message-Id: <20210714194303.54028-55-sashal@kernel.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit ab7766b72855e6a68109b915d071181b93086e29 ]

0day CI kernel test robot reported following build error with randconfig

aarch64-linux-ld: drivers/firmware/arm_scmi/driver.o:(.rodata+0x1e0):
		undefined reference to `scmi_mailbox_desc'

Fix the error by adding CONFIG_MAILBOX dependency for scmi_mailbox_desc.

Link: https://lore.kernel.org/r/20210603072631.1660963-1-sudeep.holla@arm.com
Cc: Etienne Carriere <etienne.carriere@linaro.org>
Cc: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Etienne Carriere <etienne.carriere@linaro.org>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 6b2ce3f28f7b..7efbf66f117b 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -918,7 +918,9 @@ ATTRIBUTE_GROUPS(versions);
 
 /* Each compatible listed below must have descriptor associated with it */
 static const struct of_device_id scmi_of_match[] = {
+#ifdef CONFIG_MAILBOX
 	{ .compatible = "arm,scmi", .data = &scmi_mailbox_desc },
+#endif
 #ifdef CONFIG_HAVE_ARM_SMCCC_DISCOVERY
 	{ .compatible = "arm,scmi-smc", .data = &scmi_smc_desc},
 #endif
-- 
2.30.2

