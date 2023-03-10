Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A586B4584
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjCJOed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbjCJOeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:34:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F9876144;
        Fri, 10 Mar 2023 06:34:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D194C61771;
        Fri, 10 Mar 2023 14:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95C1C4339C;
        Fri, 10 Mar 2023 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458850;
        bh=p3Ejt/L/+lps40p14tFbIqn6GnlgrRDC0h1j8Oxdbr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEsxh2QMDw0KadwiwMs4gvqNcLsBHeHLek7bPjUdKZAJ1qq05R/hnKDhH1jsK4WTC
         kvlbnnQLDchwJFbalWRwoLpYEb4qAcYGExpHpyKT1B5HDU1tolmrYus+SdbLgY43Dj
         /AYgrXVPGYz+WZc7Ahm/Pkh5nFBjx/9XhFfXPfVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Dengcheng Zhu <dzhu@wavecomp.com>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/357] MIPS: SMP-CPS: fix build error when HOTPLUG_CPU not set
Date:   Fri, 10 Mar 2023 14:37:34 +0100
Message-Id: <20230310133742.001276488@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6f02e39fa40f16c24e7a5c599a854c0d1682788d ]

When MIPS_CPS=y, MIPS_CPS_PM is not set, HOTPLUG_CPU is not set, and
KEXEC=y, cps_shutdown_this_cpu() attempts to call cps_pm_enter_state(),
which is not built when MIPS_CPS_PM is not set.
Conditionally execute the else branch based on CONFIG_HOTPLUG_CPU
to remove the build error.
This build failure is from a randconfig file.

mips-linux-ld: arch/mips/kernel/smp-cps.o: in function `$L162':
smp-cps.c:(.text.cps_kexec_nonboot_cpu+0x31c): undefined reference to `cps_pm_enter_state'

Fixes: 1447864bee4c ("MIPS: kexec: CPS systems to halt nonboot CPUs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dengcheng Zhu <dzhu@wavecomp.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/smp-cps.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
index dbb3f1fc71ab6..f659adb681bc3 100644
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -423,9 +423,11 @@ static void cps_shutdown_this_cpu(enum cpu_death death)
 			wmb();
 		}
 	} else {
-		pr_debug("Gating power to core %d\n", core);
-		/* Power down the core */
-		cps_pm_enter_state(CPS_PM_POWER_GATED);
+		if (IS_ENABLED(CONFIG_HOTPLUG_CPU)) {
+			pr_debug("Gating power to core %d\n", core);
+			/* Power down the core */
+			cps_pm_enter_state(CPS_PM_POWER_GATED);
+		}
 	}
 }
 
-- 
2.39.2



