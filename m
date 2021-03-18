Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99619340F10
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 21:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhCRU3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 16:29:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:4540 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhCRU3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 16:29:18 -0400
IronPort-SDR: M4v4oLC0Q2PZdrAAgXc1VKnEnNFD43o/WM0Ji65ly/baar/XmGj82SOmFK5RIk2zdM4ngogvDL
 xqrHRmj78Y4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="187405824"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="187405824"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 13:29:17 -0700
IronPort-SDR: /duqs8LGb1pcam6TOOuo19fqDJYUwNc3hTdWoFo9woYvJCgHvkQNd2dWAyB9/xu0nlbiViaHpk
 Q4MW+VaaU5iA==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="602864941"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 13:29:17 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, bp@alien8.de,
        isaku.yamahata@gmail.com, thomas.lendacky@amd.com,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] X86: __set_clr_pte_enc() miscalculates physical address
Date:   Thu, 18 Mar 2021 13:26:57 -0700
Message-Id: <81abbae1657053eccc535c16151f63cd049dcb97.1616098294.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__set_clr_pte_enc() miscalculates physical address to operate.
pfn is in unit of PG_LEVEL_4K, not PGL_LEVEL_{2M, 1G}.
Shift size to get physical address should be PAGE_SHIFT,
not page_level_shift().

Fixes: dfaaec9033b8 ("x86: Add support for changing memory encryption attribute in early boot")
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/mm/mem_encrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 4b01f7dbaf30..ae78cef79980 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -262,7 +262,7 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 	if (pgprot_val(old_prot) == pgprot_val(new_prot))
 		return;
 
-	pa = pfn << page_level_shift(level);
+	pa = pfn << PAGE_SHIFT;
 	size = page_level_size(level);
 
 	/*
-- 
2.25.1

