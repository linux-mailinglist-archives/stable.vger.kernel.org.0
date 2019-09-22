Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F99BA5DA
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389753AbfIVSqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389708AbfIVSp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 370C9206B6;
        Sun, 22 Sep 2019 18:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177957;
        bh=QfMwwp7k4LX8qa7VmAQXWyOp4djjbtF2k0Y/KYrJ/lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhCIviT2CLMlXiJrdUoj82ykiucHaCPjfz0CaqHOKQi9dUvhx+Zkopw+sDYhR4y4M
         pq1eYpcpqfDJcV4Yn7yQKyW17vQhn1iuFhyqMEEQMdleL8KA3d2L6zNscWzksET7D2
         y29Riszm2+eAsNP1yWCV3Xf487UIOa343Abb89gI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaofei Tan <tanxiaofei@huawei.com>,
        James Morse <james.morse@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 062/203] efi: cper: print AER info of PCIe fatal error
Date:   Sun, 22 Sep 2019 14:41:28 -0400
Message-Id: <20190922184350.30563-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

[ Upstream commit b194a77fcc4001dc40aecdd15d249648e8a436d1 ]

AER info of PCIe fatal error is not printed in the current driver.
Because APEI driver will panic directly for fatal error, and can't
run to the place of printing AER info.

An example log is as following:
{763}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 11
{763}[Hardware Error]: event severity: fatal
{763}[Hardware Error]:  Error 0, type: fatal
{763}[Hardware Error]:   section_type: PCIe error
{763}[Hardware Error]:   port_type: 0, PCIe end point
{763}[Hardware Error]:   version: 4.0
{763}[Hardware Error]:   command: 0x0000, status: 0x0010
{763}[Hardware Error]:   device_id: 0000:82:00.0
{763}[Hardware Error]:   slot: 0
{763}[Hardware Error]:   secondary_bus: 0x00
{763}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x10fb
{763}[Hardware Error]:   class_code: 000002
Kernel panic - not syncing: Fatal hardware error!

This issue was imported by the patch, '37448adfc7ce ("aerdrv: Move
cper_print_aer() call out of interrupt context")'. To fix this issue,
this patch adds print of AER info in cper_print_pcie() for fatal error.

Here is the example log after this patch applied:
{24}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 10
{24}[Hardware Error]: event severity: fatal
{24}[Hardware Error]:  Error 0, type: fatal
{24}[Hardware Error]:   section_type: PCIe error
{24}[Hardware Error]:   port_type: 0, PCIe end point
{24}[Hardware Error]:   version: 4.0
{24}[Hardware Error]:   command: 0x0546, status: 0x4010
{24}[Hardware Error]:   device_id: 0000:01:00.0
{24}[Hardware Error]:   slot: 0
{24}[Hardware Error]:   secondary_bus: 0x00
{24}[Hardware Error]:   vendor_id: 0x15b3, device_id: 0x1019
{24}[Hardware Error]:   class_code: 000002
{24}[Hardware Error]:   aer_uncor_status: 0x00040000, aer_uncor_mask: 0x00000000
{24}[Hardware Error]:   aer_uncor_severity: 0x00062010
{24}[Hardware Error]:   TLP Header: 000000c0 01010000 00000001 00000000
Kernel panic - not syncing: Fatal hardware error!

Fixes: 37448adfc7ce ("aerdrv: Move cper_print_aer() call out of interrupt context")
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Reviewed-by: James Morse <james.morse@arm.com>
[ardb: put parens around terms of && operator]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 8fa977c7861f9..addf0749dd8b6 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -390,6 +390,21 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 		printk(
 	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
+
+	/* Fatal errors call __ghes_panic() before AER handler prints this */
+	if ((pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) &&
+	    (gdata->error_severity & CPER_SEV_FATAL)) {
+		struct aer_capability_regs *aer;
+
+		aer = (struct aer_capability_regs *)pcie->aer_info;
+		printk("%saer_uncor_status: 0x%08x, aer_uncor_mask: 0x%08x\n",
+		       pfx, aer->uncor_status, aer->uncor_mask);
+		printk("%saer_uncor_severity: 0x%08x\n",
+		       pfx, aer->uncor_severity);
+		printk("%sTLP Header: %08x %08x %08x %08x\n", pfx,
+		       aer->header_log.dw0, aer->header_log.dw1,
+		       aer->header_log.dw2, aer->header_log.dw3);
+	}
 }
 
 static void cper_print_tstamp(const char *pfx,
-- 
2.20.1

