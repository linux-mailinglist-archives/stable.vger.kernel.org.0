Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616E5657C9C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiL1PeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiL1PeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:34:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CA315FF3;
        Wed, 28 Dec 2022 07:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2D561560;
        Wed, 28 Dec 2022 15:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AD7C433F0;
        Wed, 28 Dec 2022 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241658;
        bh=l6SZ1o3XablMRreE/05h9qlGf3szz8R5it9zAPOMn0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIN4TO73VrpYIw+BXmoBrcco1HQ4txnkCnPoDBf6uobkmC4ZA/UJdFwn9h7da42Ca
         M9DkKvx4l/22GY4eabQcC1y9MNx5x5nL9tby5Fv2x139xNQXX0oHz70t9OLnSRl28R
         zT2bwzcE81f5Ng4hE0NWyd8jLxGe9HA9Ruhxx+lY=
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
Subject: [PATCH 5.15 508/731] fbdev: geode: dont build on UML
Date:   Wed, 28 Dec 2022 15:40:15 +0100
Message-Id: <20221228144311.271388741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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



