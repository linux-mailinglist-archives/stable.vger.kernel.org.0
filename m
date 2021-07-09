Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3F3C2455
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhGINWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhGINWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 346F76128A;
        Fri,  9 Jul 2021 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836772;
        bh=OsAW912EnxIIBeMknGEAHaC5qLWswKGKvuAOu/zl5gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/TOh+zf9z+LJZToCQzbzP/4RpmoA5De3TtvTlyRhbWa1xomPzXWZLur+6W5z7RnI
         F6THgshZoRKVgTE0nVGjqnnm8Z/XZzMSrRUKBWDW4pb5rL+lUpp/WXfj44c8qc8fFi
         /PGuvjLyL4yDOXFZRclbC+pKP792mdYU8Gg6z+F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Shi <alex.shi@linux.alibaba.com>,
        Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/25] mm: add VM_WARN_ON_ONCE_PAGE() macro
Date:   Fri,  9 Jul 2021 15:18:33 +0200
Message-Id: <20210709131629.344880174@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit a4055888629bc0467d12d912cd7c90acdf3d9b12 part ]

Add VM_WARN_ON_ONCE_PAGE() macro.

Link: https://lkml.kernel.org/r/1604283436-18880-3-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Note on stable backport: original commit was titled
mm/memcg: warning on !memcg after readahead page charged
which included uses of this macro in mm/memcontrol.c: here omitted.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmdebug.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 2ad72d2c8cc5..5d0767cb424a 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -37,6 +37,18 @@ void dump_mm(const struct mm_struct *mm);
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
+	static bool __section(".data.once") __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
+
 #define VM_WARN_ON(cond) (void)WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) (void)WARN_ONCE(cond, format)
@@ -48,6 +60,7 @@ void dump_mm(const struct mm_struct *mm);
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
-- 
2.30.2



