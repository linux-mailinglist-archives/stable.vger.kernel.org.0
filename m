Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB5B658149
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiL1Q1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiL1Q0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:26:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242831C907;
        Wed, 28 Dec 2022 08:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76B8F61576;
        Wed, 28 Dec 2022 16:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A570C433D2;
        Wed, 28 Dec 2022 16:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244568;
        bh=l6SZ1o3XablMRreE/05h9qlGf3szz8R5it9zAPOMn0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXAUdFOM2Nh6pIocMHZ1Ur7MzWMg28W9WuIAgeToNieGRT65sReAmjT273Mg0vjT+
         lTjjwiZZNPD2Bw626gAqETbtodeo5stHCce+YZsJhxi60fMD29d5NNqv9z783nydpf
         gti/00Md91d/uRGOipe47sFN2jD+0u16b5bgHRos=
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
Subject: [PATCH 6.0 0734/1073] fbdev: geode: dont build on UML
Date:   Wed, 28 Dec 2022 15:38:42 +0100
Message-Id: <20221228144347.960024744@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



