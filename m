Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E418638A3F1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhETJ6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234619AbhETJ4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:56:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B510661623;
        Thu, 20 May 2021 09:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503467;
        bh=WcZXxMma3oywvHntgEoaPZppZpw7r4oKshEaQ7kByxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWtMb2CU3VngW9K9d8dWd2QdP/TKwZ0IIgkhrqMnmLkn2cKhvrr4EtxnyKtlr+u2N
         2x5jPPFBh9z5ygwsSYW74lTsDMaAvUWKOURu/kT3+UJX5eSsFbMFQSehzuXqdWKsz8
         qp9wLLI+QqZQGgXDSQ8Iu36O4V40a8D8jQPagcT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        He Ying <heying24@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/425] firmware: qcom-scm: Fix QCOM_SCM configuration
Date:   Thu, 20 May 2021 11:19:46 +0200
Message-Id: <20210520092138.556283208@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index ed212c8b4108..1c419e4cea83 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -248,6 +248,7 @@ config FW_CFG_SYSFS_CMDLINE
 config QCOM_SCM
 	bool
 	depends on ARM || ARM64
+	depends on HAVE_ARM_SMCCC
 	select RESET_CONTROLLER
 
 config QCOM_SCM_32
-- 
2.30.2



