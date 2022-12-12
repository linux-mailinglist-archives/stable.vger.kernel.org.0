Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51764A139
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiLLNhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiLLNgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:36:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E466413FA1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:36:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825C061070
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F14C433F0;
        Mon, 12 Dec 2022 13:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852174;
        bh=b/hFPfsTsb7xF7sKUBW4vSuAAiKCvIIsN/UYt13vMs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wh/5v/CSlbv+0QyAoC2iYWcypMaCYsUHfjpKL/o1oQ/bNd4WDpn8umS723ACNiu+J
         XnxSqkDtmCGejFzESoxfnYUgluYIlQQzEuqhRdKbf21t2SXaW8Dg7N4VjtorjjzAFq
         SSjuyj0EjxHCBSmjj+KGo0cZ8xmLsl/7rgcxpLvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 026/157] LoongArch: Combine acpi_boot_table_init() and acpi_boot_init()
Date:   Mon, 12 Dec 2022 14:16:14 +0100
Message-Id: <20221212130935.567177790@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 538eafc6deae12fbac5f277b89aa139b812bca49 ]

Combine acpi_boot_table_init() and acpi_boot_init() since they are very
simple, and we don't need to check the return value of acpi_boot_init().

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/acpi.c  | 31 ++++++++++---------------------
 arch/loongarch/kernel/setup.c |  1 -
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/loongarch/kernel/acpi.c b/arch/loongarch/kernel/acpi.c
index 335398482038..8319cc409009 100644
--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -56,23 +56,6 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 		return ioremap_cache(phys, size);
 }
 
-void __init acpi_boot_table_init(void)
-{
-	/*
-	 * If acpi_disabled, bail out
-	 */
-	if (acpi_disabled)
-		return;
-
-	/*
-	 * Initialize the ACPI boot-time table parser.
-	 */
-	if (acpi_table_init()) {
-		disable_acpi();
-		return;
-	}
-}
-
 #ifdef CONFIG_SMP
 static int set_processor_mask(u32 id, u32 flags)
 {
@@ -156,13 +139,21 @@ static void __init acpi_process_madt(void)
 	loongson_sysconf.nr_cpus = num_processors;
 }
 
-int __init acpi_boot_init(void)
+void __init acpi_boot_table_init(void)
 {
 	/*
 	 * If acpi_disabled, bail out
 	 */
 	if (acpi_disabled)
-		return -1;
+		return;
+
+	/*
+	 * Initialize the ACPI boot-time table parser.
+	 */
+	if (acpi_table_init()) {
+		disable_acpi();
+		return;
+	}
 
 	loongson_sysconf.boot_cpu_id = read_csr_cpuid();
 
@@ -173,8 +164,6 @@ int __init acpi_boot_init(void)
 
 	/* Do not enable ACPI SPCR console by default */
 	acpi_parse_spcr(earlycon_acpi_spcr_enable, false);
-
-	return 0;
 }
 
 #ifdef CONFIG_ACPI_NUMA
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 8f5c2f9a1a83..574647e3483d 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -203,7 +203,6 @@ void __init platform_init(void)
 #ifdef CONFIG_ACPI
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
-	acpi_boot_init();
 #endif
 
 #ifdef CONFIG_NUMA
-- 
2.35.1



