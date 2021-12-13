Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A73D47288A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbhLMKOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239074AbhLMJ4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59253C08EAFC;
        Mon, 13 Dec 2021 01:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23635B80E23;
        Mon, 13 Dec 2021 09:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB00C00446;
        Mon, 13 Dec 2021 09:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388792;
        bh=H+40QzbCWtP48XDKAQlueVlL9K0fuhlRuf+zkYxunDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVYQC8zfBmC1kgGK6pwhzG2quQzuh5f8CRMwkd9Yb0zXc1XByocvX8pQbjNyBWXSJ
         7dQJpIVvoVczmIB8E0iTfR8K95gPfhtK6t9LuEDB7xmbLX8JZIIfuekLtF1+f9kNto
         L7LF7TMAlHel8HLTcdEmJJtQF3B3BBg7bNIXcR8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: [PATCH 5.10 003/132] gcc-plugins: fix gcc 11 indigestion with plugins...
Date:   Mon, 13 Dec 2021 10:29:04 +0100
Message-Id: <20211213092939.187227783@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valdis Kletnieks <valdis.kletnieks@vt.edu>

commit 67a5a68013056cbcf0a647e36cb6f4622fb6a470 upstream.

Fedora Rawhide has started including gcc 11,and the g++ compiler
throws a wobbly when it hits scripts/gcc-plugins:

  HOSTCXX scripts/gcc-plugins/latent_entropy_plugin.so
In file included from /usr/include/c++/11/type_traits:35,
                 from /usr/lib/gcc/x86_64-redhat-linux/11/plugin/include/system.h:244,
                 from /usr/lib/gcc/x86_64-redhat-linux/11/plugin/include/gcc-plugin.h:28,
                 from scripts/gcc-plugins/gcc-common.h:7,
                 from scripts/gcc-plugins/latent_entropy_plugin.c:78:
/usr/include/c++/11/bits/c++0x_warning.h:32:2: error: #error This file requires compiler and library support for the ISO
 C++ 2011 standard. This support must be enabled with the -std=c++11 or -std=gnu++11 compiler options.
   32 | #error This file requires compiler and library support \

In fact, it works just fine with c++11, which has been in gcc since 4.8,
and we now require 4.9 as a minimum.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/82487.1609006918@turing-police
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -22,9 +22,9 @@ always-y += $(GCC_PLUGIN)
 GCC_PLUGINS_DIR = $(shell $(CC) -print-file-name=plugin)
 
 plugin_cxxflags	= -Wp,-MMD,$(depfile) $(KBUILD_HOSTCXXFLAGS) -fPIC \
-		   -I $(GCC_PLUGINS_DIR)/include -I $(obj) -std=gnu++98 \
+		   -I $(GCC_PLUGINS_DIR)/include -I $(obj) -std=gnu++11 \
 		   -fno-rtti -fno-exceptions -fasynchronous-unwind-tables \
-		   -ggdb -Wno-narrowing -Wno-unused-variable -Wno-c++11-compat \
+		   -ggdb -Wno-narrowing -Wno-unused-variable \
 		   -Wno-format-diag
 
 plugin_ldflags	= -shared


