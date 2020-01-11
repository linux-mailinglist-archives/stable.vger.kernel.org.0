Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0983137F4C
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgAKKSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730536AbgAKKSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:18:10 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43B3205F4;
        Sat, 11 Jan 2020 10:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737890;
        bh=rf5GDJhkL4Q+n2tNS9aPD1oxmd0VP+VQAoMT3YDuq3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHJfCI1IBKVNOXufUZju6cLSjDtPsd/zu+XPfii00ttbo/9vX7kIT+rHHGWHCHN0w
         T+zGFf5RKMfqcuPJ0qpwyIJKdCqwkFRpgM4wm4j36Ni2JeoP3tY+dFHGdoHNKyO8W3
         KiLDNgHA8ZLG9k7/C2EgBmRh5XNnOZC4ajscojXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/84] s390/purgatory: do not build purgatory with kcov, kasan and friends
Date:   Sat, 11 Jan 2020 10:50:29 +0100
Message-Id: <20200111094906.046347851@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



