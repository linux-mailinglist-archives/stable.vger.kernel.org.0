Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69CD43574D
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhJUAZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231863AbhJUAYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF3C60FDA;
        Thu, 21 Oct 2021 00:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775760;
        bh=qEYQFf0VxEija/mw0Byd80LlBxff9kFHIH+fV2S1Zzo=;
        h=From:To:Cc:Subject:Date:From;
        b=IzW+oBztTwdosMTnKkuLxL+hsd3cYuNaNNMTlkqoW3vpWl1kFZpFkJIcdcwJtgdpl
         3mGVehtrc4rRdQwjfDEiNQZ6l7CSSSwF3nQ/a2sL3SwjCUF0iyp0UcVbJ472w6yxPm
         gXmGLTKIJDAr3eSCMi3g3vG48VDW01gC7DBr07W+DAa76qRb4HQDifKYQre2kCx1pP
         wzUsJDoPMNUtiq3b3q7zSGMUPf302V8j10WuVDf2w5zNjNbiLXgQjuhPs/YMlI7sbJ
         yExvcHeQlD86em2wyRH9orgkNJuSYG9hGzRyYrxuvxEawAB547GKQ2mDHEfx+TQhtV
         EebBWpzDbsInw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Kees Cook <keescook@chromium.org>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-hardening@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/11] gcc-plugins/structleak: add makefile var for disabling structleak
Date:   Wed, 20 Oct 2021 20:22:27 -0400
Message-Id: <20211021002238.1129482-1-sashal@kernel.org>
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
index 5f7df50cfe7a..63d21489216b 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -19,6 +19,10 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF)		\
 		+= -fplugin-arg-structleak_plugin-byref
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

