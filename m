Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35EC1E2D43
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391855AbgEZTMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392009AbgEZTL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:11:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B3920888;
        Tue, 26 May 2020 19:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520315;
        bh=c9bfCRccB/4P5xUTEw8y/UDb8M3T4Sojj4tD8tv3o3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uwo4lS+MwFNg86Ba+dgglo7NGb0PLIPT8PuxaOMG9c1o0nWXzHuNateREdO7HaRTA
         ZxBKmM6eDZzpzFKO6TejWjTlSgBXrDB5jXWRq01+FU+0hVIJVrlAmkbm7Sk/vX5Uik
         Z2b1qF0MuMDZYgJajaMpFrPdUz4gdsUIfyLorw3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Pierret=20 ?= 
        <frederic.pierret@qubes-os.org>, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 024/126] gcc-common.h: Update for GCC 10
Date:   Tue, 26 May 2020 20:52:41 +0200
Message-Id: <20200526183939.732790884@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>

[ Upstream commit c7527373fe28f97d8a196ab562db5589be0d34b9 ]

Remove "params.h" include, which has been dropped in GCC 10.

Remove is_a_helper() macro, which is now defined in gimple.h, as seen
when running './scripts/gcc-plugin.sh g++ g++ gcc':

In file included from <stdin>:1:
./gcc-plugins/gcc-common.h:852:13: error: redefinition of ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const ggoto*]’
  852 | inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ./gcc-plugins/gcc-common.h:125,
                 from <stdin>:1:
/usr/lib/gcc/x86_64-redhat-linux/10/plugin/include/gimple.h:1037:1: note: ‘static bool is_a_helper<T>::test(U*) [with U = const gimple; T = const ggoto*]’ previously declared here
 1037 | is_a_helper <const ggoto *>::test (const gimple *gs)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Add -Wno-format-diag to scripts/gcc-plugins/Makefile to avoid
meaningless warnings from error() formats used by plugins:

scripts/gcc-plugins/structleak_plugin.c: In function ‘int plugin_init(plugin_name_args*, plugin_gcc_version*)’:
scripts/gcc-plugins/structleak_plugin.c:253:12: warning: unquoted sequence of 2 consecutive punctuation characters ‘'-’ in format [-Wformat-diag]
  253 |   error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>
Link: https://lore.kernel.org/r/20200407113259.270172-1-frederic.pierret@qubes-os.org
[kees: include -Wno-format-diag for plugin builds]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/Makefile     | 1 +
 scripts/gcc-plugins/gcc-common.h | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index f2ee8bd7abc6..1d0b9382e759 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -11,6 +11,7 @@ else
   HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti
   HOST_EXTRACXXFLAGS += -fno-exceptions -fasynchronous-unwind-tables -ggdb
   HOST_EXTRACXXFLAGS += -Wno-narrowing -Wno-unused-variable
+  HOST_EXTRACXXFLAGS += -Wno-format-diag
   export HOST_EXTRACXXFLAGS
 endif
 
diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index 17f06079a712..9ad76b7f3f10 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -35,7 +35,9 @@
 #include "ggc.h"
 #include "timevar.h"
 
+#if BUILDING_GCC_VERSION < 10000
 #include "params.h"
+#endif
 
 #if BUILDING_GCC_VERSION <= 4009
 #include "pointer-set.h"
@@ -847,6 +849,7 @@ static inline gimple gimple_build_assign_with_ops(enum tree_code subcode, tree l
 	return gimple_build_assign(lhs, subcode, op1, op2 PASS_MEM_STAT);
 }
 
+#if BUILDING_GCC_VERSION < 10000
 template <>
 template <>
 inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
@@ -860,6 +863,7 @@ inline bool is_a_helper<const greturn *>::test(const_gimple gs)
 {
 	return gs->code == GIMPLE_RETURN;
 }
+#endif
 
 static inline gasm *as_a_gasm(gimple stmt)
 {
-- 
2.25.1



