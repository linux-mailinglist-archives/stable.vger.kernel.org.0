Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3BA12B6E5
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfL0RpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfL0RpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:45:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5883206CB;
        Fri, 27 Dec 2019 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468719;
        bh=rf5GDJhkL4Q+n2tNS9aPD1oxmd0VP+VQAoMT3YDuq3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3oMAdjN87xK1oS9IkJpf375CTNn0Idbja2m8VW7GBYXbnKCWCZ9sJPATWdlGrJI7
         +mk4i48GHJayvKYNX0Cgv5yyWH3H7XkN4JcU8UqDEhF8jzkn7Lsbrc6d8XxdH6+XcZ
         PQdu1BcdmgFjvI1t4nfnGAQG3Oq+PgCV50QpQVRY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kbuild test robot <lkp@intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 73/84] s390/purgatory: do not build purgatory with kcov, kasan and friends
Date:   Fri, 27 Dec 2019 12:43:41 -0500
Message-Id: <20191227174352.6264-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit c23587c92f6e3260fe3b82bb75b38aa2553b9468 ]

the purgatory must not rely on functions from the "old" kernel,
so we must disable kasan and friends. We also need to have a
separate copy of string.c as the default does not build memcmp
with KASAN.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/purgatory/Makefile | 6 ++++--
 arch/s390/purgatory/string.c | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/purgatory/string.c

diff --git a/arch/s390/purgatory/Makefile b/arch/s390/purgatory/Makefile
index ce6a3f75065b..fdccb7689bb9 100644
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -13,8 +13,10 @@ $(obj)/sha256.o: $(srctree)/lib/sha256.c FORCE
 $(obj)/mem.o: $(srctree)/arch/s390/lib/mem.S FORCE
 	$(call if_changed_rule,as_o_S)
 
-$(obj)/string.o: $(srctree)/arch/s390/lib/string.c FORCE
-	$(call if_changed_rule,cc_o_c)
+KCOV_INSTRUMENT := n
+GCOV_PROFILE := n
+UBSAN_SANITIZE := n
+KASAN_SANITIZE := n
 
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib
 LDFLAGS_purgatory.ro += -z nodefaultlib
diff --git a/arch/s390/purgatory/string.c b/arch/s390/purgatory/string.c
new file mode 100644
index 000000000000..c98c22a72db7
--- /dev/null
+++ b/arch/s390/purgatory/string.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0
+#define __HAVE_ARCH_MEMCMP	/* arch function */
+#include "../lib/string.c"
-- 
2.20.1

