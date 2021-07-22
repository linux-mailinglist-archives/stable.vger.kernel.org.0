Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BEF3D2864
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhGVP47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:32946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232822AbhGVP4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C8B461362;
        Thu, 22 Jul 2021 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971841;
        bh=TcLEGpQPIjobDcUSChomeU0B3TP8FV1k6DGipp2SmGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+N+a1WamQRoneLdEFySkIJgiR91+YnbltxBTGVYMmlHZZj8y/w1bBYvG5WHb6sND
         Tx5jgwHjuGHH5gCQ+sh3xLpr1R0++N/K6n/qStuz5sJ7wIHYDcc1I6SuarmYTVQ67S
         s7NR1c0KCYjtK0j0ifQ8Sj83cjisAXOAmBapQejs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        kernel test robot <lkp@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/125] firmware: arm_scmi: Fix the build when CONFIG_MAILBOX is not selected
Date:   Thu, 22 Jul 2021 18:30:39 +0200
Message-Id: <20210722155626.317897290@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f9901fadb3a4..af4560dab6b4 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -922,7 +922,9 @@ ATTRIBUTE_GROUPS(versions);
 
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



