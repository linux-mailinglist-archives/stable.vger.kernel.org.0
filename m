Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB4E6AECE2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjCGR7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCGR6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:58:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF9686B9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E0CF61469
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA63C433EF;
        Tue,  7 Mar 2023 17:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211576;
        bh=T6mTpMVzcnfdsX/jVA0WmAs8XLAYTQOOl3CAuaVSy+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FX3QhjPK9xmq3OWFSHV4dyOsARSEwQuJyK+v71wI3DMhbi6uqUn3D78t8NocnJsar
         f/3nhkk4UeyUt/gkWE4GrhMT9drOE3CcCr4CDv5ANViK6+WVcKd9OUh+3v/NAD7Az5
         Ti6xVk+JlY9sc7JcgIcYYmF2au6ZjGQZjBpAMBOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Osipenko <digetx@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <treding@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.2 0908/1001] cpuidle: add ARCH_SUSPEND_POSSIBLE dependencies
Date:   Tue,  7 Mar 2023 18:01:20 +0100
Message-Id: <20230307170101.434304055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 7787943a3a8ade6594a68db28c166adbb1d3708c upstream.

Some ARMv4 processors don't support suspend, which leads
to a build failure with the tegra and qualcomm cpuidle driver:

WARNING: unmet direct dependencies detected for ARM_CPU_SUSPEND
  Depends on [n]: ARCH_SUSPEND_POSSIBLE [=n]
  Selected by [y]:
  - ARM_TEGRA_CPUIDLE [=y] && CPU_IDLE [=y] && (ARM [=y] || ARM64) && (ARCH_TEGRA [=n] || COMPILE_TEST [=y]) && !ARM64 && MMU [=y]

arch/arm/kernel/sleep.o: in function `__cpu_suspend':
(.text+0x68): undefined reference to `cpu_sa110_suspend_size'
(.text+0x68): undefined reference to `cpu_fa526_suspend_size'

Add an explicit dependency to make randconfig builds avoid
this combination.

Fixes: faae6c9f2e68 ("cpuidle: tegra: Enable compile testing")
Fixes: a871be6b8eee ("cpuidle: Convert Qualcomm SPM driver to a generic CPUidle driver")
Link: https://lore.kernel.org/all/20211013160125.772873-1-arnd@kernel.org/
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/Kconfig.arm |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -102,6 +102,7 @@ config ARM_MVEBU_V7_CPUIDLE
 config ARM_TEGRA_CPUIDLE
 	bool "CPU Idle Driver for NVIDIA Tegra SoCs"
 	depends on (ARCH_TEGRA || COMPILE_TEST) && !ARM64 && MMU
+	depends on ARCH_SUSPEND_POSSIBLE
 	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
 	select ARM_CPU_SUSPEND
 	help
@@ -110,6 +111,7 @@ config ARM_TEGRA_CPUIDLE
 config ARM_QCOM_SPM_CPUIDLE
 	bool "CPU Idle Driver for Qualcomm Subsystem Power Manager (SPM)"
 	depends on (ARCH_QCOM || COMPILE_TEST) && !ARM64 && MMU
+	depends on ARCH_SUSPEND_POSSIBLE
 	select ARM_CPU_SUSPEND
 	select CPU_IDLE_MULTIPLE_DRIVERS
 	select DT_IDLE_STATES


