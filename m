Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979D01E2E14
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391391AbgEZTEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390485AbgEZTEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:04:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C40CB20849;
        Tue, 26 May 2020 19:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519880;
        bh=q52oCTslmfWu8UFWSgvt3snEHbJZpSrBNpItw+cgWkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBKhqsS2y2hUOvAJCGaxF3sRfpl1uf+wpovO9SjY9Q52iZYpIi9Bn9Z6/0mmNIWGX
         UQGxMvszU51ySP20vL4cM/qacmK9w+KpamUnnxn9NrJ12yYFGjoyanl1b2yPVgv3vW
         2hFPIKKfU/lRbj0eshDfP+BF6tiOiZjswhmdy/Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/81] nfit: Add Hyper-V NVDIMM DSM command set to white list
Date:   Tue, 26 May 2020 20:53:26 +0200
Message-Id: <20200526183932.809967880@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 1194c4133195dfcb6c5fc0935d54bbed872a5285 ]

Add the Hyper-V _DSM command set to the white list of NVDIMM command
sets.

This command set is documented at http://www.uefi.org/RFIC_LIST
(see "Virtual NVDIMM 0x1901").

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c   | 17 ++++++++++++++---
 drivers/acpi/nfit/nfit.h   |  6 +++++-
 include/uapi/linux/ndctl.h |  1 +
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 8340c81b258b..dd4c7289610e 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1773,9 +1773,17 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	dev_set_drvdata(&adev_dimm->dev, nfit_mem);
 
 	/*
-	 * Until standardization materializes we need to consider 4
-	 * different command sets.  Note, that checking for function0 (bit0)
-	 * tells us if any commands are reachable through this GUID.
+	 * There are 4 "legacy" NVDIMM command sets
+	 * (NVDIMM_FAMILY_{INTEL,MSFT,HPE1,HPE2}) that were created before
+	 * an EFI working group was established to constrain this
+	 * proliferation. The nfit driver probes for the supported command
+	 * set by GUID. Note, if you're a platform developer looking to add
+	 * a new command set to this probe, consider using an existing set,
+	 * or otherwise seek approval to publish the command set at
+	 * http://www.uefi.org/RFIC_LIST.
+	 *
+	 * Note, that checking for function0 (bit0) tells us if any commands
+	 * are reachable through this GUID.
 	 */
 	for (i = 0; i <= NVDIMM_FAMILY_MAX; i++)
 		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
@@ -1798,6 +1806,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 			dsm_mask &= ~(1 << 8);
 	} else if (nfit_mem->family == NVDIMM_FAMILY_MSFT) {
 		dsm_mask = 0xffffffff;
+	} else if (nfit_mem->family == NVDIMM_FAMILY_HYPERV) {
+		dsm_mask = 0x1f;
 	} else {
 		dev_dbg(dev, "unknown dimm command family\n");
 		nfit_mem->family = -1;
@@ -3622,6 +3632,7 @@ static __init int nfit_init(void)
 	guid_parse(UUID_NFIT_DIMM_N_HPE1, &nfit_uuid[NFIT_DEV_DIMM_N_HPE1]);
 	guid_parse(UUID_NFIT_DIMM_N_HPE2, &nfit_uuid[NFIT_DEV_DIMM_N_HPE2]);
 	guid_parse(UUID_NFIT_DIMM_N_MSFT, &nfit_uuid[NFIT_DEV_DIMM_N_MSFT]);
+	guid_parse(UUID_NFIT_DIMM_N_HYPERV, &nfit_uuid[NFIT_DEV_DIMM_N_HYPERV]);
 
 	nfit_wq = create_singlethread_workqueue("nfit");
 	if (!nfit_wq)
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 68848fc4b7c9..cc2ec62951de 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -34,11 +34,14 @@
 /* https://msdn.microsoft.com/library/windows/hardware/mt604741 */
 #define UUID_NFIT_DIMM_N_MSFT "1ee68b36-d4bd-4a1a-9a16-4f8e53d46e05"
 
+/* http://www.uefi.org/RFIC_LIST (see "Virtual NVDIMM 0x1901") */
+#define UUID_NFIT_DIMM_N_HYPERV "5746c5f2-a9a2-4264-ad0e-e4ddc9e09e80"
+
 #define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
 		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
 
-#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_MSFT
+#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_HYPERV
 
 #define NVDIMM_STANDARD_CMDMASK \
 (1 << ND_CMD_SMART | 1 << ND_CMD_SMART_THRESHOLD | 1 << ND_CMD_DIMM_FLAGS \
@@ -75,6 +78,7 @@ enum nfit_uuids {
 	NFIT_DEV_DIMM_N_HPE1 = NVDIMM_FAMILY_HPE1,
 	NFIT_DEV_DIMM_N_HPE2 = NVDIMM_FAMILY_HPE2,
 	NFIT_DEV_DIMM_N_MSFT = NVDIMM_FAMILY_MSFT,
+	NFIT_DEV_DIMM_N_HYPERV = NVDIMM_FAMILY_HYPERV,
 	NFIT_SPA_VOLATILE,
 	NFIT_SPA_PM,
 	NFIT_SPA_DCR,
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 2f2c43d633c5..7b0189d6dfa9 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -247,6 +247,7 @@ struct nd_cmd_pkg {
 #define NVDIMM_FAMILY_HPE1 1
 #define NVDIMM_FAMILY_HPE2 2
 #define NVDIMM_FAMILY_MSFT 3
+#define NVDIMM_FAMILY_HYPERV 4
 
 #define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
 					struct nd_cmd_pkg)
-- 
2.25.1



