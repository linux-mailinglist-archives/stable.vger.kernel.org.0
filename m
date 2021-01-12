Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A2D2F3116
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbhALNPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:15:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403938AbhALM5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EBED2333C;
        Tue, 12 Jan 2021 12:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456194;
        bh=7PNVpt0bs4C3ppvChJsT06lyVnFeUnRA9JLauqQi+oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvGFPP+J7vPfWLglSiP1xf+dZ1Hl/EPAFikGZG/nDRgDxjktsYlKpn0IWiD51mlU8
         qgHDBqX6OqG16LlF4yaoLhp/zxax7qQqiLNaFelmiHCBwHjI27YVVPtJmi4M1VZkYX
         kblhQNVW58RWNkcotpDwd8ZmBdUKl2yMsoVxEMmlXl7Y8ZpKzqg32qWPHHBb+UvBh9
         Ei9yOMYAPBVAY1peZ1wk8LwQVWDDk9dOG0jI4VGKToNh7LLAbQUyJHmvAOCtYw6Te8
         pB+8qI/lX6DJuu4JaQkctFjvf69Tt1YgUJj+XIAaDBhQeqP6Rs14GJ1P6Avd/IFHxZ
         oezLgzQAnD/3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 45/51] gcc-plugins: fix gcc 11 indigestion with plugins...
Date:   Tue, 12 Jan 2021 07:55:27 -0500
Message-Id: <20210112125534.70280-45-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valdis Klētnieks <valdis.kletnieks@vt.edu>

[ Upstream commit 67a5a68013056cbcf0a647e36cb6f4622fb6a470 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index d66949bfeba45..b5487cce69e8e 100644
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
-- 
2.27.0

