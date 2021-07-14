Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD53C8CCD
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhGNTmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234060AbhGNTm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE8F613E8;
        Wed, 14 Jul 2021 19:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291575;
        bh=CDD/eU8uqxXVkikuMQP2quVTsly3zHxQUO7zownDfzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VILpp57HBp1qyZKOVMi3mem9NM7RcTYOIg6j4/pjzINDsZFZOfX53OGd70UzJ5WHi
         5KEnCuz6lf8vWoEJNz2VPWVRFS7ildf9LLqKcdFozKj7HtBmMsa4u6MP5HyecF1X8o
         V9qWrO4EdY2omWBmWT7TtdrCaVQ1v7RYsa/JpOC4lNpdusO4Z4wtElCxhmbKTAAy79
         UiXW/8hCIUQRbnbDRcVpBBaqMMxuDpYWI8Bu1NRW5ZlDpxSmxMalTIlDJ5T8QPEeR2
         iUU6gstZTvW6LUR8NlVSLuxh0Ztg/foupfhPJesHjikUW4PlQqIYR6MZhQDXegWVzR
         HE4UTKpPL8KeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 065/108] firmware: arm_scmi: Fix the build when CONFIG_MAILBOX is not selected
Date:   Wed, 14 Jul 2021 15:37:17 -0400
Message-Id: <20210714193800.52097-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 66eb3f0e5daf..41d80bbaa9a2 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1567,7 +1567,9 @@ ATTRIBUTE_GROUPS(versions);
 
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

