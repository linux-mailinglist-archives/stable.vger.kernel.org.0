Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E74713340D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgAGVBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbgAGVBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83BED21744;
        Tue,  7 Jan 2020 21:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430865;
        bh=YLoaA4tNyNuuKDFt662/r/YVwrSW+OM1l9CULpRehWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGxWRkqh++CBtaz+XaB4RjcNfY3spXxi98ghqpTcCfzjePLEmVZF3EY9ksnQ27pa6
         uGNHVhKrmKM3eFnlOqUAzwJM1IMP5Lv+zeWz3ZeYeNtqjTbiC+hKlzy6rqaix+QN9a
         Vw7Q5GxvOc8OvWbhT1LrzUZ6sUXCtf8KzTXQU4Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 091/191] gcc-plugins: make it possible to disable CONFIG_GCC_PLUGINS again
Date:   Tue,  7 Jan 2020 21:53:31 +0100
Message-Id: <20200107205337.866321051@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit a5b0dc5a46c221725c43bd9b01570239a4cd78b1 upstream.

I noticed that randconfig builds with gcc no longer produce a lot of
ccache hits, unlike with clang, and traced this back to plugins
now being enabled unconditionally if they are supported.

I am now working around this by adding

   export CCACHE_COMPILERCHECK=/usr/bin/size -A %compiler%

to my top-level Makefile. This changes the heuristic that ccache uses
to determine whether the plugins are the same after a 'make clean'.

However, it also seems that being able to just turn off the plugins is
generally useful, at least for build testing it adds noticeable overhead
but does not find a lot of bugs additional bugs, and may be easier for
ccache users than my workaround.

Fixes: 9f671e58159a ("security: Create "kernel hardening" config area")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20191211133951.401933-1-arnd@arndb.de
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/gcc-plugins/Kconfig |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -14,8 +14,8 @@ config HAVE_GCC_PLUGINS
 	  An arch should select this symbol if it supports building with
 	  GCC plugins.
 
-config GCC_PLUGINS
-	bool
+menuconfig GCC_PLUGINS
+	bool "GCC plugins"
 	depends on HAVE_GCC_PLUGINS
 	depends on PLUGIN_HOSTCC != ""
 	default y
@@ -25,8 +25,7 @@ config GCC_PLUGINS
 
 	  See Documentation/core-api/gcc-plugins.rst for details.
 
-menu "GCC plugins"
-	depends on GCC_PLUGINS
+if GCC_PLUGINS
 
 config GCC_PLUGIN_CYC_COMPLEXITY
 	bool "Compute the cyclomatic complexity of a function" if EXPERT
@@ -113,4 +112,4 @@ config GCC_PLUGIN_ARM_SSP_PER_TASK
 	bool
 	depends on GCC_PLUGINS && ARM
 
-endmenu
+endif


