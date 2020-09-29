Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698AE27C94A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgI2MJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730207AbgI2Lhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 377FA221EC;
        Tue, 29 Sep 2020 11:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378479;
        bh=2Pt292oqTixcGNkUQASt3G7aRheBl8LC39QonaNofmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcnX7DWVX5OsEyXKs+AyiFTThUq46k9m35yVmCV8J70D7WbM1f452tUPi6XWLbAq7
         1h2LDIdKQbDvI7gi4KfLk8pTHdWp0wVh4HZ9IkxQOauIIReowHcYAPwzWx4QzktZLb
         sjIOjkj6AbTRjHD9X8MUrx+icOQyNVRWwMeYwAUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Lazeev <ivan.lazeev@gmail.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/245] tpm_crb: fix fTPM on AMD Zen+ CPUs
Date:   Tue, 29 Sep 2020 12:57:59 +0200
Message-Id: <20200929105948.373916349@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Lazeev <ivan.lazeev@gmail.com>

[ Upstream commit 3ef193822b25e9ee629974f66dc1ff65167f770c ]

Bug link: https://bugzilla.kernel.org/show_bug.cgi?id=195657

cmd/rsp buffers are expected to be in the same ACPI region.
For Zen+ CPUs BIOS's might report two different regions, some of
them also report region sizes inconsistent with values from TPM
registers.

Memory configuration on ASRock x470 ITX:

db0a0000-dc59efff : Reserved
        dc57e000-dc57efff : MSFT0101:00
        dc582000-dc582fff : MSFT0101:00

Work around the issue by storing ACPI regions declared for the
device in a fixed array and adding an array for pointers to
corresponding possibly allocated resources in crb_map_io function.
This data was previously held for a single resource
in struct crb_priv (iobase field) and local variable io_res in
crb_map_io function. ACPI resources array is used to find index of
corresponding region for each buffer and make the buffer size
consistent with region's length. Array of pointers to allocated
resources is used to map the region at most once.

Signed-off-by: Ivan Lazeev <ivan.lazeev@gmail.com>
Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_crb.c | 123 +++++++++++++++++++++++++++----------
 1 file changed, 90 insertions(+), 33 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 763fc7e6c0058..20f27100708bd 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -26,6 +26,7 @@
 #include "tpm.h"
 
 #define ACPI_SIG_TPM2 "TPM2"
