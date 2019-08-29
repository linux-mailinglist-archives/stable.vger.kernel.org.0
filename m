Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF3AA16B7
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfH2Kun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbfH2Kum (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 200EA23428;
        Thu, 29 Aug 2019 10:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075842;
        bh=JrorarxX0tWOFWXgQKQbgJPurWxAoIUAhi1ugVUbjl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCgjLwA6MuLqC8Gwl3WbxoRFq0Hfw6jLLpdwpVsy+nEgPaWrLd5Jp9EHflib4JFLS
         z+wJOkhh+jWYNyEin1dOLyWUjAOedMKPZdweC3RnuRh+naF3rhPW/g6gPhHYaLbDf1
         3/mn1bOdmhtNXfO29rteJmLHSTTsdOE4+9jI2vg4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jessica Yu <jeyu@kernel.org>, Martin Kaiser <lists@kaiser.cx>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        David Lechner <david@lechnology.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 28/29] modules: always page-align module section allocations
Date:   Thu, 29 Aug 2019 06:50:08 -0400
Message-Id: <20190829105009.2265-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Yu <jeyu@kernel.org>

[ Upstream commit 38f054d549a869f22a02224cd276a27bf14b6171 ]

Some arches (e.g., arm64, x86) have moved towards non-executable
module_alloc() allocations for security hardening reasons. That means
that the module loader will need to set the text section of a module to
executable, regardless of whether or not CONFIG_STRICT_MODULE_RWX is set.

When CONFIG_STRICT_MODULE_RWX=y, module section allocations are always
page-aligned to handle memory rwx permissions. On some arches with
CONFIG_STRICT_MODULE_RWX=n however, when setting the module text to
executable, the BUG_ON() in frob_text() gets triggered since module
section allocations are not page-aligned when CONFIG_STRICT_MODULE_RWX=n.
Since the set_memory_* API works with pages, and since we need to call
set_memory_x() regardless of whether CONFIG_STRICT_MODULE_RWX is set, we
might as well page-align all module section allocations for ease of
managing rwx permissions of module sections (text, rodata, etc).

Fixes: 2eef1399a866 ("modules: fix BUG when load module with rodata=n")
Reported-by: Martin Kaiser <lists@kaiser.cx>
Reported-by: Bartosz Golaszewski <brgl@bgdev.pl>
Tested-by: David Lechner <david@lechnology.com>
Tested-by: Martin Kaiser <martin@kaiser.cx>
Tested-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 3fda10c549a25..2dec3d4a9b627 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -76,14 +76,9 @@
 
 /*
  * Modules' sections will be aligned on page boundaries
- * to ensure complete separation of code and data, but
- * only when CONFIG_STRICT_MODULE_RWX=y
+ * to ensure complete separation of code and data
  */
-#ifdef CONFIG_STRICT_MODULE_RWX
 # define debug_align(X) ALIGN(X, PAGE_SIZE)
-#else
-# define debug_align(X) (X)
-#endif
 
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
-- 
2.20.1

