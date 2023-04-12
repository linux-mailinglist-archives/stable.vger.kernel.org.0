Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313276DEE44
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjDLIlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjDLIkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBCC6591
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7AF963030
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD13C433D2;
        Wed, 12 Apr 2023 08:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288734;
        bh=64g9qhaXqLFVJLT4MseXGb2oTZhdPdjB/lowPRGvwME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KujdfvmpMDNPlPR65ebMCBeuZBAWka+VZDNyBcztRDa8W65/roKms5cbz4hYRub6u
         AsM9ozq974uc5XzTE2pp8F46Hqbm1XczTT/d3yuzxOngfeCyem9Xc0LUljnBr01TOp
         TJ3dpqjU/vAhLaxcTJW2KwaeYhVNR/BQ68ZJfHnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/93] kbuild: refactor single builds of *.ko
Date:   Wed, 12 Apr 2023 10:33:51 +0200
Message-Id: <20230412082825.263712578@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f110e5a250e3c5db417e094b3dd86f1c135291ca ]

Remove the potentially invalid modules.order instead of using
the temporary file.

Also, KBUILD_MODULES is don't care for single builds. No need to
cancel it.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: ed1f4ccfe947 ("clk: imx: imx8mp: add shared clk gate for usb suspend clk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 6459e91369fdb..4de8cd300451d 100644
--- a/Makefile
+++ b/Makefile
@@ -1850,6 +1850,8 @@ modules modules_install:
 	@echo >&2 '***'
 	@exit 1
 
+KBUILD_MODULES :=
+
 endif # CONFIG_MODULES
 
 # Single targets
@@ -1875,18 +1877,12 @@ $(single-ko): single_modpost
 $(single-no-ko): descend
 	@:
 
-ifeq ($(KBUILD_EXTMOD),)
-# For the single build of in-tree modules, use a temporary file to avoid
-# the situation of modules_install installing an invalid modules.order.
-MODORDER := .modules.tmp
-endif
-
+# Remove MODORDER when done because it is not the real one.
 PHONY += single_modpost
 single_modpost: $(single-no-ko) modules_prepare
 	$(Q){ $(foreach m, $(single-ko), echo $(extmod_prefix)$m;) } > $(MODORDER)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
-
-KBUILD_MODULES := 1
+	$(Q)rm -f $(MODORDER)
 
 export KBUILD_SINGLE_TARGETS := $(addprefix $(extmod_prefix), $(single-no-ko))
 
@@ -1896,10 +1892,6 @@ build-dirs := $(foreach d, $(build-dirs), \
 
 endif
 
-ifndef CONFIG_MODULES
-KBUILD_MODULES :=
-endif
-
 # Handle descending into subdirectories listed in $(build-dirs)
 # Preset locale variables to speed up the build process. Limit locale
 # tweaks to this spot to avoid wrong language settings when running
-- 
2.39.2



