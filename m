Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7743576F
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhJUA0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232112AbhJUAZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F4C0613A2;
        Thu, 21 Oct 2021 00:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775788;
        bh=pNZwSpSFEOCU7NUQbTWtrABmKlokw4WqU2KF4TizP0M=;
        h=From:To:Cc:Subject:Date:From;
        b=T6aD2R0XRkBx6qQZ2spbuuPmpGrdv5RlO2Z4cfFpD8SI9WFMrqHxB8joQXlNq44kh
         +TeJ7W+9KnVpG6Yx9kFqHwz3+AYrxpfpnx90vjM+HRoCsN6d6Mfx8zEVxynJOfVmRe
         CmEs03ZTVbkTZhFaFsNJ1v0kWyn5qOmDdxx5unN+F5eAD/lwm6vXngcKZpMnBYRuvB
         tRxAa0jioCB6CIe5WCWe5UmoWjk5LqbYfEatn0Qmqrig/8F37xGTStW/+cDNtWt3b7
         M4kErU3XiLPrlE19bYULXVR8G1yJ3OKrTJ5DCNd6e4hbwKvk5YZNgjHY+XSVmexduc
         nKCfYGEaAldGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Kees Cook <keescook@chromium.org>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-hardening@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/10] gcc-plugins/structleak: add makefile var for disabling structleak
Date:   Wed, 20 Oct 2021 20:22:56 -0400
Message-Id: <20211021002305.1129633-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 554afc3b9797511e3245864e32aebeb6abbab1e3 ]

KUnit and structleak don't play nice, so add a makefile variable for
enabling structleak when it complains.

Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.gcc-plugins | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 0a482f341576..93ca13e4f8f9 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -17,6 +17,10 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	\
 		+= -fplugin-arg-structleak_plugin-verbose
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)	\
 		+= -fplugin-arg-structleak_plugin-byref-all
+ifdef CONFIG_GCC_PLUGIN_STRUCTLEAK
+    DISABLE_STRUCTLEAK_PLUGIN += -fplugin-arg-structleak_plugin-disable
+endif
+export DISABLE_STRUCTLEAK_PLUGIN
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)		\
 		+= -DSTRUCTLEAK_PLUGIN
 
-- 
2.33.0

