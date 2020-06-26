Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD4520A98A
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 02:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgFZAGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 20:06:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:38093 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgFZAGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 20:06:41 -0400
IronPort-SDR: CFADhlyPZS0NT0XrDo053smQg+8piigTYEvEqEAM8oPuHZFZR39rfnOH/PvXy65hQzndeu6nnk
 gCj3jphfUsVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="125346999"
X-IronPort-AV: E=Sophos;i="5.75,281,1589266800"; 
   d="scan'208";a="125346999"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 17:06:40 -0700
IronPort-SDR: eftPZifD4Cu8Fzxez9kYD97n9dhdB5f2bKcEl4BqiH/1owPuHgKD1xyB1Yp38C9Oy3XilGA3K5
 ofy7hcKnxGjQ==
X-IronPort-AV: E=Sophos;i="5.75,281,1589266800"; 
   d="scan'208";a="423909955"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 17:06:40 -0700
Subject: [PATCH 01/12] libnvdimm: Validate command family indices
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, stable@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 25 Jun 2020 16:50:25 -0700
Message-ID: <159312902579.1850128.3536310031352445291.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159312902033.1850128.1712559453279208264.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159312902033.1850128.1712559453279208264.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ND_CMD_CALL format allows for a general passthrough of whitelisted
commands targeting a given command set. However there is no validation
of the family index relative to what the bus supports.

- Update the NFIT bus implementation (the only one that supports
  ND_CMD_CALL passthrough) to also whitelist the valid set of command
  family indices.

- Update the generic __nd_ioctl() path to validate that field on behalf
  of all implementations.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command marshaling mechanism")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c   |   11 +++++++++--
 drivers/acpi/nfit/nfit.h   |    1 -
 drivers/nvdimm/bus.c       |   16 ++++++++++++++++
 include/linux/libnvdimm.h  |    2 ++
 include/uapi/linux/ndctl.h |    4 ++++
 5 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7c138a4edc03..1f72ce1a782b 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1823,6 +1823,7 @@ static void populate_shutdown_status(struct nfit_mem *nfit_mem)
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
+	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
 	struct acpi_device *adev, *adev_dimm;
 	struct device *dev = acpi_desc->dev;
 	unsigned long dsm_mask, label_mask;
@@ -1834,6 +1835,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	/* nfit test assumes 1:1 relationship between commands and dsms */
 	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
 	nfit_mem->family = NVDIMM_FAMILY_INTEL;
+	set_bit(NVDIMM_FAMILY_INTEL, &nd_desc->dimm_family_mask);
 
 	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
 		sprintf(nfit_mem->id, "%04x-%02x-%04x-%08x",
@@ -1886,10 +1888,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	 * Note, that checking for function0 (bit0) tells us if any commands
 	 * are reachable through this GUID.
 	 */
+	clear_bit(NVDIMM_FAMILY_INTEL, &nd_desc->dimm_family_mask);
 	for (i = 0; i <= NVDIMM_FAMILY_MAX; i++)
-		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
+		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1)) {
+			set_bit(i, &nd_desc->dimm_family_mask);
 			if (family < 0 || i == default_dsm_family)
 				family = i;
+		}
 
 	/* limit the supported commands to those that are publicly documented */
 	nfit_mem->family = family;
@@ -2153,6 +2158,9 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 
 	nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
 	nd_desc->bus_dsm_mask = acpi_desc->bus_nfit_cmd_force_en;
+	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
+	set_bit(NVDIMM_BUS_FAMILY_NFIT, &nd_desc->bus_family_mask);
+
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev)
 		return;
@@ -2160,7 +2168,6 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_CLEAR_ERROR; i++)
 		if (acpi_check_dsm(adev->handle, guid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->cmd_mask);
-	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
 
 	dsm_mask =
 		(1 << ND_CMD_ARS_CAP) |
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index f5525f8bb770..5c5e7ebba8dc 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -33,7 +33,6 @@
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
 		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
 
-#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_HYPERV
 #define NVDIMM_CMD_MAX 31
 
 #define NVDIMM_STANDARD_CMDMASK \
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 09087c38fabd..955265656b96 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -1037,9 +1037,25 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		dimm_name = "bus";
 	}
 
+	/* Validate command family support against bus declared support */
 	if (cmd == ND_CMD_CALL) {
+		unsigned long *mask;
+
 		if (copy_from_user(&pkg, p, sizeof(pkg)))
 			return -EFAULT;
+
+		if (nvdimm) {
+			if (pkg.nd_family > NVDIMM_FAMILY_MAX)
+				return -EINVAL;
+			mask = &nd_desc->dimm_family_mask;
+		} else {
+			if (pkg.nd_family > NVDIMM_BUS_FAMILY_MAX)
+				return -EINVAL;
+			mask = &nd_desc->bus_family_mask;
+		}
+
+		if (!test_bit(pkg.nd_family, mask))
+			return -EINVAL;
 	}
 
 	if (!desc ||
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 18da4059be09..bd39a2cf7972 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -78,6 +78,8 @@ struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long bus_dsm_mask;
 	unsigned long cmd_mask;
+	unsigned long dimm_family_mask;
+	unsigned long bus_family_mask;
 	struct module *module;
 	char *provider_name;
 	struct device_node *of_node;
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 0e09dc5cec19..e9468b9332bd 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -245,6 +245,10 @@ struct nd_cmd_pkg {
 #define NVDIMM_FAMILY_MSFT 3
 #define NVDIMM_FAMILY_HYPERV 4
 #define NVDIMM_FAMILY_PAPR 5
+#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_PAPR
+
+#define NVDIMM_BUS_FAMILY_NFIT 0
+#define NVDIMM_BUS_FAMILY_MAX NVDIMM_BUS_FAMILY_NFIT
 
 #define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
 					struct nd_cmd_pkg)

