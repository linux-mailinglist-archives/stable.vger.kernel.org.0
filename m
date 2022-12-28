Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C16584C7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiL1RC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbiL1RBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:01:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B628A1A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B4F613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0814C433D2;
        Wed, 28 Dec 2022 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246574;
        bh=P9OsdIVMBEreN4JcSrTvRIENSHE29Zj6l6lLqaOumn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/jU4Vmd68JR9jr7AkqZXLwUDQK11788DcFbxxY3Sa0gvka2GXinj9Q7ahQOGoqJM
         eGyatCMj6DQ75E+XtmTewXIFRjDjrsxo5mmTSqCo7jsJk7uNOcJ+xufrtuSBvdEVwC
         omSWacBmtTTX7unNrr+WPspuvuz4l4KJhmHnbrto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1086/1146] MIPS: ralink: mt7621: avoid to init common ralink reset controller
Date:   Wed, 28 Dec 2022 15:43:45 +0100
Message-Id: <20221228144359.695076687@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 76ce51798cb16738a4a28a6662e7344aaf7ef769 ]

Commit 38a8553b0a22 ("clk: ralink: make system controller node a reset provider")
make system controller a reset provider for mt7621 ralink SoCs. Ralink init code
also tries to start previous common reset controller which at the end tries to
find device tree node 'ralink,rt2880-reset'. mt7621 device tree file is not
using at all this node anymore. Hence avoid to init this common reset controller
for mt7621 ralink SoCs to avoid 'Failed to find reset controller node' boot
error trace error.

Fixes: 64b2d6ffff86 ("staging: mt7621-dts: align resets with binding documentation")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/of.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index ea8072acf8d9..01c132bc33d5 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -21,6 +21,7 @@
 #include <asm/bootinfo.h>
 #include <asm/addrspace.h>
 #include <asm/prom.h>
+#include <asm/mach-ralink/ralink_regs.h>
 
 #include "common.h"
 
@@ -81,7 +82,8 @@ static int __init plat_of_setup(void)
 	__dt_register_buses(soc_info.compatible, "palmbus");
 
 	/* make sure that the reset controller is setup early */
-	ralink_rst_init();
+	if (ralink_soc != MT762X_SOC_MT7621AT)
+		ralink_rst_init();
 
 	return 0;
 }
-- 
2.35.1



