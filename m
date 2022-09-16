Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F135BAA75
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiIPKZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiIPKXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903B4B14E3;
        Fri, 16 Sep 2022 03:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 925A562A33;
        Fri, 16 Sep 2022 10:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88450C433C1;
        Fri, 16 Sep 2022 10:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323248;
        bh=lRrjMYNEhc4hIHbSe8kC+g2BSPOxlDMtXBXG3XUb/uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aH1TM61XoARQouJe1g5ko5xHYv8tZjPtiKp6w3LoboGk0Cy90e2fsjNFm17m0LCXV
         Tr50g2cwKDhZtdr2FnKZ42HAbtrb1iLJsP1kK+iWB6r5vdMrcEmuz0k1+Hqqun+7NJ
         Uce7dR9A7UKv4zYN8zWjLVbtjN+XDEyAQ9cKsgt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        XiaoYan Li <lxy.lixiaoyan@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.19 07/38] ACPI: resource: skip IRQ override on AMD Zen platforms
Date:   Fri, 16 Sep 2022 12:08:41 +0200
Message-Id: <20220916100448.756709912@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
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

From: Chuanhong Guo <gch981213@gmail.com>

commit 9946e39fe8d0a5da9eb947d8e40a7ef204ba016e upstream.

IRQ override isn't needed on modern AMD Zen systems.
There's an active low keyboard IRQ on AMD Ryzen 6000 and it will stay
this way on newer platforms. This IRQ override breaks keyboards for
almost all Ryzen 6000 laptops currently on the market.

Skip this IRQ override for all AMD Zen platforms because this IRQ
override is supposed to be a workaround for buggy ACPI DSDT and we can't
have a long list of all future AMD CPUs/Laptops in the kernel code.
If a device with buggy ACPI DSDT shows up, a separated list containing
just them should be created.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216118
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: XiaoYan Li <lxy.lixiaoyan@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -416,6 +416,16 @@ static bool acpi_dev_irq_override(u32 gs
 {
 	int i;
 
+#ifdef CONFIG_X86
+	/*
+	 * IRQ override isn't needed on modern AMD Zen systems and
+	 * this override breaks active low IRQs on AMD Ryzen 6000 and
+	 * newer systems. Skip it.
+	 */
+	if (boot_cpu_has(X86_FEATURE_ZEN))
+		return false;
+#endif
+
 	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
 		const struct irq_override_cmp *entry = &skip_override_table[i];
 


