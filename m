Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD00CD66A
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfJFRr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731081AbfJFRoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:44:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4D920700;
        Sun,  6 Oct 2019 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383857;
        bh=Wk4nPLxqKbyr+4wrsBpGefst6njL/ETV2Bw+Kk2IN90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJ1puECRoIcd+FrFA8SGucMZ6EUKY61KCtCSawUNl5iewPSX/kWrA7f5lLRhnTEt6
         g4MeZZ6fApymsN42IiWBFV4R+/CqKt1ty2husDThs5BqOJMH1FmDZIpkVAwoEMgvL5
         uqWJTT8KpNcArUMnjPSgT1VkLxvMTycTXgyxUXYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Michal Hocko <mhocko@suse.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 120/166] mm: add dummy can_do_mlock() helper
Date:   Sun,  6 Oct 2019 19:21:26 +0200
Message-Id: <20191006171223.408924054@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



