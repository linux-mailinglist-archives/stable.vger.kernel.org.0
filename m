Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFFE5A4875
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiH2LKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiH2LJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:09:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7ABFF38;
        Mon, 29 Aug 2022 04:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 349D3611B8;
        Mon, 29 Aug 2022 11:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437F5C433C1;
        Mon, 29 Aug 2022 11:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771211;
        bh=NYCwG859uJIhAtdvy/+qVTFDXKYZDN79rU5MqeTeFxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLKZVxQQXLf1SSDYBnDpD2gX4Bbj6e75gFi5GvJQ5TaeyzwRsnhLRON3d1MVpuc/O
         a2k1gBHGPaHTJWbqBNVP0px00cBTKmBYhHSEY5ydRKtJfNmSmGmEzT779k8cA14e/8
         s5Y6FR1vEBazZpoGe+FJA6w3SzXhvd34sf8hC3nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Helge Deller <deller@gmx.de>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.19 005/158] parisc: Make CONFIG_64BIT available for ARCH=parisc64 only
Date:   Mon, 29 Aug 2022 12:57:35 +0200
Message-Id: <20220829105809.054969488@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 3dcfb729b5f4a0c9b50742865cd5e6c4dbcc80dc upstream.

With this patch the ARCH= parameter decides if the
CONFIG_64BIT option will be set or not. This means, the
ARCH= parameter will give:

	ARCH=parisc	-> 32-bit kernel
	ARCH=parisc64	-> 64-bit kernel

This simplifies the usage of the other config options like
randconfig, allmodconfig and allyesconfig a lot and produces
the output which is expected for parisc64 (64-bit) vs. parisc (32-bit).

Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -147,10 +147,10 @@ menu "Processor type and features"
 
 choice
 	prompt "Processor type"
-	default PA7000
+	default PA7000 if "$(ARCH)" = "parisc"
 
 config PA7000
-	bool "PA7000/PA7100"
+	bool "PA7000/PA7100" if "$(ARCH)" = "parisc"
 	help
 	  This is the processor type of your CPU.  This information is
 	  used for optimizing purposes.  In order to compile a kernel
@@ -161,21 +161,21 @@ config PA7000
 	  which is required on some machines.
 
 config PA7100LC
-	bool "PA7100LC"
+	bool "PA7100LC" if "$(ARCH)" = "parisc"
 	help
 	  Select this option for the PCX-L processor, as used in the
 	  712, 715/64, 715/80, 715/100, 715/100XC, 725/100, 743, 748,
 	  D200, D210, D300, D310 and E-class
 
 config PA7200
-	bool "PA7200"
+	bool "PA7200" if "$(ARCH)" = "parisc"
 	help
 	  Select this option for the PCX-T' processor, as used in the
 	  C100, C110, J100, J110, J210XC, D250, D260, D350, D360,
 	  K100, K200, K210, K220, K400, K410 and K420
 
 config PA7300LC
-	bool "PA7300LC"
+	bool "PA7300LC" if "$(ARCH)" = "parisc"
 	help
 	  Select this option for the PCX-L2 processor, as used in the
 	  744, A180, B132L, B160L, B180L, C132L, C160L, C180L,
@@ -225,17 +225,8 @@ config MLONGCALLS
 	  Enabling this option will probably slow down your kernel.
 
 config 64BIT
-	bool "64-bit kernel"
+	def_bool "$(ARCH)" = "parisc64"
 	depends on PA8X00
-	help
-	  Enable this if you want to support 64bit kernel on PA-RISC platform.
-
-	  At the moment, only people willing to use more than 2GB of RAM,
-	  or having a 64bit-only capable PA-RISC machine should say Y here.
-
-	  Since there is no 64bit userland on PA-RISC, there is no point to
-	  enable this option otherwise. The 64bit kernel is significantly bigger
-	  and slower than the 32bit one.
 
 choice
 	prompt "Kernel page size"


