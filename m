Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492A6187FC7
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgCQLEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgCQLEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2FE20658;
        Tue, 17 Mar 2020 11:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443070;
        bh=z4bfa8hZ8/4gypOjATA/W96jKijPpT9z5KWSPWrzcXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9e59p/VQqeNKpDjaLeBturIuSDhl2f/KumGRKVS/DF9GZ65HwyQSZd/TzctxcNvP
         VM5DKFWNU/hTA7Ifyk1dA/ihmSqU0vtf2KhB2rWrzEszNGHwyUb//8fGPTCblK1HHa
         X3/edfealCmx6Z2M2oRIHpAZeZrGBt5yh+YFPBtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 086/123] x86/ioremap: Map EFI runtime services data as encrypted for SEV
Date:   Tue, 17 Mar 2020 11:55:13 +0100
Message-Id: <20200317103316.596315932@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 985e537a4082b4635754a57f4f95430790afee6a upstream.

The dmidecode program fails to properly decode the SMBIOS data supplied
by OVMF/UEFI when running in an SEV guest. The SMBIOS area, under SEV, is
encrypted and resides in reserved memory that is marked as EFI runtime
services data.

As a result, when memremap() is attempted for the SMBIOS data, it
can't be mapped as regular RAM (through try_ram_remap()) and, since
the address isn't part of the iomem resources list, it isn't mapped
encrypted through the fallback ioremap().

Add a new __ioremap_check_other() to deal with memory types like
EFI_RUNTIME_SERVICES_DATA which are not covered by the resource ranges.

This allows any runtime services data which has been created encrypted,
to be mapped encrypted too.

 [ bp: Move functionality to a separate function. ]

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
Cc: <stable@vger.kernel.org> # 5.3
Link: https://lkml.kernel.org/r/2d9e16eb5b53dc82665c95c6764b7407719df7a0.1582645327.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/ioremap.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -106,6 +106,19 @@ static unsigned int __ioremap_check_encr
 	return 0;
 }
 
+/*
+ * The EFI runtime services data area is not covered by walk_mem_res(), but must
+ * be mapped encrypted when SEV is active.
+ */
+static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *desc)
+{
+	if (!sev_active())
+		return;
+
+	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA)
+		desc->flags |= IORES_MAP_ENCRYPTED;
+}
+
 static int __ioremap_collect_map_flags(struct resource *res, void *arg)
 {
 	struct ioremap_desc *desc = arg;
@@ -124,6 +137,9 @@ static int __ioremap_collect_map_flags(s
  * To avoid multiple resource walks, this function walks resources marked as
  * IORESOURCE_MEM and IORESOURCE_BUSY and looking for system RAM and/or a
  * resource described not as IORES_DESC_NONE (e.g. IORES_DESC_ACPI_TABLES).
+ *
+ * After that, deal with misc other ranges in __ioremap_check_other() which do
+ * not fall into the above category.
  */
 static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
 				struct ioremap_desc *desc)
@@ -135,6 +151,8 @@ static void __ioremap_check_mem(resource
 	memset(desc, 0, sizeof(struct ioremap_desc));
 
 	walk_mem_res(start, end, desc, __ioremap_collect_map_flags);
+
+	__ioremap_check_other(addr, desc);
 }
 
 /*


