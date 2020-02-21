Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA91167744
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgBUH5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:57:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbgBUH5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:57:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1232C20578;
        Fri, 21 Feb 2020 07:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271870;
        bh=p0xUTStllf1KM5Nebaqnyuhwek0/TARRJ3Sz6gsZpqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7cSjNBRc773IQHQ54qqiLRy0fmGSNZJ+9onA3hRfbQHSrMWOrBabp/9yYqQBn04J
         +aTCt19SOI0jdZlYS46UgydSs0aKIWpaORLWpPs8IdXYQxN8l9eYryVDhB2+55ybCZ
         caxAHUCAxTkeZgIWFeiYPpAXs+FJooUK2d2wIM9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 330/399] btrfs: separate definition of assertion failure handlers
Date:   Fri, 21 Feb 2020 08:40:55 +0100
Message-Id: <20200221072433.227703402@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 68c467cbb2f389b6c933e235bce0d1756fc8cc34 ]

There's a report where objtool detects unreachable instructions, eg.:

  fs/btrfs/ctree.o: warning: objtool: btrfs_search_slot()+0x2d4: unreachable instruction

This seems to be a false positive due to compiler version. The cause is
in the ASSERT macro implementation that does the conditional check as
IS_DEFINED(CONFIG_BTRFS_ASSERT) and not an #ifdef.

To avoid that, use the ifdefs directly.

There are still 2 reports that aren't fixed:

  fs/btrfs/extent_io.o: warning: objtool: __set_extent_bit()+0x71f: unreachable instruction
  fs/btrfs/relocation.o: warning: objtool: find_data_references()+0x4e0: unreachable instruction

Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ba7292435c14c..2e9f938508e9b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3108,17 +3108,21 @@ do {								\
 	rcu_read_unlock();					\
 } while (0)
 
-__cold
-static inline void assfail(const char *expr, const char *file, int line)
+#ifdef CONFIG_BTRFS_ASSERT
+__cold __noreturn
+static inline void assertfail(const char *expr, const char *file, int line)
 {
-	if (IS_ENABLED(CONFIG_BTRFS_ASSERT)) {
-		pr_err("assertion failed: %s, in %s:%d\n", expr, file, line);
-		BUG();
-	}
+	pr_err("assertion failed: %s, in %s:%d\n", expr, file, line);
+	BUG();
 }
 
-#define ASSERT(expr)	\
-	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+#define ASSERT(expr)						\
+	(likely(expr) ? (void)0 : assertfail(#expr, __FILE__, __LINE__))
+
+#else
+static inline void assertfail(const char *expr, const char* file, int line) { }
+#define ASSERT(expr)	(void)(expr)
+#endif
 
 /*
  * Use that for functions that are conditionally exported for sanity tests but
-- 
2.20.1



