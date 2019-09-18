Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA35FB5CA9
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfIRG2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbfIRG13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706E2218AF;
        Wed, 18 Sep 2019 06:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788048;
        bh=Amq+M4DiCO97PAdKdNZc8x7IibU++eD91G9+f3YTBCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpXsaALkJxpQDLCHZ88wNytMkrTbJWXDSImplLJ2yHcjMtrWgYhLJX3i8ryFiEchA
         cq1/1BpzjGiCOgKSIjo19XR3nmXngn0bf9jTdgkogRFgIzHncXMBOb4j9NrNxv0V+5
         +lV+M0HStNUGUQAo9NCFi/1wkzK/y08jnpk2CdCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kaiser <lists@kaiser.cx>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        David Lechner <david@lechnology.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.2 79/85] modules: always page-align module section allocations
Date:   Wed, 18 Sep 2019 08:19:37 +0200
Message-Id: <20190918061237.881859124@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Yu <jeyu@kernel.org>

commit 38f054d549a869f22a02224cd276a27bf14b6171 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -64,14 +64,9 @@
 
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


