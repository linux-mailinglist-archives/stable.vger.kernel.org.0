Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395031D3D35
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgENTMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgENSvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:51:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C5A20767;
        Thu, 14 May 2020 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482314;
        bh=gdd5JmHs0veB59rm39sCYztS+yPmh9hn9aPXEvVy/xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYkJC83RjsFthUKAIiPttdaAftrCVxsTairgXbHny3EDf1aEwG25uTqwSiwGuvv8b
         SX+t9qWMbhSoKDf6dN83mN5fOO+KVM3e0EXcn9FVUirzPSHD9WZ4mviy4fgdrtf0Qy
         zgpnyCiTExvowinbiNE2uOmReZTll88Q85eHtkKo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Pierret=20=28fepitre=29?= 
        <frederic.pierret@qubes-os.org>, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        kernel-hardening@lists.openwall.com
Subject: [PATCH AUTOSEL 5.6 04/62] gcc-common.h: Update for GCC 10
Date:   Thu, 14 May 2020 14:50:49 -0400
Message-Id: <20200514185147.19716-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index f2ee8bd7abc62..1d0b9382e759d 100644
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
index 17f06079a7123..9ad76b7f3f10e 100644
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
2.20.1