+#define TPM_CRB_MAX_RESOURCES 3
 
 static const guid_t crb_acpi_start_guid =
 	GUID_INIT(0x6BBF6CAB, 0x5463, 0x4714,
@@ -95,7 +96,6 @@ enum crb_status {
 struct crb_priv {
 	u32 sm;
 	const char *hid;
-	void __iomem *iobase;
 	struct crb_regs_head __iomem *regs_h;
 	struct crb_regs_tail __iomem *regs_t;
 	u8 __iomem *cmd;
@@ -438,21 +438,27 @@ static const struct tpm_class_ops tpm_crb = {
 
 static int crb_check_resource(struct acpi_resource *ares, void *data)
 {
-	struct resource *io_res = data;
+	struct resource *iores_array = data;
 	struct resource_win win;
 	struct resource *res = &(win.res);
+	int i;
 
 	if (acpi_dev_resource_memory(ares, res) ||
 	    acpi_dev_resource_address_space(ares, &win)) {
-		*io_res = *res;
-		io_res->name = NULL;
+		for (i = 0; i < TPM_CRB_MAX_RESOURCES + 1; ++i) {
+			if (resource_type(iores_array + i) != IORESOURCE_MEM) {
+				iores_array[i] = *res;
+				iores_array[i].name = NULL;
+				break;
+			}
+		}
 	}
 
 	return 1;
 }
 
-static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
-				 struct resource *io_res, u64 start, u32 size)
+static void __iomem *crb_map_res(struct device *dev, struct resource *iores,
+				 void __iomem **iobase_ptr, u64 start, u32 size)
 {
 	struct resource new_res = {
 		.start	= start,
@@ -464,10 +470,16 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 	if (start != new_res.start)
 		return (void __iomem *) ERR_PTR(-EINVAL);
 
-	if (!resource_contains(io_res, &new_res))
+	if (!iores)
 		return devm_ioremap_resource(dev, &new_res);
 
-	return priv->iobase + (new_res.start - io_res->start);
+	if (!*iobase_ptr) {
+		*iobase_ptr = devm_ioremap_resource(dev, iores);
+		if (IS_ERR(*iobase_ptr))
+			return *iobase_ptr;
+	}
+
+	return *iobase_ptr + (new_res.start - iores->start);
 }
 
 /*
@@ -494,9 +506,13 @@ static u64 crb_fixup_cmd_size(struct device *dev, struct resource *io_res,
 static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		      struct acpi_table_tpm2 *buf)
 {
-	struct list_head resources;
-	struct resource io_res;
+	struct list_head acpi_resource_list;
+	struct resource iores_array[TPM_CRB_MAX_RESOURCES + 1] = { {0} };
+	void __iomem *iobase_array[TPM_CRB_MAX_RESOURCES] = {NULL};
 	struct device *dev = &device->dev;
+	struct resource *iores;
+	void __iomem **iobase_ptr;
+	int i;
 	u32 pa_high, pa_low;
 	u64 cmd_pa;
 	u32 cmd_size;
@@ -505,21 +521,41 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	u32 rsp_size;
 	int ret;
 
-	INIT_LIST_HEAD(&resources);
-	ret = acpi_dev_get_resources(device, &resources, crb_check_resource,
-				     &io_res);
+	INIT_LIST_HEAD(&acpi_resource_list);
+	ret = acpi_dev_get_resources(device, &acpi_resource_list,
+				     crb_check_resource, iores_array);
 	if (ret < 0)
 		return ret;
-	acpi_dev_free_resource_list(&resources);
+	acpi_dev_free_resource_list(&acpi_resource_list);
 
-	if (resource_type(&io_res) != IORESOURCE_MEM) {
+	if (resource_type(iores_array) != IORESOURCE_MEM) {
 		dev_err(dev, FW_BUG "TPM2 ACPI table does not define a memory resource\n");
 		return -EINVAL;
+	} else if (resource_type(iores_array + TPM_CRB_MAX_RESOURCES) ==
+		IORESOURCE_MEM) {
+		dev_warn(dev, "TPM2 ACPI table defines too many memory resources\n");
+		memset(iores_array + TPM_CRB_MAX_RESOURCES,
+		       0, sizeof(*iores_array));
+		iores_array[TPM_CRB_MAX_RESOURCES].flags = 0;
 	}
 
-	priv->iobase = devm_ioremap_resource(dev, &io_res);
-	if (IS_ERR(priv->iobase))
-		return PTR_ERR(priv->iobase);
+	iores = NULL;
+	iobase_ptr = NULL;
+	for (i = 0; resource_type(iores_array + i) == IORESOURCE_MEM; ++i) {
+		if (buf->control_address >= iores_array[i].start &&
+		    buf->control_address + sizeof(struct crb_regs_tail) - 1 <=
+		    iores_array[i].end) {
+			iores = iores_array + i;
+			iobase_ptr = iobase_array + i;
+			break;
+		}
+	}
+
+	priv->regs_t = crb_map_res(dev, iores, iobase_ptr, buf->control_address,
+				   sizeof(struct crb_regs_tail));
+
+	if (IS_ERR(priv->regs_t))
+		return PTR_ERR(priv->regs_t);
 
 	/* The ACPI IO region starts at the head area and continues to include
 	 * the control area, as one nice sane region except for some older
@@ -527,9 +563,10 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	 */
 	if ((priv->sm == ACPI_TPM2_COMMAND_BUFFER) ||
 	    (priv->sm == ACPI_TPM2_MEMORY_MAPPED)) {
-		if (buf->control_address == io_res.start +
+		if (iores &&
+		    buf->control_address == iores->start +
 		    sizeof(*priv->regs_h))
-			priv->regs_h = priv->iobase;
+			priv->regs_h = *iobase_ptr;
 		else
 			dev_warn(dev, FW_BUG "Bad ACPI memory layout");
 	}
@@ -538,13 +575,6 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	if (ret)
 		return ret;
 
-	priv->regs_t = crb_map_res(dev, priv, &io_res, buf->control_address,
-				   sizeof(struct crb_regs_tail));
-	if (IS_ERR(priv->regs_t)) {
-		ret = PTR_ERR(priv->regs_t);
-		goto out_relinquish_locality;
-	}
-
 	/*
 	 * PTT HW bug w/a: wake up the device to access
 	 * possibly not retained registers.
@@ -556,13 +586,26 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	pa_high = ioread32(&priv->regs_t->ctrl_cmd_pa_high);
 	pa_low  = ioread32(&priv->regs_t->ctrl_cmd_pa_low);
 	cmd_pa = ((u64)pa_high << 32) | pa_low;
-	cmd_size = crb_fixup_cmd_size(dev, &io_res, cmd_pa,
-				      ioread32(&priv->regs_t->ctrl_cmd_size));
+	cmd_size = ioread32(&priv->regs_t->ctrl_cmd_size);
+
+	iores = NULL;
+	iobase_ptr = NULL;
+	for (i = 0; iores_array[i].end; ++i) {
+		if (cmd_pa >= iores_array[i].start &&
+		    cmd_pa <= iores_array[i].end) {
+			iores = iores_array + i;
+			iobase_ptr = iobase_array + i;
+			break;
+		}
+	}
+
+	if (iores)
+		cmd_size = crb_fixup_cmd_size(dev, iores, cmd_pa, cmd_size);
 
 	dev_dbg(dev, "cmd_hi = %X cmd_low = %X cmd_size %X\n",
 		pa_high, pa_low, cmd_size);
 
-	priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, cmd_size);
+	priv->cmd = crb_map_res(dev, iores, iobase_ptr,	cmd_pa, cmd_size);
 	if (IS_ERR(priv->cmd)) {
 		ret = PTR_ERR(priv->cmd);
 		goto out;
@@ -570,11 +613,25 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 
 	memcpy_fromio(&__rsp_pa, &priv->regs_t->ctrl_rsp_pa, 8);
 	rsp_pa = le64_to_cpu(__rsp_pa);
-	rsp_size = crb_fixup_cmd_size(dev, &io_res, rsp_pa,
-				      ioread32(&priv->regs_t->ctrl_rsp_size));
+	rsp_size = ioread32(&priv->regs_t->ctrl_rsp_size);
+
+	iores = NULL;
+	iobase_ptr = NULL;
+	for (i = 0; resource_type(iores_array + i) == IORESOURCE_MEM; ++i) {
+		if (rsp_pa >= iores_array[i].start &&
+		    rsp_pa <= iores_array[i].end) {
+			iores = iores_array + i;
+			iobase_ptr = iobase_array + i;
+			break;
+		}
+	}
+
+	if (iores)
+		rsp_size = crb_fixup_cmd_size(dev, iores, rsp_pa, rsp_size);
 
 	if (cmd_pa != rsp_pa) {
-		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
+		priv->rsp = crb_map_res(dev, iores, iobase_ptr,
+					rsp_pa, rsp_size);
 		ret = PTR_ERR_OR_ZERO(priv->rsp);
 		goto out;
 	}
-- 
2.25.1



