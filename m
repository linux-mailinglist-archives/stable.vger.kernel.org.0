Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119066A0976
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjBWNGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbjBWNGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:06:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BD155C0C
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:06:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9864D616EB
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2EAC433D2;
        Thu, 23 Feb 2023 13:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157566;
        bh=bMRStiFKZUzQKYrgCEwgaerU4Zt+YsJtE/ShtITSsQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUb2tY4xT5RPmaaxce1iCLorqZEsVl4N3R1nrkBJqwDxZLyThHAM8uBRoifYMvRK+
         xBSgYx+UM/S0zwyf3VQ4tn+Kl6dpISNjMiA++SEVHY0K4QUZD8qZH0miJk2ZD+pn9d
         gFRuM8PNPB+VzlOiKXDrjW0ny08Xj9tE74CTxkpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.2 08/11] platform/x86/amd/pmf: Add depends on CONFIG_POWER_SUPPLY
Date:   Thu, 23 Feb 2023 14:05:02 +0100
Message-Id: <20230223130426.522742465@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.170746546@linuxfoundation.org>
References: <20230223130426.170746546@linuxfoundation.org>
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

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 3004e8d2a0a98bbf4223ae146464fadbff68bf78 upstream.

It is reported that amd_pmf driver is missing "depends on" for
CONFIG_POWER_SUPPLY causing the following build error.

ld: drivers/platform/x86/amd/pmf/core.o: in function `amd_pmf_remove':
core.c:(.text+0x10): undefined reference to `power_supply_unreg_notifier'
ld: drivers/platform/x86/amd/pmf/core.o: in function `amd_pmf_probe':
core.c:(.text+0x38f): undefined reference to `power_supply_reg_notifier'
make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
make: *** [Makefile:1248: vmlinux] Error 2

Add this to the Kconfig file.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217028
Fixes: c5258d39fc4c ("platform/x86/amd/pmf: Add helper routine to update SPS thermals")
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20230213121457.1764463-1-Shyam-sundar.S-k@amd.com
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmf/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/amd/pmf/Kconfig
+++ b/drivers/platform/x86/amd/pmf/Kconfig
@@ -6,6 +6,7 @@
 config AMD_PMF
 	tristate "AMD Platform Management Framework"
 	depends on ACPI && PCI
+	depends on POWER_SUPPLY
 	select ACPI_PLATFORM_PROFILE
 	help
 	  This driver provides support for the AMD Platform Management Framework.


