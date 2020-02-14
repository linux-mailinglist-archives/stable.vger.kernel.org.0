Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C795C15F025
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388595AbgBNP63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388589AbgBNP62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E91424689;
        Fri, 14 Feb 2020 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695908;
        bh=p0xUTStllf1KM5Nebaqnyuhwek0/TARRJ3Sz6gsZpqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2VXRblYMnsi1qvPVcXFgz9ZzmBt0zy8BcgtSBjEg6TLn0kWaua1aEUIhYw0MMnio
         0Vb0Xbe86UnIFxPj/2Pi9LpYKGhxlgFjyYZ4/QHpZkZbL4aDLfDnKDH+xp2f+K/0oY
         z2RBdmUq2LlpnbmY3SjUy3WCBE1YnXdblhxtfODA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 448/542] btrfs: separate definition of assertion failure handlers
Date:   Fri, 14 Feb 2020 10:47:20 -0500
Message-Id: <20200214154854.6746-448-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

