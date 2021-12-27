Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE2647FFD0
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbhL0PlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239420AbhL0Pjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A04C0619D9;
        Mon, 27 Dec 2021 07:38:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92C56CE10CC;
        Mon, 27 Dec 2021 15:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6103EC36AEA;
        Mon, 27 Dec 2021 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619502;
        bh=8B6eKPu1EARTYrAO6luOPP+2EBH0qmto8tzaeewAB7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbxH5HaXMb1gfx7d6G3XRA1kcnPakkbbVLsELzYvQq7Me0FkdXkHH2TPkV1v77EX/
         8A1PypoSKw5SYJxZe9V0Orv6E4WGLJcg0n3xdxLfKYIlkrhTV7+4nhGBDZ9+Gp5n0a
         fHhVZs/28aqafYrmrFvqkF3VcWMkD96o+rIjjfBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 47/76] x86/pkey: Fix undefined behaviour with PKRU_WD_BIT
Date:   Mon, 27 Dec 2021 16:31:02 +0100
Message-Id: <20211227151326.334537667@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 57690554abe135fee81d6ac33cc94d75a7e224bb upstream.

Both __pkru_allows_write() and arch_set_user_pkey_access() shift
PKRU_WD_BIT (a signed constant) by up to 30 bits, hitting the
sign bit.

Use unsigned constants instead.

Clearly pkey 15 has not been used in combination with UBSAN yet.

Noticed by code inspection only.  I can't actually provoke the
compiler into generating incorrect logic as far as this shift is
concerned.

[
  dhansen: add stable@ tag, plus minor changelog massaging,

           For anyone doing backports, these #defines were in
	   arch/x86/include/asm/pgtable.h before 784a46618f6.
]

Fixes: 33a709b25a76 ("mm/gup, x86/mm/pkeys: Check VMAs and PTEs for protection keys")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211216000856.4480-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1360,8 +1360,8 @@ static inline pmd_t pmd_swp_clear_uffd_w
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
-#define PKRU_AD_BIT 0x1
-#define PKRU_WD_BIT 0x2
+#define PKRU_AD_BIT 0x1u
+#define PKRU_WD_BIT 0x2u
 #define PKRU_BITS_PER_PKEY 2
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS


