Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674D737C1B4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhELPD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232467AbhELPCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E41D661422;
        Wed, 12 May 2021 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831459;
        bh=T4cG0nZfRs3PRmZJWxXQ0vPnvpEDZAlFnRq9c5op5X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyDe3B+JXsekblRPITD3zdocECfJ+JDyYynQboCQMgSPQ1v5z8RsSuEOuXZLVBgRT
         l7vZM9WwHRqlMuVD27dNaKChXDqMcpn6CogFBm6mg/hVII+65LSi4m3AzDm0vfqJt7
         ohAxiee8bS3xiLMMuhNhifewkiERgH4G/OF3zB0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        He Ying <heying24@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/244] firmware: qcom-scm: Fix QCOM_SCM configuration
Date:   Wed, 12 May 2021 16:48:20 +0200
Message-Id: <20210512144747.152434256@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Ying <heying24@huawei.com>

[ Upstream commit 2954a6f12f250890ec2433cec03ba92784d613e8 ]

When CONFIG_QCOM_SCM is y and CONFIG_HAVE_ARM_SMCCC
is not set, compiling errors are encountered as follows:

drivers/firmware/qcom_scm-smc.o: In function `__scm_smc_do_quirk':
qcom_scm-smc.c:(.text+0x36): undefined reference to `__arm_smccc_smc'
drivers/firmware/qcom_scm-legacy.o: In function `scm_legacy_call':
qcom_scm-legacy.c:(.text+0xe2): undefined reference to `__arm_smccc_smc'
drivers/firmware/qcom_scm-legacy.o: In function `scm_legacy_call_atomic':
qcom_scm-legacy.c:(.text+0x1f0): undefined reference to `__arm_smccc_smc'

Note that __arm_smccc_smc is defined when HAVE_ARM_SMCCC is y.
So add dependency on HAVE_ARM_SMCCC in QCOM_SCM configuration.

Fixes: 916f743da354 ("firmware: qcom: scm: Move the scm driver to drivers/firmware")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: He Ying <heying24@huawei.com>
Link: https://lore.kernel.org/r/20210406094200.60952-1-heying24@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e40a77bfe821..7dfbd0f6b76b 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -237,6 +237,7 @@ config INTEL_STRATIX10_RSU
 config QCOM_SCM
 	bool
 	depends on ARM || ARM64
+	depends on HAVE_ARM_SMCCC
 	select RESET_CONTROLLER
 
 config QCOM_SCM_32
-- 
2.30.2



