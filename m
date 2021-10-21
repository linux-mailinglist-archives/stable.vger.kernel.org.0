Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CC943571E
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhJUAYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231947AbhJUAYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CEA46135F;
        Thu, 21 Oct 2021 00:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775718;
        bh=HE4PmzW54rEQQgoPfYsS2lGpZo21B1lfgplaFYBTJBo=;
        h=From:To:Cc:Subject:Date:From;
        b=hnCk+3r7MynwQCLzhskUQpZgdGsy1ot1+kXN2sIz6OKbAao6AIajI1YKgP8hZKLyD
         9LXn/jx2322apKkOiTMf+OQ1gu+ExoNrhdmBHyMHU9ZPe7UW3ZKt7zIApfQu+B1GEr
         A33WD1v3XFKIojpbejMjVhjZKoBk/wwmO6/nEPvyM/T6zeLSBFSd4bPl5Dyr5XO+f1
         4zatNbq+DW/6aK9r650Usva6LweyfVhzFZg5+Xq/62OVJ21Oa5cVXCyBuzh4GJ2eDF
         u6JkCzyOk9vmYu4txTvLEQl8YlVM3zpvGRBgZuRLDH9wAejnxCaiGctyikbBv+T80I
         I34PQpfdQL1Cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Kees Cook <keescook@chromium.org>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-hardening@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/14] gcc-plugins/structleak: add makefile var for disabling structleak
Date:   Wed, 20 Oct 2021 20:21:42 -0400
Message-Id: <20211021002155.1129292-1-sashal@kernel.org>
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
index 952e46876329..4aad28480035 100644
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

