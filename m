Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C4C18FC
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 20:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfI2Scf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 14:32:35 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34807 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729010AbfI2Sce (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 14:32:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so12438882wmc.1
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 11:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dKrYWAtUPlrt6JN6yYQvo9qzPk70geNGb7fz0ZvdlaA=;
        b=LbMTCWU6wXxZAM79YM1TxCuaM7KkHcS+1j3hK8zuzuUxDHbZqZt4m0sUcquIfGTIf2
         FFX9OLr+1R2rX2wtEYvcQN32WONAjYJFKvfeBNZdLeDEfH7tynpNuEifA+Epz7rwl515
         qc/wAi7OufYRan3bxGLjudDwa/m8frgi1o1YdUIyNXCL63rPOHuV9+2sO+kGOedVbmYZ
         oq8ts8Fn0DtEZVdcZvSPSpu04uFmkhui8MLx94qP8ZvqG/6kRcz20h2QSFiJAPbFjyh0
         d1U1QXEwdyrZkG9SpCKKJLfolcAxnPnjch9v8Fl4uDRqfqv+o0sHcNILmckSpc11HKGC
         6EaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dKrYWAtUPlrt6JN6yYQvo9qzPk70geNGb7fz0ZvdlaA=;
        b=Oy8TNOHrP++mC9dMQP//Gdc2oZEjIYyxyxTsLKq1ZXuxB0HC5Gr/15r5iMCDYN7XCu
         mQB3T1X/ir58Mz2hKiJOVOcWgWcLEZi+1ctHVh2d3Vy85W2ACiPq8t1x1fvNPvI/Lpx+
         8ev8eCesvz+l7KCeM2Fad6jHEwTVLZTXBIXLHlAEExQsm3eG8XDFuY62LM4EnlAsHH3Z
         r34yWhXjgl3fPDQvOeOjIHoz567Uxoh4Dm1jy3QfGuDwnAeTskqFZHQVRkd/zMud0QAI
         GhBiHBAYk+yMVk4wDKY36n4qWrkCR02dAsoNzWh7UOaf7cGmMHD3cumfFZBV4UQ6sE/U
         hf8w==
X-Gm-Message-State: APjAAAWmLN8P0yq8KIXXItsRN0OJqlXgjUJIaX/NT0kEMyxg6gdGtTeY
        4rtjjzjdcoatUFNZf4bjMNU=
X-Google-Smtp-Source: APXvYqwUF9Lqcklkv7jOvsWkx2r7yEwCKoOIOAnbuNB9XlHtXIaEvfxHBT+7ti6eiAXoWDQGTcsJfA==
X-Received: by 2002:a7b:c391:: with SMTP id s17mr15162720wmj.94.1569781950778;
        Sun, 29 Sep 2019 11:32:30 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id h125sm23686048wmf.31.2019.09.29.11.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 11:32:30 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, x86@kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.14] x86/retpolines: Fix up backport of a9d57ef15cbe
Date:   Sun, 29 Sep 2019 11:32:06 -0700
Message-Id: <20190929183206.922721-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a9d57ef15cbe ("x86/retpolines: Disable switch jump tables when
retpolines are enabled") added -fno-jump-tables to workaround a GCC issue
while deliberately avoiding adding this flag when CONFIG_CC_IS_CLANG is
set, which is defined by the kconfig system when CC=clang is provided.

However, this symbol was added in 4.18 in commit 469cb7376c06 ("kconfig:
add CC_IS_CLANG and CLANG_VERSION") so it is always undefined in 4.14,
meaning -fno-jump-tables gets added when using Clang.

Fix this up by using the equivalent $(cc-name) comparison, which matches
what upstream did until commit 076f421da5d4 ("kbuild: replace cc-name
test with CONFIG_CC_IS_CLANG").

Fixes: e28951100515 ("x86/retpolines: Disable switch jump tables when retpolines are enabled")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index cd596ca60901..3dc54d2f79c4 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -249,7 +249,7 @@ ifdef CONFIG_RETPOLINE
   # retpoline builds, however, gcc does not for x86. This has
   # only been fixed starting from gcc stable version 8.4.0 and
   # onwards, but not for older ones. See gcc bug #86952.
-  ifndef CONFIG_CC_IS_CLANG
+  ifneq ($(cc-name), clang)
     KBUILD_CFLAGS += $(call cc-option,-fno-jump-tables)
   endif
 endif
-- 
2.23.0

