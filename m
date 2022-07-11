Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5686556FBC7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiGKJfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiGKJdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FC87A51E;
        Mon, 11 Jul 2022 02:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32029B80DB7;
        Mon, 11 Jul 2022 09:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DA2C34115;
        Mon, 11 Jul 2022 09:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531069;
        bh=ystBTxczR/PAzzJhVMRn+JJ0S2FAWr2yL8B30ZNTPOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMIyL6C4Tylj9iSVIczefyp4uZj9b82nM/hViBII/tHxGuUbPhmw5IhhSZ554p2cT
         Np/cd6XzgWk/g1uQZBv9gWAJhKN4NkdXkuAdcm5NKoqtqZGB8R930WzaXOs2YTbRau
         lWJz0/uiT0esWiL3tYT//ea+xULNwGIFCnuI3FSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Gondois <pierre.gondois@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 086/112] ACPI: bus: Set CPPC _OSC bits for all and when CPPC_LIB is supported
Date:   Mon, 11 Jul 2022 11:07:26 +0200
Message-Id: <20220711090552.012032465@linuxfoundation.org>
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

[ Upstream commit 72f2ecb7ece7c1d89758d4929d98e95d95fe7199 ]

The _OSC method allows the OS and firmware to communicate about
supported features/capabitlities. It also allows the OS to take
control of some features.

In ACPI 6.4, s6.2.11.2 Platform-Wide OSPM Capabilities, the CPPC
(resp. v2) bit should be set by the OS if it 'supports controlling
processor performance via the interfaces described in the _CPC
object'.

The OS supports CPPC and parses the _CPC object only if
CONFIG_ACPI_CPPC_LIB is set. Replace the x86 specific
boot_cpu_has(X86_FEATURE_HWP) dynamic check with an arch
generic CONFIG_ACPI_CPPC_LIB build-time check.

Note:
CONFIG_X86_INTEL_PSTATE selects CONFIG_ACPI_CPPC_LIB.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9eca43d1d941..1fc24f4fbcb4 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -329,10 +329,11 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 #endif
 #ifdef CONFIG_X86
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_GENERIC_INITIATOR_SUPPORT;
-	if (boot_cpu_has(X86_FEATURE_HWP)) {
-		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_CPC_SUPPORT;
-		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_CPCV2_SUPPORT;
-	}
+#endif
+
+#ifdef CONFIG_ACPI_CPPC_LIB
+	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_CPC_SUPPORT;
+	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_CPCV2_SUPPORT;
 #endif
 
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_CPC_FLEXIBLE_ADR_SPACE;
@@ -357,10 +358,9 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 		return;
 	}
 
-#ifdef CONFIG_X86
-	if (boot_cpu_has(X86_FEATURE_HWP))
-		osc_sb_cppc_not_supported = !(capbuf_ret[OSC_SUPPORT_DWORD] &
-				(OSC_SB_CPC_SUPPORT | OSC_SB_CPCV2_SUPPORT));
+#ifdef CONFIG_ACPI_CPPC_LIB
+	osc_sb_cppc_not_supported = !(capbuf_ret[OSC_SUPPORT_DWORD] &
+			(OSC_SB_CPC_SUPPORT | OSC_SB_CPCV2_SUPPORT));
 #endif
 
 	/*
-- 
2.35.1



