Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEFC2AF5D4
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 17:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgKKQJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 11:09:52 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33724 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgKKQJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 11:09:49 -0500
Received: by mail-qk1-f196.google.com with SMTP id l2so2166807qkf.0;
        Wed, 11 Nov 2020 08:09:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rhNBtKMLkmOYknLswvSNLsfkudWIW4FsRnAgJTp7U74=;
        b=poT5Jn4Z0hBZuSqufkTl2E9ZxpGdb3aUdpI8dcFJY3PbdAmeSwCjg0Ec3Rjrud/znT
         YfKPNZAI4OZkzM15eG5C9KUk9SwcMXqPpCX3lMg3O9Z31lpzUbIdXQAWuHEQMYkjuV/W
         MTDx4UppXgyceFgvqQiUJDcXc+7cgZPsaoaWtz5GbC381qvw3oh0+iYp4A18/7NfJonb
         Y2+TczkVcXnseh3OeNf+x/sIqwf1VBMMwQ2p70l61MphO/blBPdmGgALjGri7DPU7TcC
         UAeXrfx+QvjR8Lem92SIX3Wa5VoMa45obyE/5ZWpb88S3ONpEN7LCl/s/ytet4QkWScD
         n3AA==
X-Gm-Message-State: AOAM531xWcZ9YXHBhNYpms+Qc5BXaLH0muYASPMZw9aBGjWyOom35ZGM
        7Yig+pDQHfYFofUouC/tYf0=
X-Google-Smtp-Source: ABdhPJwr5mXYJK+f5TRoYXyj5Heq2ajny374eU6X7pxmw3MmsGsLx//k42HI1QaDIaCxeUWR4VEk+A==
X-Received: by 2002:a05:620a:80d:: with SMTP id s13mr2278856qks.133.1605110987976;
        Wed, 11 Nov 2020 08:09:47 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id d82sm2459710qkc.14.2020.11.11.08.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 08:09:47 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] x86/mm/sme: Fix definition of PMD_FLAGS_DEC_WP
Date:   Wed, 11 Nov 2020 11:09:45 -0500
Message-Id: <20201111160946.147341-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <13073a85-24c1-6efa-578b-54218d21f49d@amd.com>
References: <13073a85-24c1-6efa-578b-54218d21f49d@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PAT bit is in different locations for 4k and 2M/1G page table
entries.

Add a definition for _PAGE_LARGE_CACHE_MASK to represent the three
caching bits (PWT, PCD, PAT), similar to _PAGE_CACHE_MASK for 4k pages,
and use it in the definition of PMD_FLAGS_DEC_WP to get the correct PAT
index for write-protected pages.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Fixes: 6ebcb060713f ("x86/mm: Add support to encrypt the kernel in-place")
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
---
 arch/x86/include/asm/pgtable_types.h | 1 +
 arch/x86/mm/mem_encrypt_identity.c   | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 816b31c68550..394757ee030a 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -155,6 +155,7 @@ enum page_cache_mode {
 #define _PAGE_ENC		(_AT(pteval_t, sme_me_mask))
 
 #define _PAGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)
+#define _PAGE_LARGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT_LARGE)
 
 #define _PAGE_NOCACHE		(cachemode2protval(_PAGE_CACHE_MODE_UC))
 #define _PAGE_CACHE_WP		(cachemode2protval(_PAGE_CACHE_MODE_WP))
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 733b983f3a89..6c5eb6f3f14f 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -45,8 +45,8 @@
 #define PMD_FLAGS_LARGE		(__PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL)
 
 #define PMD_FLAGS_DEC		PMD_FLAGS_LARGE
-#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_CACHE_MASK) | \
-				 (_PAGE_PAT | _PAGE_PWT))
+#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_LARGE_CACHE_MASK) | \
+				 (_PAGE_PAT_LARGE | _PAGE_PWT))
 
 #define PMD_FLAGS_ENC		(PMD_FLAGS_LARGE | _PAGE_ENC)
 
-- 
2.26.2

