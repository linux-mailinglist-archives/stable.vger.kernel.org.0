Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3CA6581E9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiL1QcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiL1Qb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435471D0D2;
        Wed, 28 Dec 2022 08:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB61AB8171E;
        Wed, 28 Dec 2022 16:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36271C433D2;
        Wed, 28 Dec 2022 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244903;
        bh=l6SZ1o3XablMRreE/05h9qlGf3szz8R5it9zAPOMn0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ron5PI7u6ezKAXDau7enNqehjB6k7hg8WUY37MCGZDC+mZEXebm2BUy84FCDqz1uu
         2UvyTAP6qlbU9mL3t3IFxruwFvZTRTMTRGIYU3VrFSYAoyjLAe7QiIjLpSE80qt3YS
         mQU8BdIp06nSLQ8NV9EiqhIsTgljHyeTmS0CNtxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Weinberger <richard@nod.at>,
        linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>,
        Helge Deller <deller@gmx.de>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0759/1146] fbdev: geode: dont build on UML
Date:   Wed, 28 Dec 2022 15:38:18 +0100
Message-Id: <20221228144350.759019233@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 71c53e19226b0166ba387d3c590d0509f541a0a1 ]

The geode fbdev driver uses struct cpuinfo fields that are not present
on ARCH=um, so don't allow this driver to be built on UML.

Prevents these build errors:

In file included from ../arch/x86/include/asm/olpc.h:7:0,
                 from ../drivers/mfd/cs5535-mfd.c:17:
../arch/x86/include/asm/geode.h: In function ‘is_geode_gx’:
../arch/x86/include/asm/geode.h:16:24: error: ‘struct cpuinfo_um’ has no member named ‘x86_vendor’
  return ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC) &&
../arch/x86/include/asm/geode.h:16:39: error: ‘X86_VENDOR_NSC’ undeclared (first use in this function); did you mean ‘X86_VENDOR_ANY’?
  return ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC) &&
../arch/x86/include/asm/geode.h:17:17: error: ‘struct cpuinfo_um’ has no member named ‘x86’
   (boot_cpu_data.x86 == 5) &&
../arch/x86/include/asm/geode.h:18:17: error: ‘struct cpuinfo_um’ has no member named ‘x86_model’
   (boot_cpu_data.x86_model == 5));
../arch/x86/include/asm/geode.h: In function ‘is_geode_lx’:
../arch/x86/include/asm/geode.h:23:24: error: ‘struct cpuinfo_um’ has no member named ‘x86_vendor’
  return ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
../arch/x86/include/asm/geode.h:23:39: error: ‘X86_VENDOR_AMD’ undeclared (first use in this function); did you mean ‘X86_VENDOR_ANY’?
  return ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
../arch/x86/include/asm/geode.h:24:17: error: ‘struct cpuinfo_um’ has no member named ‘x86’
   (boot_cpu_data.x86 == 5) &&
../arch/x86/include/asm/geode.h:25:17: error: ‘struct cpuinfo_um’ has no member named ‘x86_model’
   (boot_cpu_data.x86_model == 10));

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-um@lists.infradead.org
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: Andres Salomon <dilinger@queued.net>
Cc: linux-geode@lists.infradead.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/geode/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/geode/Kconfig b/drivers/video/fbdev/geode/Kconfig
index ac9c860592aa..85bc14b6faf6 100644
--- a/drivers/video/fbdev/geode/Kconfig
+++ b/drivers/video/fbdev/geode/Kconfig
@@ -5,6 +5,7 @@
 config FB_GEODE
 	bool "AMD Geode family framebuffer support"
 	depends on FB && PCI && (X86_32 || (X86 && COMPILE_TEST))
+	depends on !UML
 	help
 	  Say 'Y' here to allow you to select framebuffer drivers for
 	  the AMD Geode family of processors.
-- 
2.35.1



