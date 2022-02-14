Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A944B48B8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiBNJ5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:57:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345161AbiBNJ4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:56:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F546A004;
        Mon, 14 Feb 2022 01:45:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82A5A6120C;
        Mon, 14 Feb 2022 09:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93848C340E9;
        Mon, 14 Feb 2022 09:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831915;
        bh=hvRPptMwFiumkTaQ7KokZRxqioOQOq7qvIXpbCaWi2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJHP+mKefN4lVevohSqp4hN0/BL3w4re4OaoWKRu7+U1pGxYgK1SmycXQowezQQPL
         xY01V3GTBYBGDOaJEYIueHNJsOJWNUPp8MmDAH09q3iNLzrydhGUMMt/ijOBsDfF41
         SapsNStYktRZwz5sZPTGGLrSLy6DFf03js3jzA2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Subject: [PATCH 5.15 020/172] thermal: int340x: Limit Kconfig to 64-bit
Date:   Mon, 14 Feb 2022 10:24:38 +0100
Message-Id: <20220214092507.089918741@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 994a04a20b03128838ec0250a0e266aab24d23f1 upstream.

32-bit processors cannot generally access 64-bit MMIO registers
atomically, and it is unknown in which order the two halves of
this registers would need to be read:

drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c: In function 'send_mbox_cmd':
drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:79:37: error: implicit declaration of function 'readq'; did you mean 'readl'? [-Werror=implicit-function-declaration]
   79 |                         *cmd_resp = readq((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
      |                                     ^~~~~
      |                                     readl

The driver already does not build for anything other than x86,
so limit it further to x86-64.

Fixes: aeb58c860dc5 ("thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/Kconfig
+++ b/drivers/thermal/intel/int340x_thermal/Kconfig
@@ -5,12 +5,12 @@
 
 config INT340X_THERMAL
 	tristate "ACPI INT340X thermal drivers"
-	depends on X86 && ACPI && PCI
+	depends on X86_64 && ACPI && PCI
 	select THERMAL_GOV_USER_SPACE
 	select ACPI_THERMAL_REL
 	select ACPI_FAN
 	select INTEL_SOC_DTS_IOSF_CORE
-	select PROC_THERMAL_MMIO_RAPL if X86_64 && POWERCAP
+	select PROC_THERMAL_MMIO_RAPL if POWERCAP
 	help
 	  Newer laptops and tablets that use ACPI may have thermal sensors and
 	  other devices with thermal control capabilities outside the core


