Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6F82F3018
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbhALNCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405420AbhALM6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC6EA2312D;
        Tue, 12 Jan 2021 12:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456297;
        bh=zPb3uoCMpMg0zIdBDDDosH3CoWb00JMVhzJ0D614Sfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnWZe7jYXbndqJEpcGrhQv7J97EqfEVJk9gB/OqwruJWD4KT6vXrn1LZkmCJb/TfL
         L6k+CsN5GrPQZHDxUmIXS/LmiPmglS8AjlYfR28Wxl0Sgr99KfeCeQuvhwAfTUpcuR
         sMtEzPkClMz4DATC+qGKiaaoiaKxfUilJkOIMqr3XufQjfAlCxzZb6OiPvhyAO9mxF
         oP7DHzr6H2c9ygoxKrfwKYK98+PTeNx7fhR4wO2vu6kuWXT9A73fl2ijoNa4zmNj2c
         QyCT+W+XlfanQxgLoygJ9w5GO1PYVN0TwEhQxwdCi6/jnHmC4Hhrg0nxg62SjlYM8h
         ZZlEVqazWuh0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-snps-arc@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 4/8] arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC
Date:   Tue, 12 Jan 2021 07:58:05 -0500
Message-Id: <20210112125810.71348-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125810.71348-1-sashal@kernel.org>
References: <20210112125810.71348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8a48c0a3360bf2bf4f40c980d0ec216e770e58ee ]

fs/dax.c uses copy_user_page() but ARC does not provide that interface,
resulting in a build error.

Provide copy_user_page() in <asm/page.h>.

../fs/dax.c: In function 'copy_cow_page_dax':
../fs/dax.c:702:2: error: implicit declaration of function 'copy_user_page'; did you mean 'copy_to_user_page'? [-Werror=implicit-function-declaration]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-snps-arc@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>
#Acked-by: Vineet Gupta <vgupta@synopsys.com> # v1
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
#Reviewed-by: Ira Weiny <ira.weiny@intel.com> # v2
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/page.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index ffb5f33475f19..f0f43eb709d2f 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -13,6 +13,7 @@
 #ifndef __ASSEMBLY__
 
 #define clear_page(paddr)		memset((paddr), 0, PAGE_SIZE)
+#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 #define copy_page(to, from)		memcpy((to), (from), PAGE_SIZE)
 
 struct vm_area_struct;
-- 
2.27.0

