Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E660D2FAA18
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404857AbhART0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:26:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390422AbhARLiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 243EB22CA1;
        Mon, 18 Jan 2021 11:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969838;
        bh=sssGw7VAmhQ9zYNCAgQ46mvt8+d/n+n3c7UnO0Lb+nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0Dt5EbA3PfM95yOWXBZUXnHMBJXZ0zluXuA0/+qOWQYomQbKls79cXkt2yDbFEOx
         MZxRxZG9uQhGnVlxZGZl1+2+7oLnFahamXKywNV33lybLGOq+XVPL55hoQqTZOqOEP
         qceZwrg7MtC2WNDl/nP38Ner88U1TO3lRbBszxjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-snps-arc@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/43] arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC
Date:   Mon, 18 Jan 2021 12:34:42 +0100
Message-Id: <20210118113335.870787462@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 09ddddf71cc50..a70fef79c4055 100644
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



