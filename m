Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653BE451DCF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbhKPAeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343910AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2714D63603;
        Mon, 15 Nov 2021 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002116;
        bh=9pPerbehqC6kt+NUjCdEae89pMNvRT6x2OzqoxRqx5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tacTZTZHO9i78fH5ZxQxx6xmOl/8BL8NW5yV5OS2uQO7LPE9Ye35HWIzMKArsFpD9
         4YnNIoMjnSb8Vi/forIeqXlVv8x2jQD1/NV2a+opHVEpIKk+dAl+IPR10501eZnSV3
         ap8zN9EGJzdMghfyTMLzn7obUexwtpjwj5jZZENI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/917] thermal/drivers/qcom/lmh: make QCOM_LMH depends on QCOM_SCM
Date:   Mon, 15 Nov 2021 17:58:58 +0100
Message-Id: <20211115165443.800371557@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 9e5a4fb8423081d0efbf165c71c7f4abdf5f918c ]

Without QCOM_SCM, build failed, avoid like below:

aarch64-linux-gnu-ld: Unexpected GOT/PLT entries detected!
aarch64-linux-gnu-ld: Unexpected run-time procedure linkages detected!
aarch64-linux-gnu-ld: drivers/thermal/qcom/lmh.o: in function `lmh_probe':
/data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:141: undefined reference to `qcom_scm_lmh_dcvsh_available'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:144: undefined reference to `qcom_scm_lmh_dcvsh'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:149: undefined reference to `qcom_scm_lmh_dcvsh'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:154: undefined reference to `qcom_scm_lmh_dcvsh'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:159: undefined reference to `qcom_scm_lmh_dcvsh'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:166: undefined reference to `qcom_scm_lmh_profile_change'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:173: undefined reference to `qcom_scm_lmh_dcvsh'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:180: undefined reference to `qcom_scm_lmh_dcvsh'
aarch64-linux-gnu-ld: /data/arm/workspace/kernel-build/linux/build/../drivers/thermal/qcom/lmh.c:187: undefined reference to `qcom_scm_lmh_dcvsh'
make[1]: *** [/data/arm/workspace/kernel-build/linux/Makefile:1183: vmlinux] Error 1
make[1]: Leaving directory '/data/arm/workspace/kernel-build/linux/build'
make: *** [Makefile:219: __sub-make] Error 2
make: Leaving directory '/data/arm/workspace/kernel-build/linux'

Fixes: 53bca371cdf7 ("thermal/drivers/qcom: Add support for LMh driver")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Link: https://lore.kernel.org/r/20211009015853.3509559-1-liu.yun@linux.dev
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/Kconfig b/drivers/thermal/qcom/Kconfig
index 7d942f71e5328..bfd889422dd32 100644
--- a/drivers/thermal/qcom/Kconfig
+++ b/drivers/thermal/qcom/Kconfig
@@ -34,7 +34,7 @@ config QCOM_SPMI_TEMP_ALARM
 
 config QCOM_LMH
 	tristate "Qualcomm Limits Management Hardware"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM && QCOM_SCM
 	help
 	  This enables initialization of Qualcomm limits management
 	  hardware(LMh). LMh allows for hardware-enforced mitigation for cpus based on
-- 
2.33.0



