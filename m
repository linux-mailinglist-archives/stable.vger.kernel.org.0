Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3F62AF5D3
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 17:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgKKQJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 11:09:52 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:33036 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgKKQJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 11:09:50 -0500
Received: by mail-qv1-f67.google.com with SMTP id ec16so1144745qvb.0;
        Wed, 11 Nov 2020 08:09:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEt4hO6ja7OgZNFgw4N5lZTUfdc+bwEp6rbyTVEdUZw=;
        b=Im3GgbfWgXQ0+dAodGYY8JHAdgrROhBXOee4FPw9rInQB18wV2N1MzFOjz22POZTWx
         QP7ItLbvTDYSmeh+FA0KcaY52dc376aQzgxO9SgL0lqfdIbv69nOCa48AZvgXPL5zmSO
         mheLTwAGpVad8NtfF+pH4YcMXlmH0/4O9Ci6xSISzbDjNWO+OTpjNsWGcrZcHbdte6nq
         czzsanqKxh4Zz1aEu6BlssZpt4kc3cPhJ45iis4bXN4isKfiQbF/j4ZmYAJhdIVDkHFI
         af3cIpRCDMP23rXomy3Oog31ey0ab7E7+wmhQ2PYszK0ZnKn5MCk6ky18VyMjPfsB+xK
         v3Uw==
X-Gm-Message-State: AOAM530rggfYmbgZwYTK5/QRBozD1l+m4CzUgeOnrONmtkGNh/HoqN/r
        jg7uBYd0BcpyzsyCAxJz0VQ=
X-Google-Smtp-Source: ABdhPJynYiXd9K1JbtY/Kyb7JCB+at0iNsCRqhrm+BWcxCW7MosehRp2DccHFlVjCCFDxvJdfskseQ==
X-Received: by 2002:a0c:9e6b:: with SMTP id z43mr25223536qve.51.1605110989321;
        Wed, 11 Nov 2020 08:09:49 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id d82sm2459710qkc.14.2020.11.11.08.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 08:09:48 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] x86/mm: Remove duplicate definition of _PAGE_PAT_LARGE
Date:   Wed, 11 Nov 2020 11:09:46 -0500
Message-Id: <20201111160946.147341-2-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201111160946.147341-1-nivedita@alum.mit.edu>
References: <13073a85-24c1-6efa-578b-54218d21f49d@amd.com>
 <20201111160946.147341-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

_PAGE_PAT_LARGE is already defined next to _PAGE_PAT. Remove the
duplicate.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Fixes: 4efb56649132 ("x86/mm: Tabulate the page table encoding definitions")
---
 arch/x86/include/asm/pgtable_types.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 394757ee030a..f24d7ef8fffa 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -177,8 +177,6 @@ enum page_cache_mode {
 #define __pgprot(x)		((pgprot_t) { (x) } )
 #define __pg(x)			__pgprot(x)
 
-#define _PAGE_PAT_LARGE		(_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
-
 #define PAGE_NONE	     __pg(   0|   0|   0|___A|   0|   0|   0|___G)
 #define PAGE_SHARED	     __pg(__PP|__RW|_USR|___A|__NX|   0|   0|   0)
 #define PAGE_SHARED_EXEC     __pg(__PP|__RW|_USR|___A|   0|   0|   0|   0)
-- 
2.26.2

