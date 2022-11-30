Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53D863DF90
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiK3Ssm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiK3SsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D8E9B7B4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62B1AB81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B5AC433D6;
        Wed, 30 Nov 2022 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834099;
        bh=NX8DFexWJh1/E/nR91ZWF5kGhB/3R59QU5Z+wx7iR7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVF6jCsYAFsn6MMVObGyydibX0t6Dl0v0AFlXzCvjTTzKRaHKNenNsMmhNvy2OA+m
         wXrZR7jAnuw6lci7ywoRw3PVJ1PuNps84cj6+3XnIPqXSMPTAF/xjIZ47eXCv9P+Ic
         y+ls1RidVrd1Ofy/BskXg9ZUJPOfqjS9DkFahCSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huang Rui <ray.huang@amd.com>,
        "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
        Wyes Karny <wyes.karny@amd.com>,
        Perry Yuan <Perry.Yuan@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 128/289] cpufreq: amd-pstate: change amd-pstate driver to be built-in type
Date:   Wed, 30 Nov 2022 19:21:53 +0100
Message-Id: <20221130180547.041616390@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Perry Yuan <Perry.Yuan@amd.com>

[ Upstream commit 456ca88d8a5258fc66edc42a10053ac8473de2b1 ]

Currently when the amd-pstate and acpi_cpufreq are both built into
kernel as module driver, amd-pstate will not be loaded by default
in this case.

Change amd-pstate driver as built-in type, it will resolve the loading
sequence problem to allow user to make amd-pstate driver as the default
cpufreq scaling driver.

Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Fixes: ec437d71db77 ("cpufreq: amd-pstate: Introduce a new AMD P-State driver to support future processors")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig.x86  |  2 +-
 drivers/cpufreq/amd-pstate.c | 11 +----------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 55516043b656..8184378f67ef 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -35,7 +35,7 @@ config X86_PCC_CPUFREQ
 	  If in doubt, say N.
 
 config X86_AMD_PSTATE
-	tristate "AMD Processor P-State driver"
+	bool "AMD Processor P-State driver"
 	depends on X86 && ACPI
 	select ACPI_PROCESSOR
 	select ACPI_CPPC_LIB if X86_64
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index d63a28c5f95a..e808d2b3ef57 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -718,16 +718,7 @@ static int __init amd_pstate_init(void)
 
 	return ret;
 }
-
-static void __exit amd_pstate_exit(void)
-{
-	cpufreq_unregister_driver(&amd_pstate_driver);
-
-	amd_pstate_enable(false);
-}
-
-module_init(amd_pstate_init);
-module_exit(amd_pstate_exit);
+device_initcall(amd_pstate_init);
 
 MODULE_AUTHOR("Huang Rui <ray.huang@amd.com>");
 MODULE_DESCRIPTION("AMD Processor P-state Frequency Driver");
-- 
2.35.1



