Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563F25C0263
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiIUPwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIUPvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:51:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DE59E898;
        Wed, 21 Sep 2022 08:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A0363126;
        Wed, 21 Sep 2022 15:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB55C433D6;
        Wed, 21 Sep 2022 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775341;
        bh=0yPTIpTxxwGKFlOMHQuBjjuY336cjtNmXXPOR4obSlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDso9Ab0f+8G0qQfHeS9PdwaMlfOYVHs4q0PbOg1FtTU2BWf1dp2GQkQdJN2NnXA2
         EwGtcmzA11vnMMLfDVlUhukbYwwCnav6wTQ+EduYE3IVmH8NBqoe+p1lSmKPzAGYqI
         U4iwhq1GFPHsuqUT/Wef/AIybxcxW9DwIGBNDYfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 20/45] parisc: Allow CONFIG_64BIT with ARCH=parisc
Date:   Wed, 21 Sep 2022 17:46:10 +0200
Message-Id: <20220921153647.540557842@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 805ce8614958c925877ba6b6dc26cdf9f8800474 upstream.

The previous patch triggered a build failure for the debian kernel,
which has CONFIG_64BIT enabled, uses the CROSS_COMPILER environment
variable and uses ARCH=parisc to configure the kernel for 64-bit
support.

This patch weakens the previous patch while keeping the recommended way
to configure the kernel with:
    ARCH=parisc     -> build 32-bit kernel
    ARCH=parisc64   -> build 64-bit kernel
while adding the possibility for debian to configure a 64-bit kernel
even if ARCH=parisc is set (PA8X00 CPU has to be selected and
CONFIG_64BIT needs to be enabled).

The downside of this patch is, that we now have a small window open
again where people may get it wrong: if they enable CONFIG_64BIT and try
to compile with a 32-bit compiler.

Fixes: 3dcfb729b5f4 ("parisc: Make CONFIG_64BIT available for ARCH=parisc64 only")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -220,8 +220,18 @@ config MLONGCALLS
 	  Enabling this option will probably slow down your kernel.
 
 config 64BIT
-	def_bool "$(ARCH)" = "parisc64"
+	def_bool y if "$(ARCH)" = "parisc64"
+	bool "64-bit kernel" if "$(ARCH)" = "parisc"
 	depends on PA8X00
+	help
+	  Enable this if you want to support 64bit kernel on PA-RISC platform.
+
+	  At the moment, only people willing to use more than 2GB of RAM,
+	  or having a 64bit-only capable PA-RISC machine should say Y here.
+
+	  Since there is no 64bit userland on PA-RISC, there is no point to
+	  enable this option otherwise. The 64bit kernel is significantly bigger
+	  and slower than the 32bit one.
 
 choice
 	prompt "Kernel page size"


