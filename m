Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA0737C3D9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhELPWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234717AbhELPUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A8F6101B;
        Wed, 12 May 2021 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832114;
        bh=Da0r6qMPor97lCV6jlG1+wkZqprTVL8V5I9KHqlC+1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYi7VVMMYCyvYKizPI9bAGoPARbeo1ErKl6XRb8GTPVnZelU/eHh42/Jv/r7D0VYD
         gFdMcyWFEwXjzknruozhgQnzCVR93Oivgs/m06+8MKuXrbMiEIJRd3XuAjnIsom6yF
         ETtMXDeEBsUk43Whp+2lASm1WFjfyQarUxkihWmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/530] firmware: xilinx: Remove zynqmp_pm_get_eemi_ops() in IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
Date:   Wed, 12 May 2021 16:43:43 +0200
Message-Id: <20210512144823.510739886@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

[ Upstream commit 79bfe480a0a0b259ab9fddcd2fe52c03542b1196 ]

zynqmp_pm_get_eemi_ops() was removed in commit 4db8180ffe7c: "Firmware: xilinx:
Remove eemi ops for fpga related APIs", but not in IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE).
Any driver who want to communicate with PMC using EEMI APIs use the functions provided
for each function
This removed zynqmp_pm_get_eemi_ops() in IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE), and also
modify the documentation for this driver.

Fixes: 4db8180ffe7c ("firmware: xilinx: Remove eemi ops for fpga related APIs")
Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Link: https://lore.kernel.org/r/20210215155849.2425846-1-iwamatsu@nigauri.org
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/xilinx/eemi.rst | 31 ++----------------------
 include/linux/firmware/xlnx-zynqmp.h     |  5 ----
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/Documentation/driver-api/xilinx/eemi.rst b/Documentation/driver-api/xilinx/eemi.rst
index 9dcbc6f18d75..c1bc47b9000d 100644
--- a/Documentation/driver-api/xilinx/eemi.rst
+++ b/Documentation/driver-api/xilinx/eemi.rst
@@ -16,35 +16,8 @@ components running across different processing clusters on a chip or
 device to communicate with a power management controller (PMC) on a
 device to issue or respond to power management requests.
 
-EEMI ops is a structure containing all eemi APIs supported by Zynq MPSoC.
-The zynqmp-firmware driver maintain all EEMI APIs in zynqmp_eemi_ops
-structure. Any driver who want to communicate with PMC using EEMI APIs
-can call zynqmp_pm_get_eemi_ops().
-
-Example of EEMI ops::
-
-	/* zynqmp-firmware driver maintain all EEMI APIs */
-	struct zynqmp_eemi_ops {
-		int (*get_api_version)(u32 *version);
-		int (*query_data)(struct zynqmp_pm_query_data qdata, u32 *out);
-	};
-
-	static const struct zynqmp_eemi_ops eemi_ops = {
-		.get_api_version = zynqmp_pm_get_api_version,
-		.query_data = zynqmp_pm_query_data,
-	};
-
-Example of EEMI ops usage::
-
-	static const struct zynqmp_eemi_ops *eemi_ops;
-	u32 ret_payload[PAYLOAD_ARG_CNT];
-	int ret;
-
-	eemi_ops = zynqmp_pm_get_eemi_ops();
-	if (IS_ERR(eemi_ops))
-		return PTR_ERR(eemi_ops);
-
-	ret = eemi_ops->query_data(qdata, ret_payload);
+Any driver who wants to communicate with PMC using EEMI APIs use the
+functions provided for each function.
 
 IOCTL
 ------
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 7fb3274a4a9e..4930ece07fd8 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -354,11 +354,6 @@ int zynqmp_pm_read_pggs(u32 index, u32 *value);
 int zynqmp_pm_system_shutdown(const u32 type, const u32 subtype);
 int zynqmp_pm_set_boot_health_status(u32 value);
 #else
-static inline struct zynqmp_eemi_ops *zynqmp_pm_get_eemi_ops(void)
-{
-	return ERR_PTR(-ENODEV);
-}
-
 static inline int zynqmp_pm_get_api_version(u32 *version)
 {
 	return -ENODEV;
-- 
2.30.2



