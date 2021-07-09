Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141F63C2430
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhGINVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231917AbhGINVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBF0E61357;
        Fri,  9 Jul 2021 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836727;
        bh=PMRTvEShQzEn2+bkr+fk5C8BpeD20RIjfulk2Dc2K9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mf/HRz7Z9+fhwV81c7umMpr5UdrhCxe26GNL4oSluWsmOvC95GflZOU9/bPOUeaeV
         l7jye7BFRHMpt/Tud3LBTYZO1BdY7vFHaV8PeG2AE0zuwLnXUNxFcb2S6+BKOklrMS
         0ydmvWSbTnLqmr/Z4oHipBrPdI5ruuib1o8K336Y=
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
Subject: [PATCH 4.9 2/9] mm: add VM_WARN_ON_ONCE_PAGE() macro
Date:   Fri,  9 Jul 2021 15:18:29 +0200
Message-Id: <20210709131545.988367954@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
References: <20210709131542.410636747@linuxfoundation.org>
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
index deaba1cc3cfc..d1fb3bbff37a 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -36,6 +36,18 @@ void dump_mm(const struct mm_struct *mm);
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
@@ -47,6 +59,7 @@ void dump_mm(const struct mm_struct *mm);
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
-- 
2.30.2



