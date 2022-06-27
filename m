Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E8655D42C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbiF0Ln3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbiF0Lmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1704CDF2D;
        Mon, 27 Jun 2022 04:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7ED860C9B;
        Mon, 27 Jun 2022 11:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF97C3411D;
        Mon, 27 Jun 2022 11:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329811;
        bh=HntDoXniYj/5of/4GddtV0AzCXgaQh2XJZbRGx/gDMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqPdxjyG+KMjKNcqIgBV3vKksI0ue+7yomBgSJCnOjJgwtFlu8EwnEWvSybFC39vZ
         SFW9bmmRZKTVmeg6cnGLk+KjvDFkZf9IrUB2wnjgBAMP/39L25ldW+KI/tzlg1xl+t
         ZAkOGg6bt1iSqAvyxL8buWy0ft9nldbWAxDjYiSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/135] usb: typec: wcove: Drop wrong dependency to INTEL_SOC_PMIC
Date:   Mon, 27 Jun 2022 13:21:30 +0200
Message-Id: <20220627111940.570147067@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9ef165406308515dcf2e3f6e97b39a1c56d86db5 ]

Intel SoC PMIC is a generic name for all PMICs that are used
on Intel platforms. In particular, INTEL_SOC_PMIC kernel configuration
option refers to Crystal Cove PMIC, which has never been a part
of any Intel Broxton hardware. Drop wrong dependency from Kconfig.

Note, the correct dependency is satisfied via ACPI PMIC OpRegion driver,
which the Type-C depends on.

Fixes: d2061f9cc32d ("usb: typec: add driver for Intel Whiskey Cove PMIC USB Type-C PHY")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220620104316.57592-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/Kconfig b/drivers/usb/typec/tcpm/Kconfig
index 557f392fe24d..073fd2ea5e0b 100644
--- a/drivers/usb/typec/tcpm/Kconfig
+++ b/drivers/usb/typec/tcpm/Kconfig
@@ -56,7 +56,6 @@ config TYPEC_WCOVE
 	tristate "Intel WhiskeyCove PMIC USB Type-C PHY driver"
 	depends on ACPI
 	depends on MFD_INTEL_PMC_BXT
-	depends on INTEL_SOC_PMIC
 	depends on BXT_WC_PMIC_OPREGION
 	help
 	  This driver adds support for USB Type-C on Intel Broxton platforms
-- 
2.35.1



