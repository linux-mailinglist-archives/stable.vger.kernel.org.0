Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F346B465E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjCJOmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjCJOmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:42:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7742E120EBE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1488E617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269A9C433EF;
        Fri, 10 Mar 2023 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459335;
        bh=D/4oeywm5q55fB7T4McNKMiC7CfEvxEX1f3NZYKC098=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uo6cTUVBXxwt5Eu2deCDuMYxS+LkhEdCrAP06OXzeVMjUa99DlSlZBunr/nouRN+Q
         9Kn0hB7CdlKZzyp+SqqtFgs5PMkWUunzIzOvgYkmMA+Q5uPju78a7K+7U6ZvdOVQKb
         u1SlrJfTin6GfQbqaisxW2lLPA3qmZTCWl2LGbqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 328/357] thermal: intel: BXT_PMIC: select REGMAP instead of depending on it
Date:   Fri, 10 Mar 2023 14:40:17 +0100
Message-Id: <20230310133749.124958777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1467fb960349dfa5e300658f1a409dde2cfb0c51 ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: b474303ffd57 ("thermal: add Intel BXT WhiskeyCove PMIC thermal driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/Kconfig b/drivers/thermal/intel/Kconfig
index 8025b21f43fa5..b5427579fae59 100644
--- a/drivers/thermal/intel/Kconfig
+++ b/drivers/thermal/intel/Kconfig
@@ -60,7 +60,8 @@ endmenu
 
 config INTEL_BXT_PMIC_THERMAL
 	tristate "Intel Broxton PMIC thermal driver"
-	depends on X86 && INTEL_SOC_PMIC_BXTWC && REGMAP
+	depends on X86 && INTEL_SOC_PMIC_BXTWC
+	select REGMAP
 	help
 	  Select this driver for Intel Broxton PMIC with ADC channels monitoring
 	  system temperature measurements and alerts.
-- 
2.39.2



