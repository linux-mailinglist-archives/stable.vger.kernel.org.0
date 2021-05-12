Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD2D37CC78
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239623AbhELQpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243168AbhELQgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71B4261CD2;
        Wed, 12 May 2021 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835279;
        bh=ZrJuf0WmWqv/z9BfJRKW0goRXdZM2t4UcJi7iijX3Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmT01SNpmuNcaw6B1x75jyHKZUdjM/i1lJmlS4IgIpNvXcHuykEK1LGzLv9q+QXqu
         h8scfz8PcgJ2X47h3E9ZXMZRK3jzyY5jEOmPcU0iruOQ3ecj4uCN4Q3YaMtA2tbJTk
         SQHkRx5ScTzZHya7e8r/DcSBZO3rpLLJ3fSUwLNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        He Ying <heying24@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 280/677] cpuidle: Fix ARM_QCOM_SPM_CPUIDLE configuration
Date:   Wed, 12 May 2021 16:45:26 +0200
Message-Id: <20210512144846.521660714@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Ying <heying24@huawei.com>

[ Upstream commit 498ba2a8a2756694b6f3888857426dbc8a5e6b6c ]

When CONFIG_ARM_QCOM_SPM_CPUIDLE is y and CONFIG_MMU is not set,
compiling errors are encountered as follows:

drivers/cpuidle/cpuidle-qcom-spm.o: In function `spm_dev_probe':
cpuidle-qcom-spm.c:(.text+0x140): undefined reference to `cpu_resume_arm'
cpuidle-qcom-spm.c:(.text+0x148): undefined reference to `cpu_resume_arm'

Note that cpu_resume_arm is defined when MMU is set. So, add dependency
on MMU in ARM_QCOM_SPM_CPUIDLE configuration.

Fixes: a871be6b8eee ("cpuidle: Convert Qualcomm SPM driver to a generic CPUidle driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: He Ying <heying24@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210406123328.92904-1-heying24@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/Kconfig.arm | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
index 0844fadc4be8..334f83e56120 100644
--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -107,7 +107,7 @@ config ARM_TEGRA_CPUIDLE
 
 config ARM_QCOM_SPM_CPUIDLE
 	bool "CPU Idle Driver for Qualcomm Subsystem Power Manager (SPM)"
-	depends on (ARCH_QCOM || COMPILE_TEST) && !ARM64
+	depends on (ARCH_QCOM || COMPILE_TEST) && !ARM64 && MMU
 	select ARM_CPU_SUSPEND
 	select CPU_IDLE_MULTIPLE_DRIVERS
 	select DT_IDLE_STATES
-- 
2.30.2



