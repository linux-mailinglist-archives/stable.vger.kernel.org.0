Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D33D0C16C3
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfI2Rcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbfI2RcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:32:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C81DF21920;
        Sun, 29 Sep 2019 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778336;
        bh=Wk4nPLxqKbyr+4wrsBpGefst6njL/ETV2Bw+Kk2IN90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPIshs4k7svUnq93haZEgezSIwjCLz/gtosVI28+60mnFWOgqSfEV3vL5U/WrA9QN
         twj3M+fpqB9B1YR+O8LgWWN1Hu5gBVH/Bwi4VqmitjPnYrGtDOAESINmxIBYq5H0Id
         +Pw2SJRbex2xEgyP1eF6VxH18BYtktLEgVF1Gu8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@mellanox.com>,
        Michal Hocko <mhocko@suse.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.3 42/49] mm: add dummy can_do_mlock() helper
Date:   Sun, 29 Sep 2019 13:30:42 -0400
Message-Id: <20190929173053.8400-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 710ec38b0f633ab3e2581f07a73442d809e28ab0 ]

On kernels without CONFIG_MMU, we get a link error for the siw driver:

drivers/infiniband/sw/siw/siw_mem.o: In function `siw_umem_get':
siw_mem.c:(.text+0x4c8): undefined reference to `can_do_mlock'

This is probably not the only driver that needs the function and could
otherwise build correctly without CONFIG_MMU, so add a dummy variant that
always returns false.

Link: http://lkml.kernel.org/r/20190909204201.931830-1-arnd@arndb.de
Fixes: 2251334dcac9 ("rdma/siw: application buffer management")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Jason Gunthorpe <jgg@mellanox.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0334ca97c584d..fe4552e1c40b4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1405,7 +1405,11 @@ extern void pagefault_out_of_memory(void);
 
 extern void show_free_areas(unsigned int flags, nodemask_t *nodemask);
 
+#ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
+#else
+static inline bool can_do_mlock(void) { return false; }
+#endif
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
 
-- 
2.20.1

