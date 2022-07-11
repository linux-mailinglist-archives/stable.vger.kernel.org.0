Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CCB56FBA5
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiGKJdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiGKJdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DC4DFCD;
        Mon, 11 Jul 2022 02:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B689C61227;
        Mon, 11 Jul 2022 09:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93861C34115;
        Mon, 11 Jul 2022 09:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531067;
        bh=Vl9qchXDrnXIPpbdhnqUfVPKvvwM5SxL0Tt8mIXQMNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Levzabi4wVbiJu168U9VGVvbIqQ51v1e9nZQvosVZ0dTZ4P3a/Pv147hAVQEsc+Xt
         GHheqmvKYnB9qrWQxuBCxrpOcvn+GmkO6o3HNKexYTEE5UBGb7TRU27QL8acGzboNO
         SaMdlNtBas9e+MH58Z7VjLtudgmV/Y6CWMgEwpoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Gondois <pierre.gondois@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 085/112] ACPI: CPPC: Check _OSC for flexible address space
Date:   Mon, 11 Jul 2022 11:07:25 +0200
Message-Id: <20220711090551.984038787@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit 0651ab90e4ade17f1d4f4367b70f6120480410f3 ]

ACPI 6.2 Section 6.2.11.2 'Platform-Wide OSPM Capabilities':
  Starting with ACPI Specification 6.2, all _CPC registers can be in
  PCC, System Memory, System IO, or Functional Fixed Hardware address
  spaces. OSPM support for this more flexible register space scheme is
  indicated by the “Flexible Address Space for CPPC Registers” _OSC bit

Otherwise (cf ACPI 6.1, s8.4.7.1.1.X), _CPC registers must be in:
- PCC or Functional Fixed Hardware address space if defined
- SystemMemory address space (NULL register) if not defined

Add the corresponding _OSC bit and check it when parsing _CPC objects.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c       | 18 ++++++++++++++++++
 drivers/acpi/cppc_acpi.c |  9 +++++++++
 include/linux/acpi.h     |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 3e58b613a2c4..9eca43d1d941 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -278,6 +278,20 @@ bool osc_sb_apei_support_acked;
 bool osc_pc_lpi_support_confirmed;
 EXPORT_SYMBOL_GPL(osc_pc_lpi_support_confirmed);
 
+/*
+ * ACPI 6.2 Section 6.2.11.2 'Platform-Wide OSPM Capabilities':
+ *   Starting with ACPI Specification 6.2, all _CPC registers can be in
+ *   PCC, System Memory, System IO, or Functional Fixed Hardware address
+ *   spaces. OSPM support for this more flexible register space scheme is
+ *   indicated by the “Flexible Address Space for CPPC Registers” _OSC bit.
+ *
+ * Otherwise (cf ACPI 6.1, s8.4.7.1.1.X), _CPC registers must be in:
+ * - PCC or Functional Fixed Hardware address space if defined
+ * - SystemMemory address space (NULL register) if not defined
+ */
+bool osc_cpc_flexible_adr_space_confirmed;
+EXPORT_SYMBOL_GPL(osc_cpc_flexible_adr_space_confirmed);
+
 /*
  * ACPI 6.4 Operating System Capabilities for USB.
  */
@@ -321,6 +335,8 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 	}
 #endif
 
+	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_CPC_FLEXIBLE_ADR_SPACE;
+
 	if (IS_ENABLED(CONFIG_SCHED_MC_PRIO))
 		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_CPC_DIVERSE_HIGH_SUPPORT;
 
@@ -366,6 +382,8 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
 		osc_sb_native_usb4_support_confirmed =
 			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
+		osc_cpc_flexible_adr_space_confirmed =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_CPC_FLEXIBLE_ADR_SPACE;
 	}
 
 	kfree(context.ret.pointer);
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 34576ab0e2e1..840223c12540 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -746,6 +746,11 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 				if (gas_t->address) {
 					void __iomem *addr;
 
+					if (!osc_cpc_flexible_adr_space_confirmed) {
+						pr_debug("Flexible address space capability not supported\n");
+						goto out_free;
+					}
+
 					addr = ioremap(gas_t->address, gas_t->bit_width/8);
 					if (!addr)
 						goto out_free;
@@ -768,6 +773,10 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 						 gas_t->address);
 					goto out_free;
 				}
+				if (!osc_cpc_flexible_adr_space_confirmed) {
+					pr_debug("Flexible address space capability not supported\n");
+					goto out_free;
+				}
 			} else {
 				if (gas_t->space_id != ACPI_ADR_SPACE_FIXED_HARDWARE || !cpc_ffh_supported()) {
 					/* Support only PCC, SystemMemory, SystemIO, and FFH type regs. */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d7136d13aa44..03465db16b68 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -574,6 +574,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_OSLPI_SUPPORT			0x00000100
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
 #define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
+#define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
 #define OSC_SB_NATIVE_USB4_SUPPORT		0x00040000
 #define OSC_SB_PRM_SUPPORT			0x00200000
 
@@ -581,6 +582,7 @@ extern bool osc_sb_apei_support_acked;
 extern bool osc_pc_lpi_support_confirmed;
 extern bool osc_sb_native_usb4_support_confirmed;
 extern bool osc_sb_cppc_not_supported;
+extern bool osc_cpc_flexible_adr_space_confirmed;
 
 /* USB4 Capabilities */
 #define OSC_USB_USB3_TUNNELING			0x00000001
-- 
2.35.1



